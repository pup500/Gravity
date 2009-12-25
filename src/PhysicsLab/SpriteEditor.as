package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.MapClasses.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class SpriteEditor extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		[Embed(source="SpriteEditor.txt", mimeType="application/octet-stream")] public var configFile:Class;
		
		private var b2:ExSprite; //For creating environment physical objects.
		private var time_count:Timer=new Timer(1000);
		
		private var files:Array;
		private var index:uint;
		private var last_index:uint;
		private var config:Array;
		
		private var edit:Boolean;
		private var text:FlxText;
		private var copyButton:SimpleButton;
		
		private var overlay:TextField;
		private var currentImg:Shape;
		
		private const BLACK:Number = 0x0;
		private const WHITE:Number = 0xFFFFFF;
		private const RED:Number = 0xFF0000;
		
		public function SpriteEditor() 
		{
			super();
			the_world.SetGravity(new b2Vec2(0,0));
			
			//debug = true;
			
			loadConfigFile("data/level2.txt");

			
			var body:Player = new Player(100, 20, null);
			
			body.createPhysBody(the_world);
			body.final_body.AllowSleeping(false);
			body.final_body.SetFixedRotation(true);
			add(body);
			
			//Set camera to follow player movement.
			//This works, in debug mode it looks weird but that's because of layer offset...
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,640,640);
			
			FlxG.showCursor(cursorSprite);
			
			//--Debug stuff--//
			initBox2DDebugRendering();

			last_index = index = 0;
			
			//Add new files 
			var s:String = new configFile;
			files = s.split("\n");
			
			edit = false;
			
			config = new Array();
			
			overlay = new TextField();
			overlay.x = 10;
			overlay.y = 0;
			addChild(overlay);
			
			currentImg = new Shape();
			addChild(currentImg);
			setCurrentImg(files[index]);
			
			FlxG.log("[ and ] rotate among image files in the SpriteEditor.txt file");
			FlxG.log("WASD move player object simulate scrolling");
			FlxG.log("E toggles edit mode (mouse click to add new shape)");
			FlxG.log("Mouse clicks will add the selected shape at mouse coordinates");
			FlxG.log("Click on top-left corner box to copy the new config settings to clipboard");
			
			addCopyButton();
		}
		
		private function addCopyButton():void {
			var rect:Rectangle = new Rectangle(0,0,9,9);
			var down:Sprite = new Sprite();
			down.graphics.lineStyle(1, 0x000000);
			down.graphics.beginFill(0xFFCC00);
			down.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			var up:Sprite = new Sprite();
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(0x0099FF);
			up.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			var over:Sprite = new Sprite();
			over.graphics.lineStyle(1, 0x000000);
			over.graphics.beginFill(0x9966FF);
			over.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			copyButton = new SimpleButton();
			
			copyButton.upState = up;
			copyButton.overState = over;
			copyButton.downState = down;
			copyButton.useHandCursor = true;
			copyButton.hitTestState = up;
			copyButton.x = 1;
			copyButton.y = 2;
			
			addChild(copyButton);
			  
			copyButton.addEventListener(MouseEvent.CLICK, onCopy);
		}

		private function setOverlay(text:String, color:Number=WHITE):void{
			overlay.text = text;
			overlay.width = text.length * 15;
			overlay.textColor = color;
		}
		
		private function setCurrentImg(png:String):void{
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPreviewComplete);
    		loader.load(new URLRequest(png));
		}
		
		private function onPreviewComplete(event:Event):void{
			 var bitmapData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			 currentImg.graphics.clear();
			 currentImg.graphics.beginBitmapFill(bitmapData);
			 currentImg.graphics.drawRect(0,0,bitmapData.width,bitmapData.height);
			 currentImg.graphics.endFill();
		}
		
		//Load the png at the specified coordinates
		private function loadPNG(png:String, x:uint, y:uint, mouse:Boolean=false):void{
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{onComplete(e,x,y,png,mouse)});
    		loader.load(new URLRequest(png));
		}
		
		//Actual function that creates the sprite with the bitmap data
		private function onComplete(event:Event, x:uint, y:uint, file:String, mouse:Boolean=false):void
		{
			var loadinfo:LoaderInfo = LoaderInfo(event.target);
		    var bitmapData:BitmapData = Bitmap(loadinfo.content).bitmapData;
		  
		  	//Add offset when adding objects using the mouse
		    if(mouse){
		    	x += bitmapData.width/2;
		    	y += bitmapData.height/2;
		    }
		    
		    b2 = new ExSprite(x,y);
		    b2.pixels = bitmapData;
		    b2.initShape();
			b2.createPhysBody(the_world);
			b2.final_body.SetStatic();
			add(b2);
			
    		var s:Array = [file, x, y, "static"];
    		config.push(s.join(","));
    						
			trace("----------- CONFIG FILE ---------");
			for(var i:uint = 0; i < config.length; i++){
				trace(config[i]);
			}
		}

		//Load the config file to set up world...
		public function loadConfigFile(file:String):void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadConfigComplete);
			loader.load(new URLRequest(file));
		}
		
		//Actual callback function for load finish
		private function onLoadConfigComplete(event:Event):void{
			var text:String = event.target.data as String;
			trace(text);
			
			//Read the config file... can be replaced by xml later...
			var cols:Array;
			var rows:Array = text.split("\n");
			for(var i:uint = 0; i < rows.length; i++){
				cols = rows[i].split(",");
				if(cols[0] != "")
					loadPNG(cols[0], cols[1], cols[2]);
			}
		}
		
		private function addSprite(file:String,x:uint,y:uint):void
		{
			loadPNG(file,x,y);
		}
		
		//Can't do this effectively well in flash 9...
		public function saveFile():void{
			
		}
		
		public function onCopy(e:Event):void{
			copy(config.join("\n"));
		}
		
		private function copy(text:String):void{
            System.setClipboard(text);
        }

		
		private function initBox2DDebugRendering():void
		{
			if(debug){
				var debug_draw:b2DebugDraw = new b2DebugDraw();
				var debug_sprite:Sprite = new flash.display.Sprite();
				addChild(debug_sprite);
				debug_draw.SetSprite(debug_sprite);
				debug_draw.SetDrawScale(1);
				debug_draw.SetAlpha(0.5);
				debug_draw.SetLineThickness(1);
				debug_draw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit);
				the_world.SetDebugDraw(debug_draw);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if(FlxG.keys.justReleased("E")) 
				edit = !edit;

			last_index = index;
			if(FlxG.keys.justReleased("LBRACKET")) {
				index--;
			}
			if(FlxG.keys.justReleased("RBRACKET")){
				index++;
			}
			
			if(index >= files.length) index = files.length - 1;
			if(index < 0) index = 0;
			
			if(last_index != index)
				setCurrentImg(files[index]);
			
			currentImg.x = mouseX;
			currentImg.y = mouseY;
			
			var mode:String = edit ? "EDITING MODE" : "VIEWING MODE";
			var status:Array = [mode, "FILE: " + files[index]];
			setOverlay(status.join(" | "), edit ? RED : WHITE);
			currentImg.alpha = edit ? .7 : .5;
			
			if(edit && FlxG.mouse.justPressed()){
				loadPNG(files[index], FlxG.mouse.x, FlxG.mouse.y, true);
			}
			
		}
	}
}