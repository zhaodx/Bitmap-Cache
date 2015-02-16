package bmpcache
{
	import flash.display.*;
	import flash.utils.*;

	public class AnimManager 
	{
		private var 
			_tick      : uint,
			_anims     : Object,
			_animList  : Array,
			_cacheSize : uint,
			_reference : Object;

		private static var _instance : AnimManager;

		public var 
			stage      : Stage,
			currMemory : uint;

		public static const BLANK : BitmapData = new BitmapData(1, 1, true, 0);
						
		public static function get inst():AnimManager
		{
			if (!_instance) _instance = new AnimManager();

			return _instance;
		}

		public function init(stg:Stage, cacheMemony:uint=512000):void
		{
			stage = stg;

			_anims = {};
			_animList = [];
			_reference = {};
			_cacheSize = cacheMemony << 10;
		}

		public function addAnim(anim:BaseAnim):void
		{
			if (!_anims[anim.id])
			{
				_reference[anim.id] = 0;
				_anims[anim.id] = new Vector.<Frame>(anim.frameNums, true);
			}

			_animList.push(anim);

			ttlReset(anim);
		}

		public function ttlReset(anim:BaseAnim):void
		{
			if (anim.ttl == 0)
			{
				_reference[anim.id]++;
			}

			anim.ttl = 1; //+ Math.random() * 100;
		}

		private function addFrame(sid:String, frame:Frame):void
		{
			(_anims[sid] as Vector.<Frame>)[frame.index] = frame; 
		}

		public function getFrame(sid:String, frameIndex:uint=0):Frame
		{
			var frame:Frame = (_anims[sid] as Vector.<Frame>)[frameIndex];

			if (!frame)
			{
				frame = new Frame();
				frame.index = frameIndex;

				addFrame(sid, frame);
			}

			return frame;
		}

		public function render():void
		{
			for each (var anim:BaseAnim in _animList)
			{
				if (anim.renderAble) anim.render(_tick);
				if (anim.ttl > 0) ++anim.ttl;
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
			_animList.sortOn('ttl', Array.DESCENDING | Array.NUMERIC);
			var anim:BaseAnim = _animList[0] as BaseAnim;

			if (anim.ttl < 100) return;

			anim.ttl = 0;
			_reference[anim.id]--;

			if (_reference[anim.id] > 0) return;

			for each(var frame:Frame in (_anims[anim.id] as Vector.<Frame>))
			{
				if (frame) frame.release();
			}
		}

		public static function getClassName(classOrInst:*):String
		{
			var description:String = getQualifiedClassName(classOrInst);
			var index:int = description.lastIndexOf(':');

			if (index != -1) return description.slice(index + 1);
			return description;
		}
	}
}
