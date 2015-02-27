package bmpcache
{
	import flash.display.*;
	import flash.utils.*;
	import flash.geom.*;

	public class AssetManager 
	{
		private var 
			_tick      : uint,
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
			_animList.push(anim);
		}

		public function addFrame(aid:String, frame:Frame):void
		{
			var frames:Vector.<Frame> = _assets[aid] as Vector.<Frame>;
			if (!aid || frame.index < 0 || frame.index >= frames.length) return;
			frames[frame.index] = frame; 
		}

		public function getFrame(aid:String, frameIndex:int):Frame
		{
			var frames:Vector.<Frame> = _assets[aid] as Vector.<Frame>;
			if (!aid || frameIndex < 0 || frameIndex >= frames.length) return null;
			return frames[frameIndex];
		}

		public function tick():void
		{
			++_tick;

			for each (var anim:Animation in _animList)
			{
				if (anim.renderAble && anim.isCurrAnim) 
				{
					if (anim.ttl == 0) ++anim.referenceCount;

					anim.ttl = 1;
				}

				if (anim.ttl > 0) ++anim.ttl;
				if (anim.asset.play) anim.asset.gotoFrame(_tick) 
			}

			if (!cacheAble) release();
		}

		public function get cacheAble():Boolean
		{
			return currMemory < _cacheSize;
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
			
			var frames:Vector.<Frame> = _assets[anim.asset.assetId] as Vector.<Frame>;	

			if (frames)
			{
				for each(frame in frames)
				{
					if (frame && frame.bitmapData && --frame.referenceCount == 0) frame.release();
				}
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
