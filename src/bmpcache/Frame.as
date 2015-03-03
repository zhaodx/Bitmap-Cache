package bmpcache
{
	import flash.display.*;
	import flash.geom.*;

	public class Frame
	{
		public var
			index          : int,
			memory         : uint,
			bounds         : Rectangle,
			offset         : Point,
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
