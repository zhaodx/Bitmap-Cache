package bmpcache
{
	import flash.display.*;
	import flash.utils.*;

	public class AssetManager 
	{
		private var 
			_assets    : Object,
			_animList  : Array,
			_cacheSize : uint,
			_reference : Object;

		private static var _instance : AssetManager;

		public var 
			stage      : Stage,
			currMemory : uint;

		public static const BLANK : BitmapData = new BitmapData(1, 1, true, 0);
						
		public static function get inst():AssetManager
		{
			if (!_instance) _instance = new AssetManager();

			return _instance;
		}

		public function init(stg:Stage, cacheMemony:uint=512000):void
		{
			stage = stg;

			_assets = {};
			_animList = [];
			_reference = {};
			_cacheSize = cacheMemony << 10;
		}

		public function addAsset(key:String, totalFrames:uint):void
		{
			if (!_assets[key])
			{
				_assets[key] = new Vector.<Frame>(totalFrames, true);
			}
		}

		public function addAnim(anim:Animation):void
		{
			if (!_reference[anim.id])
			{
				_reference[anim.id] = 0;
			}

			ttlReset(anim);
			_animList.push(anim);
		}

		private function ttlReset(anim:Animation):void
		{
			if (anim.ttl == 0) _reference[anim.id]++;
			if (anim.renderAble || anim.isCurrAnim) anim.ttl = 1; //+ Math.random() * 100;
		}

		public function addFrame(aid:String, frame:Frame):void
		{
			(_assets[aid] as Vector.<Frame>)[frame.index] = frame; 
		}

		public function getFrame(aid:String, frameIndex:uint=0):Frame
		{
			return (_assets[aid] as Vector.<Frame>)[frameIndex];
		}

		public function tick():void
		{
			for each (var anim:Animation in _animList)
			{
				if (anim.ttl > 0) ++anim.ttl;
				ttlReset(anim);
			}

			if (!cacheAble) release();
		}

		public function get cacheAble():Boolean
		{
			return currMemory < _cacheSize;
		}

		private function release():void
		{
			_animList.sortOn('ttl', Array.DESCENDING | Array.NUMERIC);
			var anim:Animation = _animList[0] as Animation;

			if (anim.ttl < 100) return;

			anim.ttl = 0;
			_reference[anim.id]--;

			if (_reference[anim.id] > 0) return;

			//for each(var frame:Frame in (_anims[anim.id] as Vector.<Frame>))
			//{
			//	if (frame) frame.release();
			//}
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
