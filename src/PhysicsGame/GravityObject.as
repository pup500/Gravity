package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.overrides.ExSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class GravityObject extends ExSprite
	{
		[Embed(source="../data/GravSink.png")] private var GravSink:Class;
		
		protected var _world:b2World;
		public var mass:Number;
		private var initialMass:Number = 5000;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function GravityObject(world:b2World)
		{
			super();
			loadGraphic(GravSink, true);
			initShape();
			//shape.friction = 1;
			shape.density = 0;
			shape.isSensor = true;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			shape.filter.groupIndex = -2;
			
			name = "GravityObject";
			
			_world = world; //For use when we shoot.
			
			offset.x = 1;
			offset.y = 1;
			exists = false;
			
			addAnimation("idle",[0], 50);
			//addAnimation("poof",[2, 3, 4], 50, false);
		}
		
		//TODO: prevent super.createPhysBody(world) form being called?
		public function destroyPhys():void{
			if(exists){
				exists = false;
				//We might not need to save shape as destroy body should work already...
				final_body.DestroyShape(final_shape);
				_world.DestroyBody(final_body);
				final_shape = null;
				final_body = null;
			}
		}
		
		override public function update():void
		{
			if(dead && finished){
				destroyPhys();
			}
			else { 
				super.update();
				trace("X: " + x + ", " + y);
				mass -= 1000 * FlxG.elapsed;
				if(mass < 0){
					dead = true;
				}
				alpha = mass/ initialMass;
			}
		}
		
		override public function render():void
		{
			super.render();
		}
		
		
		//override public function hitWall(Contact:FlxCore=null):Boolean { hurt(0); return true; }
		//override public function hitFloor(Contact:FlxCore=null):Boolean { hurt(0); return true; }
		//override public function hitCeiling(Contact:FlxCore=null):Boolean { hurt(0); return true; }
		override public function hurt(Damage:Number):void
		{
			if(dead) return;
			
			//var gravityState:GravSpawnFlanTilesState =  FlxG.state as GravSpawnFlanTilesState;
			//gravityState.createGravityAtLocation(this);
			
			//velocity.x = 0;
			//velocity.y = 0;
			//if(onScreen()) FlxG.play(SndHit);
			//dead = true;
			//play("poof");
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			destroyPhys();
			
			body.position.Set(X, Y);
			createPhysBody(_world);
			
			mass=initialMass;
			
			/*
			var bmass:b2MassData = new b2MassData();
			bmass.center.x = X + width/2;
			bmass.center.y = Y + height/2;
			bmass.I = 0;
			bmass.mass = 0;
			final_body.SetMass(bmass);
			*/
			
			//final_body.SetBullet(true);
			//final_body.m_linearVelocity.Set(VelocityX, VelocityY);
			
			play("idle");
			//FlxG.play(SndShoot);
			
			super.reset(X,Y);
		}
	}

}