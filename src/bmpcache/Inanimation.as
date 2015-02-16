package bmpcache
{
	import flash.display.*;

	public class Inanimation extends BaseAnim
	{
		public var index : uint;

		public function Inanimation(sid:String, sour:DisplayObject, sbmp:Bitmap, frameIndex:uint=1)
		{
			super(sid, sour, sbmp, 1, 1);

			index = frameIndex;
			currFrame = AnimManager.inst.getFrame(id);

			capture();
		}

		override protected function bmpshow():void
		{
			if (source is MovieClip) MovieClip(source).gotoAndStop(1);
			super.bmpshow();
		}

		override protected function capture():void
		{
			if (source is MovieClip) MovieClip(source).gotoAndStop(index);
			super.capture();

			bmpshow();
		}
	}
}
