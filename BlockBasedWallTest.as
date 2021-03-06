﻿package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.system.System;
	
	[SWF(width="1200", height="700", fps="24", bgColor="#000")]
	public class BlockBasedWallTest extends Sprite
	{
		private var gal:BlockBasedWallMain;
		private var traceTF:TextField;
		private var areaTF:TextField;
		
		public function BlockBasedWallTest()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, debugInfo, false, 0, true);
		}
		
		private function onAddedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			stage.addEventListener(MouseEvent.CLICK, redraw, false, 0, true);
			stage.addEventListener(Event.RESIZE, onStageResizedHandler, false, 0, true);
			
			traceTF = new TextField();
			traceTF.y = 610;
			areaTF = new TextField();
			areaTF.y = 650;
			addChild(traceTF);
			addChild(areaTF);
			
			gal = new BlockBasedWallMain(this.width, this.height);
			addChild(gal);
			
			stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function redraw(event:Event=null):void
		{
			var bd:Vector.<Array> = new Vector.<Array>();
			bd.push([2,2], [3,3], [4,4], [1,2], [3,1]);
			gal.init(bd);
			gal.updateView();
			
			areaTF.text = "Total area: " + String(gal.totalAreaBlocks);
		}
		
		private function debugInfo(event:Event=null):void
		{
			traceTF.text = "Mem: " + (System.totalMemoryNumber / 1024 / 1024).toFixed(2) + "MB";
		}
		
		private function onStageResizedHandler(event:Event):void
		{
			gal.setSize(400, stage.stageWidth-40);
			redraw();
			
			traceTF.x = stage.stageWidth - traceTF.width - 20;
			areaTF.x = stage.stageWidth - areaTF.width - 20;
		}

	}
	
}
