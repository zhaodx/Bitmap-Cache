package bmpcache
{
	import flash.display.*;

	public class Inanimation extends BaseAnim
	{
		public function Inanimation(sour:Sprite, sid:String)	
		{
			super(sour, sid, 1, 1);

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
