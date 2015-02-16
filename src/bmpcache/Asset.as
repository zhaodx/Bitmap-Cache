package bmpcache
{
	import flash.display.*;
	import flash.events.*;

	public class Asset extends EventDispatcher
	{
		public var
			bmp      : Bitmap,
			source   : DisplayObject;
			
		private var
			_anims       : Object,
			_sourId      : String,
			_baseId      : String,
			_isAnim      : Boolean,
			_currAnim    : BaseAnim,
			_finishEvent : Boolean;
	
		public static const FINISH_EVENT : String = "finish_event";
				
		public function Asset(classOrInst:*, animation:Boolean=true)
		{
			_anims = {};
			_isAnim = animation;
			_baseId = AnimManager.getClassName(classOrInst);

			bmp = new Bitmap(AnimManager.BLANK, 'auto', true);
		}

		public function switchAnim(bFrame:uint, eFrame:uint, finishEvent:Boolean=false):void
		{
			if (!_isAnim) return;
			if (_currAnim is Animation) (_currAnim as Animation).stop();

			var newId:String = getId(_sourId, bFrame, eFrame);

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = _currAnim = new Animation(newId, this, bFrame, eFrame);
			}

			if (_currAnim is Animation) (_currAnim as Animation).play();

			_finishEvent = finishEvent;
		}

		public function stopAnim():void
		{
			if (!_isAnim) return;
			if (_currAnim is Animation) (_currAnim as Animation).stop();
		}

		public function gotoAndStop(frame:uint, needEvent:Boolean=false):void
		{
			if (_currAnim is Animation) (_currAnim as Animation).stop();

			var newId:String = getId(_sourId, frame);

			_currAnim = _anims[newId];

			if (!_currAnim)
			{
				_anims[newId] = _currAnim = new Inanimation(newId, this, frame);
			}else
			{
				if(_currAnim is Inanimation) (_currAnim as Inanimation).draw();
			}

			if (needEvent) finishEvent(); 
		}

		public function setSource(sour:DisplayObject, sid:String='asset'):void
		{
			if (sid == _sourId) return;
			if (source) source.parent.removeChild(bmp);

			_sourId = sid;
			source = sour;
			source.parent.addChildAt(bmp, source.parent.getChildIndex(source));

			if (!_isAnim)
			{
				var newId:String = getId(sid);
				_anims[newId] = new Inanimation(newId, this);
			}
		}

		public function finishEvent():void
		{
			if (_finishEvent) dispatchEvent(new Event(FINISH_EVENT));
		}

		private function getId(sourId:String, bFrame:uint=1, eFrame:uint=1):String
		{
			return [_baseId, sourId, bFrame, eFrame].join('_');
		}
	}
}
