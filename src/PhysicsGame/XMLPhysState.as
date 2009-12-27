package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.MapClasses.*;
	
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
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		
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
			
			FlxG.showCursor(cursorSprite);
			
			initContactListener();
		}
		
		//Level configuration will call init when done...
		override public function init():void{
			createBullets();
			addPlayer();
			addEndPoint();
		}
		
		private function loadLevelConfig():void{
			try{
				var file:String = FlxG.levels[FlxG.level];
				xmlMapLoader = new XMLMap(this);
				xmlMapLoader.loadConfigFile(file);
			}
			catch(e:Error){
				FlxG.switchState(LevelSelectMenu);
			}
		}
		
		private function createBullets():void{
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
			var body:ExSprite = new ExSprite(end.x, end.y, cursorSprite);
			body.name = "end";
			body.shape.isSensor = true;
			body.initShape();
			body.createPhysBody(the_world);
			body.final_body.SetStatic();
			body.final_body.AllowSleeping(false);
			body.final_body.SetFixedRotation(true);

			add(body);
		}
		
		private function initContactListener():void{
			the_world.SetContactListener(new ContactListener());
		}
		
		override public function update():void
		{
			super.update();
			
			if(FlxG.keys.justReleased("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			//Testing
			for (var bb:b2Body = the_world.GetBodyList(); bb; bb = bb.GetNext()) {
				
				if(bb.GetUserData() && bb.GetUserData().name == "Player"){
					for(var i:uint = 0; i < _gravObjects.length; i++){
						var gObj:GravityObject = _gravObjects[i] as GravityObject;
						
						if(!gObj.exists) continue;
						
						var gMass:Number = gObj.mass;// Hack - use object's mass not physics mass because density = 0//gObj.final_body.m_mass;
						var gPoint:Point = new Point(gObj.final_body.GetPosition().x, gObj.final_body.GetPosition().y);
						var bbPoint:Point = new Point(bb.GetPosition().x, bb.GetPosition().y);
						var dist:Point = gPoint.subtract(bbPoint);
						var distSq:Number = dist.x * dist.x + dist.y * dist.y;
						
						//For performance reasons....  assume force is 0 when distance is pretty far
						//if(distSq > 4000 ) continue;
						
						//This is a physics hack to stop adding gravity to objects when they are too close
						//they aren't pulling anymore because of normal force
						//if(distanceSq < 100) continue;
						
						var distance:Number = Math.sqrt(distSq);
						var massProduct:Number = bb.GetMass() * gMass;
						//var massProduct:Number = massedObj.getMass() * gravObj.getMass();	//_player.mass * gravObj.mass;
						
						var G:Number = 1; //gravitation constant
						
						var force:Number = G*(massProduct/distSq);
						
						trace("force: " + force);
						//force = Math.log(force+1);
						
						//if(force > 100) force = 100;
						//if(force < -100) force = -100;
						
						//trace(distance);
						trace("mass: " + bb.GetMass());
						trace("dist:" + distance + " force:" + force + " forx:" + force * (dist.x/distance) + " fory:" + force * (dist.y/distance));
						
						var impulse:b2Vec2 = new b2Vec2(force * (dist.x/distance), force * (dist.y/distance));
						//impulse.Multiply(bb.GetMass());
						
						trace("impulsex: " + impulse.x + ", " + impulse.y);
						trace("impulsex: " + impulse.x /bb.GetMass() + ", " + impulse.y/bb.GetMass());
						
						//bb.ApplyImpulse(impulse,bb.GetWorldCenter());
						
						bb.ApplyForce(impulse,bb.GetWorldCenter());
						
						//massedObj.accel.x += ;//xDistance >= 0 ? xForce :-xForce;
						//massedObj.accel.y += force * (yDistance/distance);//yDistance >= 0 ? yForce :-yForce;
					}
				}
			}
		}
	}
}