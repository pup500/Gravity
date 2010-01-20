package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	
	import flash.geom.Point;
	
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
		
		//protected var _world:b2World;
		protected var _gravityObject:GravityObject;
		private var _spawn:Boolean;
		private var old:b2Vec2;
		
		private static var count:uint = 0;
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function Bullet(world:b2World)
		{
			super();
			loadGraphic(ImgBullet, true);
			initShape();
			//shape.friction = 1;
			//Make this part of group -2, and do not collide with other in the same negative group...
			//So player does not collide with bullets
			
			fixtureDef.friction = 1;
			fixtureDef.filter.groupIndex = -2;
			fixtureDef.filter.categoryBits = 0x0002;
			//bodyDef.type = b2Body.b2_kinematicBody;
			
			name = "Bullet" + count;
			count++;
			
			_world = world; //For use when we shoot.
			
			//offset.x = 1;
			//offset.y = 1;
			exists = false;
			_spawn = false;
			old = new b2Vec2();
			
			bodyDef.bullet = true;
			//bodyDef.isBullet = true;
			
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
					_gravityObject.shoot(old.x * ExState.PHYS_SCALE, old.y * ExState.PHYS_SCALE, 0, 0);//impactPoint.position.x,impactPoint.position.y,0,0);
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
			//old.x = x;
			//old.y = y;
			
		//	trace("bullet hit");
		//	trace("bulletxy" + old.x + "," + old.y);
			
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
			createPhysBody(_world);
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
		
		override public function setImpactPoint(point:b2Contact):void{
			super.setImpactPoint(point);
			
		//	trace("manifold type: "+ point.GetManifold().m_type);
			
			//Physics...
			old = final_body.GetWorldPoint(point.GetManifold().m_localPoint);
		//	trace("world: " + old.x + "," + old.y);
			//trace("world" + final_body.GetWorldPoint(old).x + "," + final_body.GetWorldPoint(old).y);
			
			hurt(0);
		}
	}

}