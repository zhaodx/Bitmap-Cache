package bmpcache
{
	import flash.display.*;

	public class AnimationManager
	{
		public static const BLANK : BitmapData = new BitmapData(1, 1, true, 0);

		private var 
			_tick          : uint,
			_cacheSize     : uint,
			_frameList     : Vector.<Frame>,
			_animations    : Object,
			_animationList : Vector.<Animation>;

		private static var _instance : AnimationManager;
						
		public static function get inst():AnimationManager
		{
			if (!_instance)
			{
				_instance = new AnimationManager();
			}

			return _instance;
		}

		public function init(cacheMemony:uint=500):void
		{
			_cacheSize = cacheMemony;	

			_animations = {};
			_frameList = new Vector.<Frame>();
			_animationList = new Vector.<Animation>();
		}

		public function addAnimation(animation:Animation):void
		{
			if (!_animations[animation.id])
			{
				_animations[animation.id] = new Vector.<Frame>(animation.frameNums, true);
			}

			_animationList.push(animation);
		}

		public function addFrame(animationId:String, frame:Frame):void
		{
			_frameList.push(frame);
			(_animations[animationId] as Vector.<Frame>)[frame.index] = frame; 
		}

		public function getFrame(animationId:String, index:uint):Frame
		{
			var frame:Frame = (_animations[animationId] as Vector.<Frame>)[index];

			return frame ? frame : new Frame();
		}

		public function render():void
		{
			_tick++;

			for each (var animation:Animation in _animationList)
			{
				if (animation.playAble)
				{
					animation.render(_tick);
				}
			}
		}
	}
}
