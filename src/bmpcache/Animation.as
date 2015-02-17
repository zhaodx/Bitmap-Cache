package bmpcache
{
	import flash.display.*;

	public class Animation extends BaseAnim
	{
		private var _playAble : Boolean;

		public function Animation(sid:String, ast:Asset, bFrame:uint, eFrame:uint)	
		{
			super(sid, ast, bFrame, eFrame);
		}

		public function play():void
		{
			_playAble = true;	
		}

		public function stop():void
		{
			_playAble = false;
		}

		override public function render(tick:uint):void
		{
			super.render(tick);

			if (!_playAble) return;

			frameCount = tick % frameNums;
			currFrame = AnimManager.inst.getFrame(id, frameCount);

			if (currFrame.bitmapData)
			{
				bmpshow();
			}else
			{
				capture();
			}

			if (frameCount + 1 == frameNums) finishLoop();
		}

		override protected function bmpshow():void
		{
			if (MovieClip(source).currentFrame != 1) MovieClip(source).gotoAndStop(1);
			super.bmpshow();
		}

		override protected function capture():void
		{
			MovieClip(source).gotoAndStop(beginFrame + frameCount);
			super.capture();
		}

		private function finishLoop():void
		{
			asset.finishEvent();
		}
	}
}
