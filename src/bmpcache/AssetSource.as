package bmpcache
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;

	public class AssetSource
	{
		public var 
			id            : String,
			displayObject : DisplayObject;

		public function AssetSource(pid:String, rc:Sprite)
		{
			id = pid;
			displayObject = rc;

			gotoFrame();
		}

		private function gotoFirst():void
		{
			if (displayObject is MovieClip)
			{
				var mc : MovieClip = MovieClip(displayObject);
				mc.gotoAndStop(1);
			}
		}

		public function capture():void
		{

		}
	}
}
