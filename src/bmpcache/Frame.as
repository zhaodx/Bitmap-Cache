package bmpcache
{
	import flash.display.*;
	import flash.geom.Rectangle;

	public class Frame
	{
		public var 
			index       : int,
			memory      : uint,
			bounds      : Rectangle,
			bitmapData  : BitmapData;

		private var _bmps : Array = [];

		public function release():void
		{
			for each(var bmp:Bitmap in _bmps)
			{
				bmp.bitmapData = AnimationManager.BLANK;
			}

			_bmps = [];

			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}

			AnimationManager.inst.currMemory -= memory;
			memory = 0;
		}

		public function addReference(bmp:Bitmap):void
		{
			_bmps.push(bmp);
		}

		public function removeReference(bmp:Bitmap):void
		{
			var index:int = _bmps.indexOf(bmp);

			if (index != -1) _bmps.splice(index, 1);
		}
	}
}
