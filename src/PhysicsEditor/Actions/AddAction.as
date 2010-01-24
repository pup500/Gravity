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
			//We get rid of scroll.x and scroll.y because exsprites automatically does that...
			
			var p:Point = new Point(assetImage.x - FlxG.scroll.x, assetImage.y - FlxG.scroll.y);
			var r:Rectangle = assetImage.getBounds(assetImage);
			var s:Rectangle = assetImage.getRect(assetImage);
			
			//var l:Point = assetImage.globalToLocal(p);
			var tl:Point = assetImage.localToGlobal(new Point(0,0));
			var tr:Point = assetImage.localToGlobal(new Point(r.width,0));
			var br:Point = assetImage.localToGlobal(new Point(r.width,r.height));
			var bl:Point = assetImage.localToGlobal(new Point(0,r.height));
			
			var min:Point = new Point();
			min.x = Math.min(tl.x, tr.x, br.x, bl.x);
			min.y =  Math.min(tl.y, tr.y, br.y, bl.y);
			
			var max:Point = new Point();
			max.x = Math.max(tl.x, tr.x, br.x, bl.x);
			max.y =  Math.max(tl.y, tr.y, br.y, bl.y);
			
			trace("S:" + s.x + "," + s.y + ", w:" + s.width + "," + s.height);
			
			trace("min.xy: " + min.x + "," + min.y);
			trace("max.xy: " + max.x + "," + max.y);
			
			trace("pxy" + p.x + "," + p.y);
			//trace("lxy" + l.x + "," + l.y);
			trace("tlxy top left corner" + tl.x + "," + tl.y);
			trace("brxy bottom right corner" + br.x + "," + br.y);
			
			trace("tr-tl: " + (tr.x-tl.x) + " ,"  + (tr.y-tl.y));

			trace(" ang: "+ assetImage.rotation + " rect: " + r.x + "," + r.y + ", w:" + r.width + "," + r.height);
			trace(" asset: "+ assetImage.width + " height: " + assetImage.height + " div2 width:" + assetImage.width/2 + "," + assetImage.height/2);
			
			
			//p.x += tl.x <= br.x ? (max.x - min.x)/2 : -(max.x - min.x)/2;
			//p.y += tl.y <= br.y ? (max.y - min.y)/2 : -(max.y - min.y)/2;
			
			//Very good
			//p.x += tl.x <= br.x ? assetImage.width/2 : -assetImage.width/2;
			//p.y += tl.y <= br.y ? assetImage.height/2 : -assetImage.height/2;
			
			///VERY CLOSE
			p.x += tl.x <= br.x ? assetImage.width/2 : -assetImage.width/2 ;
			p.y += tl.y <= br.y ? assetImage.height/2 : -assetImage.height/2 ;
			
			if(tl.x != min.x && tl.x != max.x){
				p.x += tr.x - tl.x;
			}
			else if(tl.y != min.y && tl.y != max.y){
				p.y += tr.y - tl.y;
			}
			
			/*
			//top left is x greater than bottom right
			if(tl.x > br.x){
				//if(tl.y > br.y){
					//p.y += Math.abs(tr.y-tl.y);
				//}
				//else {
					p.x += Math.abs(tr.x-tl.x);
				//}
			}
			else if(tl.x < br.x){
				if(tl.y > br.y){
					//p.y += Math.abs(tr.y-tl.y);
				}
				else {
					p.y -= Math.abs(tr.y-tl.y);
				}
			}
			*/
			//p.x += tl.x > br.x ? Math.abs(tr.x-tl.x) : 0;
			//p.y += tl.y > br.y ? - Math.abs(tr.y-tl.y) : 0;
			
			//p.x += tl.x <= br.x ? -(tr.x-tl.x) : (tr.x-tl.x);
			//p.y += tl.y <= br.y ? -(tr.y-tl.y) : (tr.y-tl.y);
			
			
			//p.x += (max.x - min.x)/2;
			//p.y += (max.y - min.y)/2;
			
			//p.x += Math.cos(assetImage.rotation * 180/Math.PI) * (assetImage.width/2);
			//p.y += Math.cos(assetImage.rotation * 180/Math.PI) * (assetImage.height/2);
			
			
			trace("computed pxy: " + p.x + "," + p.y);
			
			var xml:XML = new XML(<shape/>);
			xml.file = state.getArgs()["file"];
			xml.@x = p.x;//FlxG.mouse.x + assetImage.width/2;//assetImage.x - FlxG.scroll.x + assetImage.width/2;		 		
			xml.@y = p.y;//FlxG.mouse.y + assetImage.height/2;//assetImage.y - FlxG.scroll.y + assetImage.height/2;
			xml.@layer = 1;
			xml.@bodyType = state.getArgs()["bodyType"];
			xml.@shapeType = state.getArgs()["shapeType"];
			xml.@angle = state.getArgs()["angle"] * Math.PI/180;//0;
			
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
				
				//trace("image width: " + assetImage.width);
				//var r:Rectangle = assetImage.getBounds(sprite);
				//trace("x,y" + assetImage.x + "," + assetImage.y + " ang: "+ assetImage.rotation + " rect: " + r.x + "," + r.y + ", w:" + r.width + "," + r.height);
				
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