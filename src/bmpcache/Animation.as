package bmpcache
{
	import flash.display.*;
	import flash.geom.*;

	public class Animation 
	{
		public var 
			ttl            : uint,
			assetId        : String,
			endFrame       : uint,
			frameNums      : uint,
			currFrame      : Frame,
			beginFrame     : uint,
			renderAble     : Boolean,
			isCurrAnim     : Boolean,
			referenceCount : uint; 

		protected var 
			bmp        : Bitmap,
			matrix     : Matrix,
			source     : DisplayObject,
			frameCount : uint;


		public function Animation(aid:String, sid:String, sour:DisplayObject, sbmp:Bitmap, bFrame:uint=1, eFrame:uint=1)
		{
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
			for (var i:uint = beginFrame - 1; i < endFrame; ++i)	
			{
				var frame:Frame = AssetManager.inst.getFrame(assetId, i);	

				if (!frame)
				{
					frame = new Frame();
					frame.index = i;

					AssetManager.inst.addFrame(assetId, frame);
				}

				++frame.referenceCount;
			}
		}

		public function gotoFrame(frameIndex:uint):void
		{
			if (frameCount == frameIndex) return;

			frameCount = frameIndex;
			currFrame = AssetManager.inst.getFrame(assetId, frameCount - 1);

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

			bmp.x = Math.ceil(source.x) + Math.ceil(currFrame.bounds.x - 2);
			bmp.y = Math.ceil(source.y) + Math.ceil(currFrame.bounds.y - 2);
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

			currFrame.bounds = source.getBounds(source);
			matrix.tx = -Math.ceil(currFrame.bounds.x - 2);
			matrix.ty = -Math.ceil(currFrame.bounds.y - 2);

			currFrame.bitmapData = new BitmapData(Math.ceil(currFrame.bounds.width + 4), Math.ceil(currFrame.bounds.height + 4), true, 0x55FF0000);
			currFrame.memory = currFrame.bitmapData.width * currFrame.bitmapData.height * 4;
			AssetManager.inst.currMemory += currFrame.memory;

			currFrame.bitmapData.draw(source, matrix, null, null, null, true);
			AssetManager.inst.stage.quality = AssetManager.inst.quality;

			bmpshow();
		}
	}
}
