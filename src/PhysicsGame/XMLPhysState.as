package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Controllers.b2GravityController;
	
	import common.XMLMap;
	
	import flash.geom.Point;
	import flash.utils.Timer;
	
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
		
		private var xmlMapLoader:XMLMap;
		
		private var _bullets:Array;
		private var _gravObjects:Array;
		
		private var _gravityController:GravityObjectController;
		
		public function XMLPhysState() 
		{
			super();
			bgColor = 0xffeeeeff;
			
			//debug = true;
			initBox2DDebugRendering();
			
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
			_gravityController = new GravityObjectController();
			_gravityController._gravObjects = _gravObjects;
			for (var bb:b2Body = the_world.GetBodyList(); bb; bb = bb.GetNext()) 
			{
				//Moves this if statement from every step to init.
				if (bb.GetType() == b2Body.b2_dynamicBody) 
					_gravityController.AddBody(bb);
			}
			the_world.AddController(_gravityController);
		}
		
		private function loadLevelConfig():void{
			var file:String = FlxG.levels[FlxG.level];
			xmlMapLoader = new XMLMap(this);
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
				var bullet:Bullet = new Bullet(the_world);
				bullet.setGravityObject(_gravObjects[i]);
				_bullets.push(this.add(bullet));
				//don't create physical body, wait till bullet is shot.
			}
		}
		
		//Player will be called from the xmlMapLoader when the xml file is read...
		public function addPlayer():void{
			var start:Point = xmlMapLoader.getStartPoint();
			
			var body:Player = new Player(start.x, start.y);
			body.createPhysBody(the_world);
			
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
		
		public function addEndPoint():void{
			var end:Point = xmlMapLoader.getEndPoint();
			//Fix sensor...
			var body:Sensor = new Sensor(end.x, end.y);
			body.loadGraphic(endPoint);
			body.createPhysBody(the_world);
			body.AddEvent(new ChangeLevelEvent(FlxG.level + 1));
			
			add(body);
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