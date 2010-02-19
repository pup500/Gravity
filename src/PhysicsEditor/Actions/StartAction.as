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
	
	
	public class StartAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/start_point.png")] private var img:Class;
		
		private var assetImage:Sprite;
		
		public function StartAction(panel:IPanel, active:Boolean)
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
			state.getArgs()["startPoint"] = args["start_snap"];
		}
		
		override public function update():void{
			super.update();
			
			if(state.getArgs()["startPoint"]){
				assetImage.x = state.getArgs()["startPoint"].x + FlxG.scroll.x;
				assetImage.y = state.getArgs()["startPoint"].y + FlxG.scroll.y;
			}
		}
	}
}