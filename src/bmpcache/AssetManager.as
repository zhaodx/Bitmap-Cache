package bmpcache
{
	import flash.display.*;
	import flash.utils.*;
	import flash.geom.*;

	public class AssetManager 
	{
		private var 
			_assets    : Object,
			_animList  : Array,
			_cacheSize : uint;

		private static var _instance : AssetManager;

		public var 
			scale      : Boolean,
			stage      : Stage,
			quality    : String,
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
			quality = stage.quality;

			_assets = {};
			_animList = [];
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
			ttlReset(anim);
			_animList.push(anim);
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

		private function ttlReset(anim:Animation):void
		{
			if (anim.ttl == 0) ++anim.referenceCount;
			if (anim.renderAble && anim.isCurrAnim) anim.ttl = 1; //+ Math.random() * 100;
		}

		private function release():void
		{
			var anim:Animation;
			var frame:Frame;

			_animList.sortOn('ttl', Array.DESCENDING | Array.NUMERIC);

			anim = _animList[0] as Animation;
			if (anim.ttl < 100) return;
			anim.ttl = 0;

			if (--anim.referenceCount > 0) return;
			
			for (var i:uint = anim.beginFrame - 1; i < anim.endFrame; ++i)
			{
				frame = (_assets[anim.assetId] as Vector.<Frame>)[i];	
				
				if (frame && --frame.referenceCount == 0) frame.release();
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
