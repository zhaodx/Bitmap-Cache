package bmpcache
{
	import flash.display.*;

	public class Inanimation extends BaseAnim
	{
		public var index : uint;

		public function Inanimation(sid:String, ast:Asset, frameIndex:uint=1)
		{
			super(sid, ast, 1, 1);

			index = frameIndex;
			currFrame = AnimManager.inst.getFrame(id);

			capture();
		}

		public function draw():void 
		{
			bmpshow();
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

			draw();
		}
	}
}
