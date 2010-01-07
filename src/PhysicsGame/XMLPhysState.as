package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
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
		private var b2:ExSprite; //For creating environment physical objects.
		private var time_count:Timer=new Timer(1000);
		
		public function XMLPhysState() 
		{
			super();
			bgColor = 0xffeeeeff;
			
			//debug = true;
			initBox2DDebugRendering();
			
			loadLevelConfig();
			
			FlxG.showCursor(cursor);
			
			initContactListener();
			
			//Allow for loaded status even when we might not have loaded any level file...
			//We might need to do a better io error handling in loadconfigfile for the xml loader
			//For now, it will allow the player to play a not loaded map...
			_loaded = true;
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
			xmlMapLoader = new XMLMap(this);
			xmlMapLoader.loadConfigFile(file);
		}
		
		private function createBullets():void{
			_bullets = new Array();
			_gravObjects = new Array();
			
			//Create GravityObjects
			for(var i:uint= 0; i < 8; i++){
				_gravObjects.push(this.add(new AntiGravityObject(the_world)));
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
			var body:Player = new Player(start.x, start.y, _bullets);
			
			body.createPhysBody(the_world);
			body.final_body.AllowSleeping(false);
			body.final_body.SetFixedRotation(true);
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
			if(!_loaded){
				return;
			}
			
			super.update();
			
			if(FlxG.keys.justReleased("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			//Testing
			for (var bb:b2Body = the_world.GetBodyList(); bb; bb = bb.GetNext()) {
				
				if(bb.IsDynamic()){
				//if(bb.GetUserData() && bb.GetUserData().name == "Player"){
					for(var i:uint = 0; i < _gravObjects.length; i++){
						
						var gObj:GravityObject = _gravObjects[i] as GravityObject;
						if(!gObj.exists) continue;
						
						var force:b2Vec2 = gObj.GetGravityForce(bb);
						
						bb.ApplyForce(force,bb.GetWorldCenter());
					}
				}
			}
		}
	}
}