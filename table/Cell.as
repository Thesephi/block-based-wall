package table
{
	public class Cell
	{
		public var top:Cell;
		public var bottom:Cell;
		public var left:Cell;
		public var right:Cell;
		
		public var available:Boolean = true;
		
		private var _xPos:int;
		private var _yPos:int;
		
		public function Cell(xPos:int, yPos:int)
		{
			_xPos = xPos;
			_yPos = yPos;
		}
		
		public function get xPos():int
		{
			return this._xPos;
		}
		public function get yPos():int
		{
			return this._yPos;
		}
	}
	
}
