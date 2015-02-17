package
{
	import flash.net.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.system.*;
	import flash.display.*;

	import bmpcache.*;

	[SWF(width='1440', height='900')]

	public class Demo extends Sprite
	{
		private var 
			_tick        : uint,
			_test_sp     : Sprite,
			_mouse_pos   : Point,
			_assts       : Vector.<Asset>,
			_asset_bytes : ByteArray;

		private static var _instance : Demo;  

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
			stage.quality = StageQuality.MEDIUM;

			AssetManager.inst.init(stage, 1024000);

			stage.addEventListener(Event.ENTER_FRAME, onUpdate, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);

			loadAsset();
		}

		private function onUpdate(event:Event):void
		{
			AssetManager.inst.tick();			

			for each(var asset:Asset in _assts)
			{
				asset.gotoFrame(1 + (_tick % (50 - 1 + 1)));
			}

			++_tick;
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
			var scaleNum:int = int(event.delta);

			if (_test_sp.scaleX >= .5 && _test_sp.scaleX <= 1)
			{
				_test_sp.scaleX = _test_sp.scaleY -= scaleNum / 50;
			}

			if (_test_sp.scaleX < .5) _test_sp.scaleX = _test_sp.scaleY = .5;
			if (_test_sp.scaleX > 1) _test_sp.scaleX = _test_sp.scaleY = 1;

			AssetManager.inst.scale = _test_sp.scaleX < 1;
		}

		private function loadAsset():void
		{
			var loader:URLLoader = new URLLoader();

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
			_assts = new Vector.<Asset>();

			for (var i:uint = 0; i < 1; ++i) 
			{
				showAsset();
			}
		}

		private var iX:int, iY:int;

		private function showAsset():void
		{
			if (_asset_bytes)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComp);
				loader.loadBytes(_asset_bytes);

				function onComp(evnet:Event):void
				{
					var mc:MovieClip = loader.content as MovieClip;

					//mc.x = Math.random() * stage.stageWidth;
					//mc.y = Math.random() * stage.stageHeight;

					if (iX < ((iY + 1) * 6))
					{
						mc.x = (iX - (iY * 6)) * mc.width;
						mc.y = iY * mc.height;
					}else 
					{
						++iY;
						mc.x = (iX - (iY * 6)) * mc.width;
						mc.y = iY * mc.height;
					}
					++iX;

					var asset:Asset = new Asset(this);
					asset.setSource(mc.cow, 'cow_black_anim');
					asset.switchAnim(1, 50);

					_assts.push(asset);
					_test_sp.addChild(mc);
				}
			}
		}
	}
}
