package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.MapClasses.*;
	
	import SVG.b2SVG;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		[Embed(source ="../data/bot.png")] private var botSprite:Class;
		[Embed(source="../data/Maps/box.svg", mimeType="application/octet-stream")] public var lineSVG:Class;
		
		private var b2:ExSprite; //For creating environment physical objects.
		private var time_count:Timer=new Timer(1000);
		private var spawned:uint = 0;
		
		public function SpriteEditor() 
		{
			super();
			//debug = true;
			
			loadConfigFile("data/level1.txt");
			
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
			
		}
		
		//Load the png at the specified coordinates
		private function loadPNG(png:String, x:Number, y:Number):void{
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{onComplete(e,x,y)});
    		loader.load(new URLRequest(png));
		}
		
		//Actual function that creates the sprite with the bitmap data
		private function onComplete (event:Event, x:Number, y:Number):void
		{
		    var bitmapData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
		    b2 = new ExSprite(x,y);
		    b2.pixels = bitmapData;
		    b2.initShape();
			b2.createPhysBody(the_world);
			b2.final_body.SetStatic();
			add(b2);
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
				loadPNG(cols[0], cols[1], cols[2]);
			}
		}
		
		private function loadSVG():void{
			var myxml:XML = new XML(new lineSVG);
			b2SVG.parseSVG(myxml, the_world, 3,0);
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
		
		private function createDebugPlatform():void
		{
			//Platform for raining objects to interact with.
			b2 = new ExSprite(150, 150, botSprite);
			b2.initShape();
			b2.shape.density = 0; //0 density makes object stationary.
			b2.shape.SetAsBox(175, 10);
			b2.createPhysBody(the_world); //Add b2 as a physical body to Box2D's world.
			add(b2); //Add b2 as a sprite to Flixel's update loop.
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}