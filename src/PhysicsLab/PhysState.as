package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.*;
	
	import SVG.b2SVG;
	
	import flash.display.BitmapData;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class PhysState extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		[Embed(source ="../data/bot.png")] private var botSprite:Class;
		//[Embed(source="../data/Maps/box.svg", mimeType="application/octet-stream")] public var lineSVG:Class;
		[Embed(source = "../data/spawner.png")] private var ImgSpawner:Class;
		
		private var _bullets:Array;
		private var _gravObjects:Array;
		private var b2:ExSprite; //For creating environment physical objects.
		private var time_count:Timer=new Timer(1000);
		private var spawned:uint = 0;
		
		public function PhysState() 
		{
			super();
			bgColor = 0xffeeeeff;
			
			debug = true;
			
			//loadConfigFile("data/level2.txt");
			
			//loadSVG();
			
			//createMap();
			
			_bullets = new Array();
			_gravObjects = new Array();

			controller = new GravityObjectController();
			the_world.AddController(controller);
			
			createBullets();
			addPlayer();
			
			addSensor();
			
			//--Debug stuff--//
			initBox2DDebugRendering();
			createDebugPlatform();
			//Timer to rain physical objects every second.
			//time_count.addEventListener(TimerEvent.TIMER, on_time);
			//time_count.start();
			
			initContactListener();
		}
			
		private function createBullets():void {
			_bullets = new Array();
			_gravObjects = new Array();
			
			//Create GravityObjects
			for(var i:uint= 0; i < 8; i++){
				_gravObjects.push(this.add(new GravityObject(the_world)));
				//don't create physical body, wait till bullet is shot.
			}
			
			//Create bullets
			for(i = 0; i < 8; i++){
				var bullet:Bullet = new Bullet(the_world, controller);
				bullet.setGravityObject(_gravObjects[i]);
				_bullets.push(this.add(bullet));
				//don't create physical body, wait till bullet is shot.
			}
			
			var gController:GravityObjectController = controller as GravityObjectController;
			gController._gravObjects = _gravObjects;
			
		}
		
		//Player will be called from the xmlMapLoader when the xml file is read...
		public function addPlayer():void{
			//var start:Point = xmlMapLoader.getStartPoint();
			
			var body:PhysicsGame.Player = new PhysicsGame.Player(200, 200);
			body.createPhysBody(the_world, controller);
			
			body.GetBody().SetSleepingAllowed(false);
			body.GetBody().SetFixedRotation(true);
			body.SetBullets(_bullets);
			
			add(body);
			
			//Set camera to follow player movement.
			//This works, in debug mode it looks weird but that's because of layer offset...
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			//FlxG.followBounds(0,0,640,640);
			FlxG.followBounds(0,0,1280,960);
		}
		
		private function addSensor():void
		{
			var sense:Sensor = new Sensor(150,290, "Player");
			sense.createPhysBody(the_world);
			add(sense);
			
			var anim:PlayAnimationEvent = new PlayAnimationEvent(100, 100, ImgSpawner, "open");
			anim.addAnimation("open", [1, 2, 3, 4, 5], 40, false);
			add(anim);
			sense.AddEvent(anim);
		}
		/*
		//Load the png at the specified coordinates
		private function loadPNG(png:String, x:Number, y:Number, s:String):void{
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{onComplete(e,x,y,s)});
    		loader.load(new URLRequest(png));
		}
		
		//Actual function that creates the sprite with the bitmap data
		private function onComplete (event:Event, x:Number, y:Number, s:String):void
		{
		    var bitmapData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
		    b2 = new ExSprite(x,y);
		    b2.pixels = bitmapData;
		    b2.initShape(b2Shape.e_polygonShape);
			b2.createPhysBody(the_world);
			if(s == "static")
				b2.final_body.SetStatic();
			else{
				b2.final_body.SetAngularVelocity(.1);
			}
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
				loadPNG(cols[0], cols[1], cols[2], cols[3]);
			}
		}
		*/
		//private function loadSVG():void{
			//var myxml:XML = new XML(new lineSVG);
			//b2SVG.parseSVG(myxml, the_world, 3,0);
		//}
		
		//private function getMapByLevel():MapBase{
			//trace(FlxG.level);
			//trace(FlxG.levels[FlxG.level]);
			//var ClassReference:Class = getDefinitionByName(FlxG.levels[FlxG.level]) as Class;
			//return new ClassReference() as MapBase;
		//}
		
		//public function createMap():void{
			//_map = getMapByLevel();
			//
			//for(var i:uint= 0; i < _map.mainLayer._sprites.length; i++){
				//b2 = _map.mainLayer._sprites[i] as ExSprite;
				//b2.createPhysBody(the_world);
				//
				//Don't add the sprite because it doesn't have any graphics...
				//It should be taken care of in the tile map...
				//add(b2);
			//}
			//add(_map.mainLayer);
		//}
		
		public function on_time(e:Event):void {
			//Create an ExSprite somewhere above the screen so it falls downward.
			var body:ExSprite = new ExSprite(Math.random()*300+10, 0, botSprite);
			body.name = "Player";
			body.loadGraphic(botSprite,true, true); //Loading again to set animation.
			body.initShape(1);
			var shapdef:b2PolygonShape =  body.GetShape() as Box2D.Collision.Shapes.b2PolygonShape;
			body.createPhysBody(the_world);
			add(body);
			
			spawned++;
			FlxG.log("item spawned" + spawned);
		}
		
		private function initContactListener():void{
			the_world.SetContactListener(new ContactListener());
		}
		
		private function createDebugPlatform():void
		{
			//Platform for raining objects to interact with.
			b2 = new ExSprite(300, 300, botSprite);
			b2.initShape(1);
			b2.createPhysBody(the_world); //Add b2 as a physical body to Box2D's world.
			b2.GetBody().SetType(b2Body.b2_staticBody);
			add(b2); //Add b2 as a sprite to Flixel's update loop.
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}