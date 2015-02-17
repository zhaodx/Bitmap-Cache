package bmpcache
{
	import flash.display.*;
	import flash.geom.*;

	public class Animation 
	{
		public var 
			id         : String,
			ttl        : uint,
			assetId    : String,
			frameNums  : uint,
			currFrame  : Frame,
			renderAble : Boolean,
			isCurrAnim : Boolean;

		protected var 
			bmp        : Bitmap,
			matrix     : Matrix,
			source     : DisplayObject,
			endFrame   : uint,
			frameCount : uint,
			beginFrame : uint;


		public function Animation(aid:String, sid:String, sour:DisplayObject, sbmp:Bitmap, bFrame:uint=1, eFrame:uint=1)
		{
			id = sid;
			bmp = sbmp;
			source = sour;
			assetId = aid;
			beginFrame = bFrame;
			endFrame = eFrame;

			renderAble = true;
			matrix = new Matrix();
			frameNums = endFrame - beginFrame + 1;

			initFrame();
			AssetManager.inst.addAnim(this);

			gotoFrame(beginFrame);
		}

		private function initFrame():void
		{
			for (var i:uint = beginFrame - 1; i < endFrame - 1; ++i)	
			{
				var frame:Frame = AssetManager.inst.getFrame(assetId, i);	

				if (!frame)
				{
					frame = new Frame();
					frame.index = i;

					AssetManager.inst.addFrame(assetId, frame);
				}

				frame.referenceCount++;
			}
		}

		public function gotoFrame(frameIndex:uint):void
		{
			if (frameCount == frameIndex) return;

			frameCount = frameIndex;
			currFrame = AssetManager.inst.getFrame(assetId, frameCount);

			if (currFrame.bitmapData)
			{
				bmpshow();
			}else
			{
				capture();
			}
		}

		protected function bmpshow():void
		{
			if (source is MovieClip && MovieClip(source).currentFrame != 1) 
			{
				MovieClip(source).gotoAndStop(1);
			}

			if (!bmp.visible) bmp.visible = true;
			if (source.visible) source.visible = false;

			bmp.bitmapData = currFrame.bitmapData;
			bmp.x = Math.ceil(source.x) + currFrame.bounds.x;
			bmp.y = Math.ceil(source.y) + currFrame.bounds.y;
		}

		protected function capture():void
		{
			AssetManager.inst.stage.quality = StageQuality.HIGH;

			if (source is MovieClip) MovieClip(source).gotoAndStop(frameCount);

			if (!AssetManager.inst.cacheAble)
			{
				if (bmp.visible) bmp.visible = false;
				if (!source.visible) source.visible = true;

				return;
			}

			currFrame.bounds = getBounds();
			matrix.tx = -currFrame.bounds.x;
			matrix.ty = -currFrame.bounds.y;

			currFrame.bitmapData = new BitmapData(currFrame.bounds.width, currFrame.bounds.height, true, 0x55FF0000);
			currFrame.memory = currFrame.bitmapData.width * currFrame.bitmapData.height * 4;
			AssetManager.inst.currMemory += currFrame.memory;

			currFrame.bitmapData.draw(source, matrix, null, null, null, true);
			AssetManager.inst.stage.quality = StageQuality.LOW;

			bmpshow();
		}

		private function getBounds():Rectangle
		{
			var rect:Rectangle = source.getBounds(source);		
			return new Rectangle(Math.ceil(rect.x), Math.ceil(rect.y), Math.ceil(rect.width), Math.ceil(rect.height));
		}
	}
}
