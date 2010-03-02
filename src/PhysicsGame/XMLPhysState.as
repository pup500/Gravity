package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.Components.AnimationComponent;
	import PhysicsGame.Components.InputComponent;
	import PhysicsGame.Components.WeaponsComponent;
	import PhysicsGame.Wrappers.WorldWrapper;
	
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class XMLPhysState extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursor:Class;
		[Embed(source="../data/end_point.png")] private var endPoint:Class;
		
		private var _bullets:Array;
		private var _gravObjects:Array;
		
		public function XMLPhysState() 
		{
			super();
			bgColor = 0xffeeeeff;
			
			WorldWrapper.controller = new GravityObjectController();
			
			//Turn this on to see physics box in play mode
			debug = true;
			initBox2DDebugRendering();
			
			//Turn this on to see sensors in play mode
			ev.visible = true;
			
			loadLevelConfig();
			
			FlxG.showCursor(cursor);
			
			initContactListener();
		}
		
		//Level configuration will call init when done...
		override public function init():void{
			super.init();
			createBullets();
			addPlayer();
			addEndPoint();
		}
		
		private function loadLevelConfig():void{
			var file:String = FlxG.levels[FlxG.level];
			xmlMapLoader.loadConfigFile(file);
		}
		
		private function createBullets():void {
			_bullets = new Array();
			_gravObjects = new Array();
			
			//Create GravityObjects
			for(var i:uint= 0; i < 8; i++){
				_gravObjects.push(this.add(new GravityObject()));
				//don't create physical body, wait till bullet is shot.
			}
			
			//Create bullets
			for(i = 0; i < 8; i++){
				var bullet:Bullet = new Bullet();
				bullet.setGravityObject(_gravObjects[i]);
				_bullets.push(this.add(bullet));
				//don't create physical body, wait till bullet is shot.
			}
			
			//Add gravity object to controller so that it can step through them with all other objects
			var gController:GravityObjectController = WorldWrapper.controller as GravityObjectController;
			gController._gravObjects = _gravObjects;
			
		}
		
		//Player will be called from the xmlMapLoader when the xml file is read...
		public function addPlayer():void{
			//var body:Enemy = new Enemy(args["startPoint"].x, args["startPoint"].y);
			var body:Player = new Player(args["startPoint"].x, args["startPoint"].y);
			body.initBody();
			body.registerComponent(new InputComponent(body));
			body.registerComponent(new WeaponsComponent(body, _bullets));
			body.registerComponent(new AnimationComponent(body));
			body.GetBody().SetSleepingAllowed(false);
			body.GetBody().SetFixedRotation(true);
			
			add(body);
			
			//Set camera to follow player movement.
			//This works, in debug mode it looks weird but that's because of layer offset...
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			//FlxG.followBounds(0,0,640,640);
			FlxG.followBounds(0,0,2400,960);
		}
		
		public function addEndPoint():void{
			//Fix sensor...
			var body:Sensor = new Sensor(args["endPoint"].x, args["endPoint"].y);
			body.loadGraphic(endPoint);
			
			//TODO:Make this more concise
			var levelEvent:EventObject = new EventObject(args["endPoint"].x, args["endPoint"].y);
			levelEvent.changeType(0);
			
			var a:Dictionary = new Dictionary();
			a["level"] = FlxG.level + 1;
			levelEvent.setArgs(a);
			
			body.AddEvent(levelEvent);
			//body.AddEvent(new ChangeLevelEvent(FlxG.level + 1));
			
			add(body);
			//addToLayer(body, ExState.EV);
		}
		
		private function initContactListener():void{
			WorldWrapper.setContactListener(new ContactListener());
		}
		
		override public function update():void
		{
			//Allow quiting even if level is not loaded...
			if(FlxG.keys.justReleased("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			super.update();
		}
	}
}