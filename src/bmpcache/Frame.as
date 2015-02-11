package bmpcache
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class Frame
	{
		public var 
			id          : String,
			ttl         : uint,
			key         : String,
			index       : int,
			asset       : Asset,
			expire      : uint,
			bounds      : Rectangle,
			memory      : uint,
			source      : AssetSource,
			timestamp   : uint,
			bitmapData  : BitmapData,
			captureTime : uint;

		public function init(idx:int, ast:Asset, fTTL:uint):void
		{
			index = idx;
			asset = ast;
			source = asset.source;
			id = ast.id + '_' + index;
			ttl = fTTL;
			bounds = source.bounds;
		}

		public function release():void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;

				memory = 0;
			}
		}

		public function capture():void
		{
			if (!bitmapData)
			{
				source.capture(this);
				memory = bounds.width * bounds.height * 4;
				Manager.cache.addFrame(this);
			}
		}

		public function get nextFrame():Frame
		{
			return asset.frames[(index + 1) % asset.frames.length];	
		}

		public function get prevFrame():Frame	
		{
			return asset.frames[(index + asset.frames.length - 1) % asset.frames.length];
		}

		public function get isFirstFrame():Boolean
		{
			return index == 0;
		}

		public function get isLastFrame():Boolean
		{
			return index == (asset.frames.length - 1);
		}

		public function get firstFrame():Frame
		{
			return asset.frames[0];
		}

		public function get lastFrame():Frame
		{
			return asset.frames[asset.frames.length - 1];
		}

		public function dispose():void
		{
			index = -1;

			ttl = 0;
			expire = 0;
			timestamp = 0;
			captureTime  = 0;

			id = null;
			key = null;
			asset = null;
			bounds = null;
			source = null;

			release();
		}
	}
}
