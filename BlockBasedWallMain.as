﻿package
{
	import flash.display.Sprite;
	import flash.display.GraphicsPathCommand;
	import table.Cell;
	
	/*
	 * Usage of this Class:
	 * - create a BlockBasedWallMain instance
	 * - call its "init" method to supply blocks with custom dimensions (larger than 1x1)
	 * - call its "updateView" method
	 * - "init" and "updateView" could be called over and over again, every time
	 *   with a new set of block data
	 */
	public class BlockBasedWallMain extends Sprite
	{
		public static const FAVOUR_WIDTH:String = "favourWidth";
		public static const FAVOUR_HEIGHT:String = "favourHeight";
		
		protected var _blockWidth:Number = 80;
		protected var _blockHeight:Number = 80;
		protected var _wid:Number;
		protected var _hei:Number;
		
		protected var _blockDat:Vector.<Array>;
		protected var _table:Vector.<Vector.<Cell>>;
		protected var _blocks:Vector.<Block>;
		
		protected var _holder:Sprite;
		
		public function BlockBasedWallMain(canvasWidth:Number=NaN, canvasHeight:Number=NaN,
										   blockWidth:Number=NaN, blockHeight:Number=NaN)
		{
			if(isNaN(canvasWidth))
				_wid = super.width;
			if(isNaN(canvasHeight))
				_hei = super.height;
			
			if(!isNaN(blockWidth))
				_blockWidth = blockWidth;
			if(!isNaN(blockHeight))
				_blockHeight = blockHeight;
				
			// in case this instance was created and put on stage during authoring time
			// it's likely that it holds some display objects already
			// we'll need to get rid of these
			var n:int = this.numChildren;
			for(var i:int = 0; i < n; i++)
			{
				this.removeChildAt(0);
			}
			
			// now create something to store our blocks
			_holder = new Sprite();
			addChild(_holder);
			
			// optional
			//drawGrid();
		}
		
		/*
		 * @param blockData an optional Vector holding Array objects, 
		 * each specifying a custom Block dimension (widthxheight) value
		 */
		public function init(blockData:Vector.<Array> = null):void
		{
			// fill the available area with blocks of unit dimension (1x1)
			// so that if there's no custom-sized blocks supplied, we still
			// have something nice to display
			_blockDat = new Vector.<Array>();
			for(var u:int = 0; u < this.totalArea; u++)
			{
				_blockDat.push([1,1]);
			}
			
			if(!blockData)
				blockData = new Vector.<Array>();
			
			// as we add in more custom (widthxheight) blocks, let's remove the default (1x1) blocks
			// that take the equal amount of added area (widthxheight)
			for(var i:int = 0; i < blockData.length; i++)
			{
				var addedArea:int = blockData[i][0] * blockData[i][1];
				this._blockDat.push(blockData[i]);
				for(var j:int = 0; j < addedArea; j++)
				{
					this._blockDat.shift();
				}
			}
			
			// shuffle everything!
			this._blockDat = vectorShuffle(this._blockDat);
			
			// actually create Block instances and populate the _blocks Vector
			// ready to be added to Stage by calling the 'updateView' method
			setupBocks();
		}
		
		protected function setupBocks():void
		{
			// update the _table Vector, preparing for a new setup
			this.setupTable();
			
			// clear the _block Vector, preparing to hold new Block instances
			this._blocks = new Vector.<Block>();
			
			var rn:int = this.optimizedRowNum;
			var cn:int = this.optimizedColNum;
			
			var dims:Vector.<Array> = this._blockDat.concat(); // shallow copy the _blockDat Vector
			var dim:Array = dims.shift();
			while(dim)
			{
				// create a block with appropriate dimension and position
				var rowId:int = 0;
				var colId:int = -1;
				while(colId == -1)
				{
					colId = this.getNextPossibleXPos(rowId, dim);
					
					if(colId == -1)
					{
						// if there's no space available on the current line, check the next line
						rowId += 1;
						
						// proactively add a row to the _table Vector when needed
						var newRowNum:int = rowId + dim[1];
						if(newRowNum > _table.length)
						{
							var numRowToAdd:int = newRowNum - _table.length;
							trace(this + "Space not enough, about to add " + numRowToAdd + " new row(s).");
							this.addRowToCellTable(numRowToAdd);
						}
					}
					else
					{
						// mark the space available to be unavailable 
						// cause we're gonna fill it with a Block instance!)
						setSpaceUnavailable(colId, rowId, dim);
					}
				}
				
				var block:Block = new Block(colId, rowId, dim[0], dim[1], _blockWidth, _blockHeight, null, true);
				this._blocks.push(block);
				
				// now proceed with next block
				dim = dims.shift();
			}
		}
		
		protected function setupTable():void
		{
			_table = new Vector.<Vector.<Cell>>();
			this.addRowToCellTable(this.optimizedRowNum);
		}
		
		protected function addRowToCellTable(numRowToAdd:int=1):void
		{
			while(numRowToAdd > 0)
			{
				var newRow:Vector.<Cell> = new Vector.<Cell>();
				var rowId:int = _table.push(newRow)-1;
				var cn:int = this.optimizedColNum;
				for(var colId:int = 0; colId < cn; colId++)
				{
					var newCell:Cell = new Cell(colId, rowId);
					newRow.push(newCell);
					
					if(colId > 0)
					{
						var cellLeft:Cell = _table[rowId][colId-1];
						newCell.left = cellLeft;
						cellLeft.right = newCell;
					}
					
					if(rowId > 0)
					{
						var topCell:Cell = _table[rowId-1][colId];
						newCell.top = topCell;
						topCell.bottom = newCell;
					}
				}
				numRowToAdd--;
			}
			
			trace(this + "Table now has " + _table.length + " row(s).");
		}
		
		/*
		 * Please notice that this function only check if a space is available in a certain row
		 * It does NOT make this space unvailable, until 'setSpaceUnavailable' method is used
		 */
		protected function getNextPossibleXPos(rowId:int, dim:Array):int
		{
			var cn:int = this.optimizedColNum;
			var xPos:int = 0;
			
			while(xPos + dim[0]-1 < cn)
			{
				if(this.isSpaceAvail(xPos, rowId, dim))
					return xPos;
				else
					xPos += 1;
			}
			return -1;
		}
		
		protected function isSpaceAvail(colId:int, rowId:int, dim:Array):Boolean
		{
			for(var r:int = rowId; r < rowId+dim[1]; r++)
			{
				// for each row
				var toCheck:int = dim[0];
				var cell:Cell = _table[r][colId];
				while(toCheck > 0 && cell && cell.available)
				{
					// each cell available decreases toCheck by 1
					// so if all cells are available, toCheck should equal 0
					cell = cell.right;
					toCheck--;
				}
				
				if(toCheck > 0)
					return false;
			}
			return true;
		}
		
		protected function setSpaceUnavailable(xPos:Number, yPos:Number, dim:Array):void
		{
			for(var a:int = 0; a < dim[1]; a++)
			{
				for(var b:int = 0; b < dim[0]; b++)
				{
					var line:Vector.<Cell> = _table[yPos + a];
					var cell:Cell = line[xPos + b];
					cell.available = false;
				}
			}
		}
		
		/*
		 * This method can be improved to add transition effects, but not actually useful :)
		 */
		public function updateView():void
		{
			var n:int = this._holder.numChildren;
			for(var i:int = 0; i < n; i++)
			{
				_holder.removeChildAt(0);
			}
			
			for each(var block:Block in this._blocks)
			{
				_holder.addChild(block);
			}
			
			//this.drawGrid();
		}
		
		protected function drawGrid():void
		{
			var vLineNo:int = colNum + 1;
			var hLineNo:int = rowNum + 1;
			var curLineX:Number = 0;
			var curLineY:Number = 0;
			
			_holder.graphics.clear();
			_holder.graphics.lineStyle(2, 0x000000, 0.3);
			
			// draw all v lines
			for(var i:int = 0; i < vLineNo; i++)
			{
				var vcmd:Vector.<int> = new Vector.<int>();
				vcmd.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
				
				var vdat:Vector.<Number> = new Vector.<Number>();
				vdat.push(curLineX,0, curLineX,rowNum*_blockHeight);
				
				_holder.graphics.drawPath(vcmd,vdat);
				curLineX += _blockWidth;
			}
			
			// draw all h lines
			for(var j:int = 0; j < hLineNo; j++)
			{
				var hcmd:Vector.<int> = new Vector.<int>();
				hcmd.push(1, 2);
				
				var hdat:Vector.<Number> = new Vector.<Number>();
				hdat.push(0,curLineY, colNum*_blockWidth,curLineY);
				
				_holder.graphics.drawPath(hcmd,hdat);
				curLineY += _blockHeight;
			}
		}
		
		protected function get optimizedColNum():int
		{
			return Math.floor(_wid/_blockWidth);
		}
		
		protected function get optimizedRowNum():int
		{
			return Math.floor(_hei/_blockHeight);
		}
		
		public function get totalArea():int
		{
			return optimizedColNum * optimizedRowNum;
		}
		
		public function get totalAreaBlocks():int
		{
			var res:int = 0;
			for each(var block:Block in this._blocks)
			{
				res += block.area;
			}
			return res;
		}
		
		public function get colNum():int
		{
			return _table[0].length;
		}
		public function get rowNum():int
		{
			return _table.length;
		}
		
		public function setSize(wid:Number, hei:Number):void
		{
			this._wid = wid;
			this._hei = hei;
		}
		
		/*
		 * A very primitive function to shuffle a Vector
		 * @return the shuffled Vector
		 */
		public function vectorShuffle(arr:*):*
		{
			// use a shallow clone of the original Vector because we don't want to mess it up
			arr = arr.concat();
			
			// effectively create a new, blank Vector with the same T value as the old one, whatever it is
			var arr2:* = arr.splice(0,0);
			
			// now everyday i'm shuffling...
			while(arr.length > 0)
			{
				arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			
			return arr2;
		}

	}
	
}
