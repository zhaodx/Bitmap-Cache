package bmpcache
{
	import flash.display.*;
	import flash.geom.Rectangle;

	public class Frame
	{
		public var 
			index          : uint,
			memory         : uint,
			bounds         : Rectangle,
			bitmapData     : BitmapData;

		public function release():void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}

			AnimManager.inst.currMemory -= memory;
			memory = 0;
		}
	}
}
