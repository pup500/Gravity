package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Bullet extends ExSprite
	{
		[Embed(source="../data/new_shot.png")] private var ImgBullet:Class;
		[Embed(source="../data/grav_pos2.mp3")] private var SndHit:Class;
		[Embed(source="../data/grav_pos1.mp3")] private var SndShoot:Class;
		
		protected var _gravityObject:GravityObject;
		private var _spawn:Boolean;
		private var spawnPos:b2Vec2;
		
		private static var count:uint = 0;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function Bullet(world:b2World, controller:b2Controller)
		{
			super();
			
			width = 8;
			initCircleShape();
			
			loadGraphic(ImgBullet, true);
			//shape.friction = 1;
			//Make this part of group -2, and do not collide with other in the same negative group...
			//So player does not collide with bullets
			
			fixtureDef.friction = 1;
			
			//SThis prevents collision with player and player sensor,
			//same category bit as player and same group as player....
			fixtureDef.filter.groupIndex = -2;
			fixtureDef.filter.categoryBits = 0x0001;
			
			
			//bodyDef.type = b2Body.b2_kinematicBody;
			
			name = "Bullet" + count;
			count++;
			
			_world = world; //For use when we shoot.
			_controller = controller;
			
			//offset.x = 1;
			//offset.y = 1;
			exists = false;
			_spawn = false;
			spawnPos = new b2Vec2();
			
			bodyDef.bullet = true;
			
			//addAnimation("idle",[0, 1, 2, 3, 4, 5], 50);
			addAnimation("idle",[0], 50);
			//addAnimation("poof",[2, 3, 4], 50, false);
		}
		
		override public function update():void
		{
			if(dead && finished){
				destroyPhysBody();
				if(_spawn){
					_spawn = false;
					_gravityObject.shoot(spawnPos.x * ExState.PHYS_SCALE, spawnPos.y * ExState.PHYS_SCALE, 0, 0);//impactPoint.position.x,impactPoint.position.y,0,0);
				}
			}
			else { 
		//		trace("bullet:" + name +  " x,y:" + x + "," + y);
		//		trace("dead:" + dead + " finished: " + finished);
				super.update();
				
		//		trace("bullet speed" + final_body.GetLinearVelocity().x + "," + final_body.GetLinearVelocity().y);
			}
		}
		
		override public function render():void
		{
			super.render();
		}
		
		override public function hurt(Damage:Number):void
		{
			if(dead) return;
			
			//Cannot create objects in hurt, this is called in collision....
			_spawn = true;
			
			final_body.GetLinearVelocity().SetZero();
			if(onScreen()) FlxG.play(SndHit);
			dead = true;
			
			//play("poof");
		}
		
		public function killGravityObject():void 
		{
			_gravityObject.kill();
		}
		
		public function setGravityObject(gravityObject:GravityObject):void{
			_gravityObject = gravityObject;
		}

		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int, antiGravity:Boolean=false):void
		{
			destroyPhysBody();
			
			bodyDef.position.Set(X/ExState.PHYS_SCALE, Y/ExState.PHYS_SCALE);
			createPhysBody(_world, _controller);
			final_body.SetBullet(true);
			final_body.SetLinearVelocity(new b2Vec2(VelocityX, VelocityY));
		//	trace("bullet speed" + final_body.GetLinearVelocity().x + "," + final_body.GetLinearVelocity().y);
			//final_body.ApplyImpulse(new Box2D.Common.Math.b2Vec2(VelocityX,VelocityY), new Box2D.Common.Math.b2Vec2(x, y));
			play("idle");
			FlxG.play(SndShoot);
			
		//	trace("bullet shoot");
			
			_gravityObject.antiGravity = antiGravity;
			
			super.reset(X,Y);
		}
		
		override public function setImpactPoint(point:b2Contact, oBody:b2Body):void{
			super.setImpactPoint(point, oBody);
			
			var worldManifold:b2WorldManifold = new b2WorldManifold();
			point.GetWorldManifold(worldManifold);
			
			if(worldManifold.m_points.length > 1){
				spawnPos = worldManifold.m_points[0];
			}
			
			hurt(0);
		}
	}
}