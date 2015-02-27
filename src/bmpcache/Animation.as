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
			frameCount : int;

		public function Animation(sid:String, ast:Asset, bFrame:int=1, eFrame:int=1)
		{
			asset = ast;
			beginFrame = bFrame;
			endFrame = eFrame;

			renderAble = true;
			frameNums = endFrame - beginFrame + 1;

			AssetManager.inst.addAnim(this);
		}

		public function initFrame():void
		{
			isCurrAnim = true;
			
			for (var i:uint = beginFrame - 1; i < endFrame; ++i)
			{
				var frame:Frame = AssetManager.inst.getFrame(asset.assetId, i);	

				if (!frame)
				{
					frame = new Frame();
					frame.index = i;

					AssetManager.inst.addFrame(asset.assetId, frame);
				}

				if (!frame.bitmapData)
				{
					if (AssetManager.inst.cacheAble) 
					{
						asset.capture(frame);
						++frame.referenceCount;
					}
				}
			}

			gotoFrame(beginFrame);
		}

		public function gotoFrame(frame:int):void
		{
			if (!isCurrAnim) return;

			frameCount = (frame < 1) ? 1 : frame;
			currFrame = AssetManager.inst.getFrame(asset.assetId, frameCount - 1);

			if (currFrame && currFrame.bitmapData)
			{
				asset.bmp.bitmapData = currFrame.bitmapData;

				asset.bmp.x = Math.ceil(asset.sourPoint.x) + Math.ceil(currFrame.bounds.x - 1);
				asset.bmp.y = Math.ceil(asset.sourPoint.y) + Math.ceil(currFrame.bounds.y - 1);

				if (!asset.bmp.visible) asset.bmp.visible = true;
				if (asset.source.visible) asset.source.visible = false;
			}else
			{
				if (asset.bmp.visible) asset.bmp.visible = false;
				if (!asset.source.visible) asset.source.visible = true;
				if (asset.source is MovieClip) MovieClip(asset.source).gotoAndStop(frameCount);
			}
		}
	}
}
