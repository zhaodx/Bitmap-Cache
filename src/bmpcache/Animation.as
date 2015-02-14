package bmpcache
{
	import flash.display.*;
	import flash.geom.*;
	import flash.system.*;

	public class Animation
	{
		private var 
			_bmp        : Bitmap,
			_matrix     : Matrix,
			_source     : MovieClip,
			_endFrame   : uint,
			_currFrame  : Frame,
			_frameCount : uint,
			_beginFrame : uint;

		public var 
			id         : String,
			playAble   : Boolean,
			frameNums  : uint;

		public function Animation(sour:MovieClip, animationId:String, beginFrame:uint, endFrame:uint)	
		{
			id = animationId;

			_source = sour;

			_beginFrame = beginFrame;
			_endFrame = endFrame;

			_matrix = new Matrix();
			_bmp = new Bitmap(AnimationManager.BLANK, 'auto', true);
			_source.parent.addChildAt(_bmp, _source.parent.getChildIndex(_source));
			_bmp.x = _source.x;
			_bmp.y = _source.y;

			frameNums = endFrame - beginFrame + 1;
			AnimationManager.inst.addAnimation(this);
		}

		public function play():void
		{
			playAble = true;	
		}

		public function stop():void
		{
			playAble = false;
		}

		public function render(tick:uint):void
		{
			if (_currFrame) _currFrame.removeReference(_bmp);

			_frameCount = tick % frameNums;
			_currFrame = AnimationManager.inst.getFrame(id, _frameCount);

			if (_currFrame.bitmapData)
			{
				bmpshow(_currFrame);
			}else
			{
				capture(_currFrame);
			}
		}

		private function bmpshow(frame:Frame):void
		{
			if (Demo.inst.stage.quality != StageQuality.LOW)
			{
				Demo.inst.stage.quality = StageQuality.LOW;
			}

			if (!_bmp.visible) _bmp.visible = true;
			if (_source.visible) _source.visible = false;

			_bmp.bitmapData.lock();
			_bmp.bitmapData = frame.bitmapData;
			_bmp.bitmapData.unlock();

			_bmp.x = Math.ceil(_source.x) + Math.ceil(frame.bounds.x);
			_bmp.y = Math.ceil(_source.y) + Math.ceil(frame.bounds.y);

			_currFrame.addReference(_bmp);
		}

		private function capture(frame:Frame):void
		{
			if (Demo.inst.stage.quality != StageQuality.HIGH)
			{
				Demo.inst.stage.quality = StageQuality.HIGH;
			}

			if (_bmp.visible) _bmp.visible = false;
			if (!_source.visible) _source.visible = true;

			_source.gotoAndStop(_beginFrame + _frameCount);

			frame.bounds = _source.getBounds(_source);
			frame.bitmapData = new BitmapData(Math.ceil(frame.bounds.width), Math.ceil(frame.bounds.height), true, 0);

			_matrix.tx = -Math.ceil(frame.bounds.x);
			_matrix.ty = -Math.ceil(frame.bounds.y);

			frame.bitmapData.draw(_source, _matrix, null, null, null, true);

			//_source.gotoAndStop(1);
		}
	}
}
