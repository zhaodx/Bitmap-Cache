package bmpcache
{
	import flash.display.*;
	import flash.geom.*;

	public class BaseAnim
	{
		public var 
			id         : String,
			ttl        : uint,
			frameNums  : uint,
			renderAble : Boolean;

		protected var 
			bmp        : Bitmap,
			matrix     : Matrix,
			source     : DisplayObject,
			endFrame   : uint,
			currFrame  : Frame,
			frameCount : uint,
			beginFrame : uint;

		public function BaseAnim(sour:DisplayObject, sid:String, bFrame:uint, eFrame:uint)
		{
			id = sid;

			source = sour;
			beginFrame = bFrame;
			endFrame = eFrame;

			matrix = new Matrix();
			bmp = new Bitmap(AnimManager.BLANK, 'auto', true);
			source.parent.addChildAt(bmp, source.parent.getChildIndex(source));

			frameNums = endFrame - beginFrame + 1;
			AnimManager.inst.addAnim(this);

			renderAble = true;
		}

		public function render(tick:uint):void
		{
			ttl = 1;
		}

		protected function bmpshow():void
		{
			if (!bmp.visible) bmp.visible = true;
			if (source.visible) source.visible = false;

			bmp.bitmapData = currFrame.bitmapData;
			bmp.x = Math.ceil(source.x) + Math.ceil(currFrame.bounds.x);
			bmp.y = Math.ceil(source.y) + Math.ceil(currFrame.bounds.y);

			currFrame.addReference(bmp);
		}

		protected function capture():void
		{
			if (bmp.visible) bmp.visible = false;
			if (!source.visible) source.visible = true;

			if (!AnimManager.inst.cacheAble) return;
			AnimManager.inst.stage.quality = StageQuality.HIGH;

			currFrame.bounds = source.getBounds(source);
			matrix.tx = -Math.ceil(currFrame.bounds.x);
			matrix.ty = -Math.ceil(currFrame.bounds.y);

			currFrame.bitmapData = new BitmapData(Math.ceil(currFrame.bounds.width), Math.ceil(currFrame.bounds.height), true, 0);
			currFrame.memory = currFrame.bitmapData.width * currFrame.bitmapData.height * 4;
			AnimManager.inst.currMemory += currFrame.memory;

			currFrame.bitmapData.draw(source, matrix, null, null, null, true);
			AnimManager.inst.stage.quality = StageQuality.LOW;
		}
	}
}
