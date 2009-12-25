package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.MapClasses.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		private var config:Array;
		
		private var edit:Boolean;
		private var text:FlxText;
		
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
			
			//loadSVG();
			
			//createMap();
			
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
			//createDebugPlatform();
			//Timer to rain physical objects every second.
			//time_count.addEventListener(TimerEvent.TIMER, on_time);
			//time_count.start();
			
			files = new Array();
			index = 0;
			
			//Add new files 
			var s:String = new configFile;
			var t:Array = s.split("\n");
			var c:Array;
			for(var i:uint=0; i < t.length; i++){
				c = t[i].split("=");
				files.push(c[1]);
			}
			
			edit = false;
			
			config = new Array();
			
			//text = new FlxText(0,100,files[index].length * 20,files[index]);
			//text.color = WHITE;
			//add(text);
			
			overlay = new TextField();
			overlay.x = 0;
			overlay.y = 0;
			addChild(overlay);
			
			currentImg = new Shape();
			//currentImg.x = 0;
			//currentImg.y = 15;
			addChild(currentImg);
			setCurrentImg(files[index]);
			
			FlxG.log("0-9 - switches between the tiles");
			FlxG.log("E - enters edit mode (mouse click to add new shape)");
			FlxG.log("Q - turns off edit mode");
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
			//var fileRef:FileReference = new FileReference();
			//fileRef.save( 'Here is some text', 'some.txt');

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
			
			if(FlxG.keys.E) edit = true;
			if(FlxG.keys.Q) edit = false;
			
			if(FlxG.keys.ONE) index = 0;
			if(FlxG.keys.TWO) index = 1;
			if(FlxG.keys.THREE) index = 2;
			if(FlxG.keys.FOUR) index = 3;
			if(FlxG.keys.FIVE) index = 4;
			if(FlxG.keys.SIX) index = 5;
			if(FlxG.keys.SEVEN) index = 6;
			if(FlxG.keys.EIGHT) index = 7;
			if(FlxG.keys.NINE) index = 8;
			
			if(index >= files.length) index = 0;
			
			if(FlxG.keys.ONE || FlxG.keys.TWO || FlxG.keys.THREE || FlxG.keys.FOUR || FlxG.keys.FIVE ||
				FlxG.keys.SIX || FlxG.keys.SEVEN || FlxG.keys.EIGHT || FlxG.keys.NINE || FlxG.keys.ZERO)
				setCurrentImg(files[index]);
			
			currentImg.x = mouseX;
			currentImg.y = mouseY;
			
			var mode:String = edit ? "EDIT" : "LOOK";
			var status:Array = [mode, files[index]];
			setOverlay(status.join(" | "), edit ? RED : WHITE);
			currentImg.alpha = edit ? .3 : 0;
			
			if(edit && FlxG.mouse.justPressed()){
				loadPNG(files[index], FlxG.mouse.x, FlxG.mouse.y, true);
			}
			
		}
	}
}