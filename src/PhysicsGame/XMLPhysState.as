package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
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
			controller = new GravityObjectController();
			the_world.AddController(controller);
			
			//debug = true;
			initBox2DDebugRendering();
			
			//ev.visible = true;
			
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
			
			//Create a gravity controller, give it all b2d bodies that need to interact with each other
			
			//Objects should be added to the controller when it is created dynamically
			//This allows for spawners
			/*for (var bb:b2Body = the_world.GetBodyList(); bb; bb = bb.GetNext()) 
			{
				//Moves this if statement from every step to this init.
				if (bb.GetType() == b2Body.b2_dynamicBody) 
					_gravityController.AddBody(bb);
			}
			*/

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
			
			var body:Player = new Player(args["startPoint"].x, args["startPoint"].y);
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
			FlxG.followBounds(0,0,2400,960);
		}
		
		public function addEndPoint():void{
			//Fix sensor...
			var body:Sensor = new Sensor(args["endPoint"].x, args["endPoint"].y);
			body.loadGraphic(endPoint);
			body.createPhysBody(the_world);
			
			//TODO:Make this more concise
			var levelEvent:EventObject = new EventObject();
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
			the_world.SetContactListener(new ContactListener());
		}
		
		override public function update():void
		{
			//Allow quiting even if level is not loaded...
			if(FlxG.keys.justReleased("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			//Allows XML Map Loader to determine when it is finished loading the level
			xmlMapLoader.update();
			
			//Don't update if we aren't loaded...
			if(!_loaded){
				return;
			}
			
			super.update();
			
			//ApplyGravityForces();
		}
		
		//Not used anymore, logic moved to GravityObjectController.
		private function ApplyGravityForces():void
		{
			for (var bb:b2Body = the_world.GetBodyList(); bb; bb = bb.GetNext()) {
				
				if(bb.GetType() == b2Body.b2_dynamicBody){//bb.IsDynamic()){
				
				//if(bb.GetUserData() && bb.GetUserData().name == "Player"){
					for(var i:uint = 0; i < _gravObjects.length; i++){
						
						var gObj:GravityObject = _gravObjects[i] as GravityObject;
						if(!gObj.exists || gObj.dead) continue;
						
						var force:b2Vec2 = gObj.GetGravityForce(bb);
						
						bb.ApplyForce(force,bb.GetWorldCenter());
					}
				//}
				}
			}
		}
	}
}