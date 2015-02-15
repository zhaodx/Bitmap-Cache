package bmpcache
{
	import flash.display.*;

	public class AnimationManager
	{
		public static const BLANK : BitmapData = new BitmapData(1, 1, true, 0);

		public var currMemory : uint;

		private var 
			_tick          : uint,
			_cacheSize     : uint,
			_animations    : Object,
			_animationList : Array;

		private static var _instance : AnimationManager;
						
		public static function get inst():AnimationManager
		{
			if (!_instance) _instance = new AnimationManager();

			return _instance;
		}

		public function init(cacheMemony:uint=512000):void
		{
			_cacheSize = cacheMemony << 10;

			_animations = {};
			_animationList = [];
		}

		public function addAnimation(animation:Animation):void
		{
			if (!_animations[animation.id])
			{
				_animations[animation.id] = new Vector.<Frame>(animation.frameNums, true);
			}

			_animationList.push(animation);
		}

		private function addFrame(animationId:String, frame:Frame):void
		{
			(_animations[animationId] as Vector.<Frame>)[frame.index] = frame; 
		}

		public function getFrame(animationId:String, frameIndex:uint):Frame
		{
			var frame:Frame = (_animations[animationId] as Vector.<Frame>)[frameIndex];

			if (!frame)
			{
				frame = new Frame();
				frame.index = frameIndex;

				addFrame(animationId, frame);
			}

			return frame;
		}

		public function render():void
		{
			for each (var animation:Animation in _animationList)
			{
				if (animation.playAble) animation.render(_tick);
				if (animation.ttl > 0) ++animation.ttl;
			}

			++_tick;

			if (!cacheAble) release();
		}

		public function get cacheAble():Boolean
		{
			return currMemory < _cacheSize;
		}

		private function release():void
		{
			_animationList.sortOn('ttl', Array.DESCENDING | Array.NUMERIC);
			var animation:Animation = _animationList[0] as Animation;

			if (animation.ttl < 100) return;

			for each(var frame:Frame in (_animations[animation.id] as Vector.<Frame>))
			{
				if (frame) frame.release();
			}

			animation.ttl = 0;
		}
	}
}
