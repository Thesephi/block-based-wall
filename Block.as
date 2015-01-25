package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Block extends Sprite
	{
		protected var _xSpace:int = 1;
		protected var _ySpace:int = 1;
		
		protected var _xPnt:int = 0;
		protected var _yPnt:int = 0;
		
		protected var _blockWidth:Number;
		protected var _blockHeight:Number;
		
		public function Block(xPnt:int,yPnt:int,
							  xSpace:int, ySpace:int,
							  blockWid:Number, blockHei:Number,
							  favourOrientation:String = null,
							  debug:Boolean = false)
		{
			if(!favourOrientation)
				favourOrientation = BlockBasedWallMain.FAVOUR_HEIGHT;
			
			if(favourOrientation == BlockBasedWallMain.FAVOUR_WIDTH)
			{
				this._xPnt = xPnt;
				this._yPnt = yPnt;
				
				this._xSpace = xSpace;
				this._ySpace = ySpace;
				
				this._blockWidth = blockWid;
				this._blockHeight = blockHei;
				
				this.x = this._xPnt*this._blockWidth;
				this.y = this._yPnt*this._blockHeight;
			}
			else
			{
				this._xPnt = yPnt;
				this._yPnt = xPnt;
				
				this._xSpace = ySpace;
				this._ySpace = xSpace;
				
				this._blockWidth = blockHei;
				this._blockHeight = blockWid;
				
				this.x = this._xPnt*this._blockWidth;
				this.y = this._yPnt*this._blockHeight;
			}
			
			if(debug)
			{
				var color:* = "0x"+(Math.random()*16777215).toString(16);
				graphics.beginFill(color, 0.3);
				graphics.lineStyle(2, 0x000000, 0.3);
				graphics.drawRect(0, 0, this._blockWidth*this._xSpace, this._blockHeight*this._ySpace);
				graphics.endFill();
				
				var textColor:uint = (_xSpace > 1 || _ySpace > 1)? 0xCC0000 : 0x000000;
				var tf:TextField = new TextField();
				tf.autoSize = "left";
				tf.defaultTextFormat = new TextFormat(null, 10, textColor, true, null, null, null, null, "center");
				tf.text = xPnt + " " + yPnt + "\n" + _xSpace + " " + _ySpace;
				tf.x = this.width/2 - tf.width/2;
				tf.y = this.height/2 - tf.height/2;
				addChild(tf);
			}
		}
		
		public function get area():int
		{
			return this._xSpace * this._ySpace;
		}

	}
	
}
