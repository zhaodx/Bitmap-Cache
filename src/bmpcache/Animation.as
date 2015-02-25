package bmpcache
{
	import flash.display.*;
	import flash.geom.*;

	public class Animation 
	{
		public var 
			ttl            : uint,
			asset          : Asset,
			endFrame       : int,
			frameNums      : int,
			currFrame      : Frame,
			beginFrame     : int,
			renderAble     : Boolean,
			isCurrAnim     : Boolean,
			referenceCount : uint; 

		protected var 
			matrix     : Matrix,
			frameCount : int;

		public function Animation(sid:String, ast:Asset, bFrame:int=1, eFrame:int=1)
		{
			asset = ast;
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
				var frame:Frame = AssetManager.inst.getFrame(asset.assetId, i);	

				if (!frame)
				{
					frame = new Frame();
					frame.index = i;

					AssetManager.inst.addFrame(asset.assetId, frame);
				}

				++frame.referenceCount;
			}
		}

		public function gotoFrame(frame:int):void
		{
			frameCount = (frame < 1) ? 1 : frame;
			currFrame = AssetManager.inst.getFrame(asset.assetId, frameCount - 1);

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
			if (asset.source is MovieClip && MovieClip(asset.source).currentFrame != 1) 
			{
				MovieClip(asset.source).gotoAndStop(1);
			}

			asset.bmp.bitmapData = currFrame.bitmapData;

			asset.bmp.x = Math.ceil(asset.source.x) + Math.ceil(currFrame.bounds.x - 2);
			asset.bmp.y = Math.ceil(asset.source.y) + Math.ceil(currFrame.bounds.y - 2);
		}

		protected function capture():void
		{
			AssetManager.inst.stage.quality = StageQuality.BEST;

			if (asset.source is MovieClip) MovieClip(asset.source).gotoAndStop(frameCount);

			if (!AssetManager.inst.cacheAble)
			{
				if (asset.bmp.visible) asset.bmp.visible = false;
				if (!asset.source.visible) asset.source.visible = true;

				return;
			}

			currFrame.bounds = asset.source.getBounds(asset.source);
			matrix.tx = -Math.ceil(currFrame.bounds.x - 2);
			matrix.ty = -Math.ceil(currFrame.bounds.y - 2);

			currFrame.bitmapData = new BitmapData(Math.ceil(currFrame.bounds.width + 4), Math.ceil(currFrame.bounds.height + 4), true, 0x22FF0000);
			currFrame.memory = currFrame.bitmapData.width * currFrame.bitmapData.height * 4;
			AssetManager.inst.currMemory += currFrame.memory;

			currFrame.bitmapData.draw(asset.source, matrix, null, null, null, true);
			AssetManager.inst.stage.quality = AssetManager.inst.quality;

			bmpshow();
		}
	}
}
