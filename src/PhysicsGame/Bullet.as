package PhysicsGame 
{
	import org.overrides.ExSprite;
	import org.flixel.FlxG;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Bullet extends ExSprite
	{
		[Embed(source="../data/bot_bullet.png")] private var ImgBullet:Class;
		[Embed(source="../data/jump.mp3")] private var SndHit:Class;
		[Embed(source="../data/shoot.mp3")] private var SndShoot:Class;
		
		protected var _world:b2World;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function Bullet(world:b2World)
		{
			super();
			loadGraphic(ImgBullet, true);
			initShape();
			
			_world = world; //For use when we shoot.
			
			offset.x = 1;
			offset.y = 1;
			exists = false;
			
			addAnimation("idle",[0, 1], 50);
			addAnimation("poof",[2, 3, 4], 50, false);
		}
		
		//TODO: prevent super.createPhysBody(world) form being called?
		
		
		override public function update():void
		{
			if(dead && finished) exists = false;
			else super.update();
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
			
			velocity.x = 0;
			velocity.y = 0;
			if(onScreen()) FlxG.play(SndHit);
			dead = true;
			play("poof");
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			body.position.Set(X, Y);
			super.createPhysBody(_world);
			final_body.SetBullet(true);
			final_body.m_linearVelocity.Set(VelocityX, VelocityY);
			
			FlxG.play(SndShoot);
			
			super.reset(X,Y);
		}
	}

}