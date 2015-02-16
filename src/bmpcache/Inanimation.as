package bmpcache
{
	import flash.display.*;

	public class Inanimation extends BaseAnim
	{
		public function Inanimation(sid:String, sour:DisplayObject, sbmp:Bitmap)	
		{
			super(sid, sour, sbmp, 1, 1);

			currFrame = AnimManager.inst.getFrame(id);
			capture();
		}

		override protected function capture():void
		{
			super.capture();

			bmpshow();	
		}
	}
}
