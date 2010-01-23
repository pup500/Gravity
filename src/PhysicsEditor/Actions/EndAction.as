package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	
	
	public class EndAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/end_point.png")] private var img:Class;
		
		private var assetImage:Sprite;
		
		public function EndAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			initImage();
		}
		
		private function initImage():void{
			var bitmapData:BitmapData = (new img).bitmapData;
			
			assetImage = new Sprite();
			assetImage.graphics.clear();
			assetImage.graphics.beginBitmapFill(bitmapData);
			assetImage.graphics.drawRect(0,0,bitmapData.width,bitmapData.height);
			assetImage.graphics.endFill();
			
			state.addChild(assetImage);
		}
		
		override public function onHandleBegin():void{
			state.getArgs()["endPoint"] = args["start"];
		}
		
		override public function update():void{
			super.update();
			
			if(state.getArgs()["endPoint"]){
				assetImage.x = state.getArgs()["endPoint"].x + FlxG.scroll.x;
				assetImage.y = state.getArgs()["endPoint"].y + FlxG.scroll.y;
			}
		}
	}
}