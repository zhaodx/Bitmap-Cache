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
			currFrame  : Frame,
			renderAble : Boolean;

		protected var 
			bmp        : Bitmap,
			matrix     : Matrix,
			source     : DisplayObject,
			endFrame   : uint,
			frameCount : uint,
			beginFrame : uint;

		public function BaseAnim(sid:String, sour:DisplayObject, sbmp:Bitmap, bFrame:uint, eFrame:uint)
		{
			id = sid;

			bmp = sbmp;
			source = sour;
			beginFrame = bFrame;
			endFrame = eFrame;

			renderAble = true;
			matrix = new Matrix();
			frameNums = endFrame - beginFrame + 1;

			AnimManager.inst.addAnim(this);
		}

		public function render(tick:uint):void
		{
			AnimManager.inst.ttlReset(this);
		}

		protected function bmpshow():void
		{

			if (!bmp.visible) bmp.visible = true;
			if (source.visible) source.visible = false;

			bmp.bitmapData = currFrame.bitmapData;
			bmp.x = Math.ceil(source.x) + currFrame.bounds.x;
			bmp.y = Math.ceil(source.y) + currFrame.bounds.y;
		}

		protected function capture():void
		{
			if (bmp.visible) bmp.visible = false;
			if (!source.visible) source.visible = true;

			if (!AnimManager.inst.cacheAble) return;
			AnimManager.inst.stage.quality = StageQuality.HIGH;

			currFrame.bounds = getBounds();
			matrix.tx = -currFrame.bounds.x;
			matrix.ty = -currFrame.bounds.y;

			currFrame.bitmapData = new BitmapData(currFrame.bounds.width, currFrame.bounds.height, true, 0);
			currFrame.memory = currFrame.bitmapData.width * currFrame.bitmapData.height * 4;
			AnimManager.inst.currMemory += currFrame.memory;

			currFrame.bitmapData.draw(source, matrix, null, null, null, true);
			AnimManager.inst.stage.quality = StageQuality.LOW;
		}

		private function getBounds():Rectangle
		{
			var rect:Rectangle = source.getBounds(source);		
			return new Rectangle(Math.ceil(rect.x), Math.ceil(rect.y), Math.ceil(rect.width), Math.ceil(rect.height));
		}
	}
}
