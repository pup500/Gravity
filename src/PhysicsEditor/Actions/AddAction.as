package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
			if(args["file"].lastIndexOf(".xml") >= 0){
				addXMLObject();
			}
			else{
				addObject();
			}
		}
		
		private function addXMLObject():void{
			
		}
		
		private function addObject():void{
			//We get rid of scroll.x and scroll.y because exsprites automatically does that...
			//Everything else took quite a bit to come up with
			var p:Point = new Point(assetImage.x - FlxG.scroll.x, assetImage.y - FlxG.scroll.y);
			var r:Rectangle = assetImage.getBounds(assetImage);
			
			//Find global coordinates
			var tl:Point = assetImage.localToGlobal(new Point(0,0));
			var br:Point = assetImage.localToGlobal(new Point(r.width,r.height));
			
			//Add difference to offset because of rotation
			p.y += tl.y == br.y ? 0 : (br.y - tl.y)/2;
			p.x += tl.x == br.x ? 0 : (br.x - tl.x)/2;
			
			var xml:XML = new XML(<shape/>);
			xml.file = state.getArgs()["file"];
			xml.@x = p.x;		 		
			xml.@y = p.y;
			xml.@layer = 1;
			xml.@bodyType = state.getArgs()["bodyType"];
			xml.@shapeType = state.getArgs()["shapeType"];
			xml.@angle = state.getArgs()["angle"] * Math.PI/180;
			
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
				
				assetImage.rotation = state.getArgs()["angle"];
				
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