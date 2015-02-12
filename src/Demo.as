package
{
	import flash.net.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.system.*;
	import flash.display.*;

	[SWF(width='1440', height='900')]

	public class Demo extends Sprite
	{
		private var 
			_tick        : uint,
			_test_sp     : Sprite,
			_mouse_pos   : Point,
			_asset_bytes : ByteArray;

		private static var 
			_instance : Demo;  

		public var 
			asset_list : Vector.<MovieClip>;

		public function Demo()
		{
			if (stage)
			{
				init();
			}else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		public static function get inst():Demo
		{
			return _instance;
		}

		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			_instance = this;

			stage.frameRate = 20;
			stage.stageFocusRect = false;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;

			stage.addEventListener(Event.ENTER_FRAME, onUpdate, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);

			loadAsset();
		}

		private function onUpdate(event:Event):void
		{
			_tick++;

			for each(var mc:MovieClip in asset_list)	
			{
				mc.cow.gotoAndStop(_tick % mc.cow.totalFrames);
			}
		}

		private function onMouseDown(event:MouseEvent):void
		{
			_mouse_pos = new Point(event.stageX, event.stageY);
		}

		private function onMouseUp(event:MouseEvent):void
		{
			_mouse_pos = null;
		}

		private function onMouseMove(event:MouseEvent):void
		{
			if (_mouse_pos)
			{
				_test_sp.x += (event.stageX - _mouse_pos.x);
				_test_sp.y += (event.stageY - _mouse_pos.y);

				_mouse_pos.x = event.stageX;
				_mouse_pos.y = event.stageY;
			}
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			if (event.delta < 0)
			{
				_test_sp.scaleX = 1;
				_test_sp.scaleY = 1;
			}else
			{
				_test_sp.scaleX = 0.5;
				_test_sp.scaleY = 0.5;
			}
		}

		private function loadAsset():void
		{
			var loader : URLLoader = new URLLoader();

			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoaded);
			loader.load(new URLRequest('cow_black.swf'));
		}

		private function onLoaded(event:Event):void
		{
			_asset_bytes = event.target.data as ByteArray;

			_test_sp = new Sprite();
			_test_sp.mouseEnabled = false;
			_test_sp.mouseChildren = false;

			stage.addChild(_test_sp);

			test();		
		}

		private function test():void
		{
			asset_list = new Vector.<MovieClip>();

			for (var i:uint = 0; i < 100; ++i)
			{
				showAsset();
			}
		}

		private function showAsset():void
		{
			if (_asset_bytes)
			{
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComp);
				loader.loadBytes(_asset_bytes);

				function onComp(evnet:Event):void
				{
					var mc : MovieClip = loader.content as MovieClip;
					asset_list.push(mc);
					_test_sp.addChild(mc);

					mc.x = Math.random() * 2000;
					mc.y = Math.random() * 2000;
					//mc.cow.visible = false;
				}
			}
		}
	}
}
