package bmpcache
{
	import flash.display.*;

	public class Asset
	{
		private var
			_bmp      : Bitmap,
			_anims    : Object,
			_source   : DisplayObject,
			_sourId   : String,
			_baseId   : String,
			_isAnim   : Boolean,
			_currAnim : BaseAnim;
			
		public function Asset(classOrInst:*, animation:Boolean=true)
		{
			_anims = {};
			_isAnim = animation;
			_baseId = AnimManager.getClassName(classOrInst);

			_bmp = new Bitmap(AnimManager.BLANK, 'auto', true);
		}

		public function switchAnim(bFrame:uint, eFrame:uint):void
		{
			if (!_isAnim) return;
			if (_currAnim is Animation) (_currAnim as Animation).stop();

			var newId:String = getId(_sourId, bFrame, eFrame);

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = new Animation(newId, _source, _bmp, bFrame, eFrame);
				_currAnim = _anims[newId];
			}

			if (_currAnim is Animation) (_currAnim as Animation).play();
		}

		public function gotoAndStop(frame:uint):void
		{
			if (_currAnim is Animation) (_currAnim as Animation).stop();

			var newId:String = getId(_sourId, frame);

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = new Inanimation(newId, _source, _bmp, frame);
				_currAnim = _anims[newId];
			}
		}

		public function setSource(sour:DisplayObject, sid:String='asset'):void
		{
			if (sid == _sourId) return;
			if (_source) _source.parent.removeChild(_bmp);

			_sourId = sid;
			_source = sour;
			_source.parent.addChildAt(_bmp, _source.parent.getChildIndex(_source));

			if (!_isAnim)
			{
				var newId:String = getId(sid);
				_anims[newId] = new Inanimation(newId, _source, _bmp);
			}
		}

		private function getId(sourId:String, bFrame:uint=1, eFrame:uint=1):String
		{
			return [_baseId, sourId, bFrame, eFrame].join('_');
		}
	}
}
