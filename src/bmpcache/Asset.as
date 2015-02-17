package bmpcache
{
	import flash.display.*;
	import flash.events.*;

	public class Asset extends EventDispatcher
	{
		private var
			_bmp         : Bitmap,
			_anims       : Object,
			_source      : DisplayObject,
			_sourId      : String,
			_baseId      : String,
			_isAnim      : Boolean,
			_currAnim    : Animation,
			_stopToEnd   : Boolean;
	
		public static const FINISH_EVENT : String = "finish_event";
				
		public function Asset(classOrInst:*)
		{
			_anims = {};
			_baseId = AnimManager.getClassName(classOrInst);

			_bmp = new Bitmap(AnimManager.BLANK, 'auto', true);
		}

		public function switchAnim(bFrame:uint, eFrame:uint):void
		{
			var newId:String = getId(_sourId, bFrame, eFrame);

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = _currAnim = new Animation(newId, _source, _bmp, bFrame, eFrame);
			}
		}

		public function gotoFrame(frame:uint):void
		{
			if (_currAnim) _currAnim.gotoFrame(frame);
		}

		public function setSource(sour:DisplayObject, sid:String='asset'):void
		{
			if (sid == _sourId) return;
			if (_source) _source.parent.removeChild(_bmp);

			_sourId = sid;
			_source = sour;
			_source.parent.addChildAt(_bmp, _source.parent.getChildIndex(_source));
		}

		private function getId(sourId:String, bFrame:uint=1, eFrame:uint=1):String
		{
			return [_baseId, sourId, bFrame, eFrame].join('_');
		}
	}
}
