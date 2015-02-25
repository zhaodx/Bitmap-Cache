package bmpcache
{
	import flash.display.*;
	import flash.geom.Rectangle;

	public class Frame
	{
		public var
			index          : int,
			memory         : uint,
			bounds         : Rectangle,
			bitmapData     : BitmapData,
			referenceCount : uint;

		public function release():void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}

			AssetManager.inst.currMemory -= memory;
			memory = 0;
		}
	}
}
