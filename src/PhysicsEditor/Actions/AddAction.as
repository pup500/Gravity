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
	
	
	public class AddAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add.png")] private var img:Class;
		
		private var assetImage:Sprite;
		
		public function AddAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			
			assetImage = new Sprite();
			state.addChild(assetImage);
		}
		
		override public function onHandleBegin():void{
			//Should this be made as some ExSprite factory function in ExSprite?
			var xml:XML = new XML(<shape/>);
			xml.file = state.getArgs()["file"];
			xml.x = assetImage.x - FlxG.scroll.x + assetImage.width/2;		 		
			xml.y = assetImage.y - FlxG.scroll.y + assetImage.height/2;
			xml.layer = 1;
			xml.bodyType = state.getArgs()["bodyType"];
			xml.shapeType = state.getArgs()["shapeType"];
			xml.angle = 0;
			
			var b2:ExSprite = new ExSprite();
		    b2.initFromXML(xml, state.the_world, state.getController());
		    
		    state.addToLayer(b2, xml.layer);
		}
		
		override public function update():void{
			super.update();
			
			assetImage.visible = active;
			
			if(active){
				//Draw the preview image based on the selected resource
				assetImage.x = FlxG.mouse.x + FlxG.scroll.x;
				assetImage.y = FlxG.mouse.y + FlxG.scroll.y;
				
				if(state.getArgs()["snap"]){
					assetImage.x -= (FlxG.mouse.x % 16);
					assetImage.y -= (FlxG.mouse.y % 16);
				}
				
				//Prevent reloading the same image if we didn't change
				if(args["file"] == state.getArgs()["file"])
					return;
				
				setPreviewImg(state.getArgs()["file"]);
			}
		}
		
		private function setPreviewImg(imgFile:String):void{
			args["file"] = imgFile;
			
			if(imgFile.lastIndexOf(".xml") >= 0){
				assetImage.graphics.clear();
			 	return;
			}
			
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSetPreviewComplete);
    		loader.load(new URLRequest(imgFile));
		}
		
		private function onSetPreviewComplete(event:Event):void{
			 var bitmapData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			 assetImage.graphics.clear();
			 assetImage.graphics.beginBitmapFill(bitmapData);
			 assetImage.graphics.drawRect(0,0,bitmapData.width,bitmapData.height);
			 assetImage.graphics.endFill();
		}
	}
}