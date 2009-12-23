package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class PhysState extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		[Embed(source = "../data/bot.png")] private var botSprite:Class;
		
		private var _map:MapBase;
		private var _bullets:Array;
		private var _gravObjects:Array;
		private var b2:ExSprite; //For creating environment physical objects.
		private var time_count:Timer=new Timer(1000);
		private var spawned:uint = 0;
		
		public function PhysState() 
		{
			super();
			
			debug = true;
			
			createMap();
			
			_bullets = new Array();
			_gravObjects = new Array();
			var body:Player = new Player(150, 100, _bullets);
			body.createPhysBody(the_world);
			body.final_body.AllowSleeping(false);
			add(body);
			
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
			
			initContactListener();
		}
		
		public function createMap():void{
			_map = new MapOneGap();
			for(var i:uint= 0; i < _map.mainLayer._sprites.length; i++){
				b2 = _map.mainLayer._sprites[i] as ExSprite;
				b2.createPhysBody(the_world);
				
				//Don't add the sprite because it doesn't have any graphics...
				//It should be taken care of in the tile map...
				//add(b2);
			}
			add(_map.mainLayer);
		}
		
		public function on_time(e:Event):void {
			//Create an ExSprite somewhere above the screen so it falls downward.
			var body:ExSprite = new ExSprite(Math.random()*300+10, 0, botSprite);
			body.name = "Player";
			body.loadGraphic(botSprite,true, true); //Loading again to set animation.
			body.initShape();
			body.createPhysBody(the_world);
			add(body);
			
			spawned++;
			FlxG.log("item spawned" + spawned);
		}
		
		private function initBox2DDebugRendering():void
		{
			if(debug){
				var debug_draw:b2DebugDraw = new b2DebugDraw();
				var debug_sprite:Sprite = new flash.display.Sprite();
				addChild(debug_sprite);
				debug_draw.m_sprite=debug_sprite;
				debug_draw.m_drawScale=1;
				debug_draw.m_fillAlpha=0.5;
				debug_draw.m_lineThickness=1;
				debug_draw.m_drawFlags=b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit;
				the_world.SetDebugDraw(debug_draw);
			}
		}
		
		private function initContactListener():void{
			the_world.SetContactListener(new ContactListener());
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
			
			//Testing
			for (var bb:b2Body = the_world.m_bodyList; bb; bb = bb.m_next) {
				
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
						//if(distSq > 1000 ) continue;
						
						//This is a physics hack to stop adding gravity to objects when they are too close
						//they aren't pulling anymore because of normal force
						//if(distanceSq < 100) continue;
						
						var distance:Number = Math.sqrt(distSq);
						var massProduct:Number = bb.m_mass * gMass;
						//var massProduct:Number = massedObj.getMass() * gravObj.getMass();	//_player.mass * gravObj.mass;
						
						var G:Number = 1; //gravitation constant
						
						var force:Number = G*(massProduct/distSq);
						
						//force = Math.log(force) * 20;
						
						if(force > 200) force = 200;
						if(force < -200) force = -200;
						
						//trace(distance);
						trace("dist:" + distance + " force:" + force + " forx:" + force * (dist.x/distance) + " fory:" + force * (dist.y/distance));
						
						bb.ApplyImpulse(new b2Vec2(force * (dist.x/distance), force * (dist.y/distance)),bb.GetWorldCenter());
						
						//massedObj.accel.x += ;//xDistance >= 0 ? xForce :-xForce;
						//massedObj.accel.y += force * (yDistance/distance);//yDistance >= 0 ? yForce :-yForce;
					}
				}
			}
		}
	}
}