package bmpcache
{
	import flash.display.*;

	public class Asset
	{
		private var
			_bmp         : Bitmap,
			_anims       : Object,
			_source      : DisplayObject,
			_sourId      : String,
			_baseId      : String,
			_isAnim      : Boolean,
			_assetId     : String,
			_currAnim    : Animation,
			_totalFrames : uint;
				
		public function Asset(classOrInst:*)
		{
			_anims = {};
			_baseId = AssetManager.getClassName(classOrInst);

			_bmp = new Bitmap(AssetManager.BLANK, 'auto', true);
		}

		public function switchAnim(bFrame:uint, eFrame:uint):void
		{
			if (_currAnim) _currAnim.isCurrAnim = false;

			var newId:String = getId(bFrame, eFrame);
			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = _currAnim = new Animation(_assetId, newId, _source, _bmp, bFrame, eFrame);
			}

			_currAnim.isCurrAnim = true;
		}

		public function gotoFrame(frame:uint):void
		{
			if (_currAnim) _currAnim.gotoFrame(frame);
		}

		public function setSource(sour:DisplayObject, sid:String='asset'):void
		{
			if (_source) return;

			_sourId = sid;
			_source = sour;
			_source.parent.addChildAt(_bmp, _source.parent.getChildIndex(_source));
			_assetId = _baseId + '_' + _sourId;
			_totalFrames = (_source is MovieClip) ? (_source as MovieClip).totalFrames : 1;

			AssetManager.inst.addAsset(_assetId, _totalFrames);
		}

		private function getId(bFrame:uint=1, eFrame:uint=1):String
		{
			return [_assetId, bFrame, eFrame].join('_');
		}
	}
}
