package bmpcache
{
	import flash.display.*;
	import flash.geom.*;

	public class Asset
	{
		public var
			bmp         : Bitmap,
			play        : Boolean,
			source      : DisplayObject,
			assetId     : String,
			sourPoint   : Point,
			totalFrames : uint;

		private var
			_anims       : Object,
			_sourId      : String,
			_baseId      : String,
			_isAnim      : Boolean,
			_parent      : DisplayObjectContainer,
			_currAnim    : Animation;
				
		public function Asset(classOrInst:*, isPlay:Boolean=false)
		{
			_anims = {};
			_baseId = AssetManager.getClassName(classOrInst);

			play = isPlay;
			bmp = new Bitmap(AssetManager.BLANK, 'auto', true);
		}

		public function switchAnim(sour:DisplayObject, sid:String='asset', bFrame:int=1, eFrame:int=1):void
		{
			if (!sour || !sour.parent) return;

			setSource(sour, sid);
			var newId:String = getId(bFrame, eFrame);

			if (_currAnim) 
			{
				_currAnim.isCurrAnim = false;
			}

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = _currAnim = new Animation(newId, this, bFrame, eFrame);
			}

			_currAnim.initFrame();
		}

		public function gotoFrame(frame:int):void
		{
			if (_currAnim) 
			{
				_currAnim.gotoFrame(frame % (_currAnim.frameNums + 1));
			}
		}

		public function capture(frame:Frame):void
		{
			AssetManager.inst.stage.quality = StageQuality.BEST;
			if (source is MovieClip) MovieClip(source).gotoAndStop(frame.index + 1);

			var bounds:Rectangle = source.getBounds(source);
			frame.bounds = source.getBounds(_parent);
			frame.bounds.width = Math.ceil(bounds.width * source.scaleX);
			frame.bounds.height = Math.ceil(bounds.height * source.scaleY);

			if (source.transform.matrix.a < 0)
			{
				frame.bounds.x += frame.bounds.width;
				frame.offset = new Point(frame.bounds.x, frame.bounds.y);
			}else
			{
				bounds.x = Math.floor(bounds.x);
				bounds.y = Math.floor(bounds.y);

				frame.bounds.x = Math.floor(frame.bounds.x);
				frame.bounds.y = Math.floor(frame.bounds.y);

				frame.offset = new Point(source.x + bounds.x, source.y + bounds.y);
			}

			if (source.width == 0 || source.height == 0)
			{
				frame.bitmapData = AssetManager.BLANK;
			}else
			{
				var matrix:Matrix = new Matrix();
				matrix.translate(-(bounds.x), -(bounds.y));
				matrix.scale(source.scaleX, source.scaleY);

				frame.bitmapData = new BitmapData(frame.bounds.width, frame.bounds.height, true, 0); //0x22FF0000);
				frame.bitmapData.draw(source, matrix, null, null, frame.bitmapData.rect, false);
			}

			frame.memory = frame.bitmapData.width * frame.bitmapData.height * 4;
			AssetManager.inst.currMemory += frame.memory;
			AssetManager.inst.stage.quality = AssetManager.inst.quality;

			source.visible = false;
			if (source is MovieClip) MovieClip(source).gotoAndStop(1);
		}

		private function setSource(sour:DisplayObject, sid:String='asset'):void
		{
			if (sid != _sourId)
			{
				source = sour;
				source.x = Math.round(source.x);
				source.y = Math.round(source.y);

				sourPoint = new Point(source.x, source.y);

				_sourId = sid;
				_parent = source.parent;
				_parent.addChildAt(bmp, _parent.getChildIndex(source));

				if (source.transform.matrix.a < 0)
				{
					var matrix:Matrix = bmp.transform.matrix;
					matrix.a = -1;
					bmp.transform.matrix = matrix;
				}

				assetId = [_baseId, _sourId].join('_');
				totalFrames = (source is MovieClip) ? (source as MovieClip).totalFrames : 1;

				AssetManager.inst.addAsset(assetId, totalFrames);
			}
		}

		private function getId(bFrame:int=1, eFrame:int=1):String
		{
			return [assetId, bFrame, eFrame].join('_');
		}
	}
}
