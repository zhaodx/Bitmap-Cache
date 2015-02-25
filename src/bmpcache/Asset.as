package bmpcache
{
	import flash.display.*;

	public class Asset
	{
		public var
			bmp         : Bitmap,
			play        : Boolean,
			source      : DisplayObject,
			assetId     : String,
			totalFrames : uint;

		private var
			_anims       : Object,
			_sourId      : String,
			_baseId      : String,
			_isAnim      : Boolean,
			_currAnim    : Animation;
				
		public function Asset(classOrInst:*, isPlay:Boolean=false)
		{
			play = isPlay;
			_anims = {};
			_baseId = AssetManager.getClassName(classOrInst);

			bmp = new Bitmap(AssetManager.BLANK, 'auto', true);
		}

		public function switchAnim(sour:DisplayObject, sid:String='asset', bFrame:int=1, eFrame:int=1):void
		{
			setSource(sour, sid);

			var newId:String = getId(bFrame, eFrame);
			if (_currAnim) _currAnim.isCurrAnim = false;

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = _currAnim = new Animation(newId, this, bFrame, eFrame);
			}

			_currAnim.isCurrAnim = true;
		}

		public function gotoFrame(frame:int):void
		{
			if (_currAnim) _currAnim.gotoFrame(frame % (totalFrames + 1));
		}

		private function setSource(sour:DisplayObject, sid:String='asset'):void
		{
			_sourId = sid;

			source = sour;
			bmp.visible = true;
			source.visible = false;
			source.parent.addChildAt(bmp, source.parent.getChildIndex(source));

			assetId = _baseId + '_' + _sourId;
			totalFrames = (source is MovieClip) ? (source as MovieClip).totalFrames : 1;

			AssetManager.inst.addAsset(assetId, totalFrames);
		}

		private function getId(bFrame:int=1, eFrame:int=1):String
		{
			return [assetId, bFrame, eFrame].join('_');
		}
	}
}
