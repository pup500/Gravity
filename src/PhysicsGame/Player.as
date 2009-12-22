package PhysicsGame
{
	import Box2D.Common.Math.b2Vec2;
	
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.ExSprite;

	public class Player extends ExSprite
	{
		[Embed(source="../data/spaceman.png")] private var ImgSpaceman:Class;
		[Embed(source="../data/gibs.png")] private var ImgGibs:Class;
		[Embed(source="../data/jump.mp3")] private var SndJump:Class;
		[Embed(source="../data/land.mp3")] private var SndLand:Class;
		[Embed(source="../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../data/menu_hit_2.mp3")] private var SndExplode2:Class;
		[Embed(source="../data/hurt.mp3")] private var SndHurt:Class;
		[Embed(source="../data/jam.mp3")] private var SndJam:Class;
		
		private var _lastVel:Point;
		private var _moving:Boolean;
		
		private var _jumpPower:int;
		private var _bullets:Array;
		private var _curBullet:uint;
		private var _bulletVel:int;
		private var _up:Boolean;
		private var _down:Boolean;
		private var _restart:Number;
		private var _gibs:FlxEmitter;
		
		private var _coolDown:Timer;
		private var _canShoot:Boolean;
		
		public function Player(x:int=0, y:int=0, sprite:Class=null)
		{
			super(x, y, ImgSpaceman);
			loadGraphic(ImgSpaceman,true,true,8);
			initShape();
			
			_restart = 0;
			//_mass = 100; //default
			
			//bounding box tweaks
			width = 6;
			height = 7;
			offset.x = 1;
			offset.y = 1;
			
			//basic player physics
			var runSpeed:uint = 40;//80;
			//drag.x = runSpeed*8;
			//acceleration.y = 420;
			_jumpPower = 100;
			maxVelocity.x = runSpeed;
			maxVelocity.y = _jumpPower;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);
		}
		
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			//facing = acceleration.x < 0;
			
			var _applyForce:b2Vec2 = new b2Vec2(0,0);
			
			//MOVEMENT
			//acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				//final_body.SetLinearVelocity(new b2Vec2(-40,0));
				final_body.m_linearVelocity.x = -20;
				
				//_applyForce.x = -10;
				//_applyForce.y = 0;
				//_applyForce.Multiply(final_body.GetMass());
				//final_body.ApplyForce(_applyForce, final_body.GetWorldCenter());
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				final_body.m_linearVelocity.x = 20;
				
				//_applyForce.x = 10;
				//_applyForce.y = 0;
				//_applyForce.Multiply(final_body.GetMass());
				//final_body.ApplyForce(_applyForce, final_body.GetWorldCenter());
			}
			
			//if(!velocity.x && !FlxG.kRight && !FlxG.kLeft){
			//	acceleration.x = 0;
			//}
			
			trace("vel" + final_body.m_linearVelocity.y);
			
			////TODO only when collision from bottom
			if(FlxG.keys.UP && Math.abs(final_body.m_linearVelocity.y) < 0.1)
			{
				//velocity.y = -_jumpPower;
				//final_body.SetLinearVelocity(new b2Vec2(0,-_jumpPower));
				_applyForce.x = 0;
				_applyForce.y = -40;
				_applyForce.Multiply(final_body.GetMass());
				
				trace("mass" + final_body.GetMass());
				
				//Apply a instantaneous upward force.
				final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				FlxG.play(SndJump);
			}
			
			//Make it so player doesn't rotate.
			final_body.m_sweep.a = 0;
			
			//AIMING
			_up = false;
			_down = false;
			if(FlxG.keys.UP) _up = true;
			else if(FlxG.keys.DOWN && velocity.y) _down = true;
			
			//ANIMATION
			if(Math.abs(final_body.m_linearVelocity.y) > 0.1)
			{
				if(_up) play("jump_up");
				else if(_down) play("jump_down");
				else play("jump");
				trace("jumping");
			}
			else if(Math.abs(final_body.m_linearVelocity.x) < 0.1)
			{
				if(_up) play("idle_up");
				else play("idle");
			}
			else
			{
				if(_up) play("run_up");
				
				if(FlxG.keys.RIGHT || FlxG.keys.LEFT)
					play("run");
				else
					play("idle");
			}
			
			//UPDATE POSITION AND ANIMATION
			
			super.update();
			
			//mouseShoot();
			
			//keyShoot();
		}
		
		/*
		private function mouseShoot():void{
			if(FlxG.mouse.justPressed() && _canShoot){
				trace("mouse x: " + FlxG.mouse.x + " mouse y: " + FlxG.mouse.y);
				trace("player x: " + x + " player y: " + y);
				
				var angle:Point = new Point(FlxG.mouse.x - x, FlxG.mouse.y - y);
				var dist:Number = Math.sqrt(angle.x * angle.x + angle.y * angle.y);
				
				trace("angle.x: " + angle.x + " angle.y: " + angle.y);
				trace("dist" + dist);
				
				facing = angle.x > 0 ? RIGHT : angle.x < 0 ? LEFT : facing;
				
				var bX:Number = x;
				var bY:Number = y;
				
				if(facing == RIGHT)
				{
					bX += width - 4;
				}
				else
				{
					bX -= _bullets[_curBullet].width - 4;
				}
				
				_bullets[_curBullet].shoot(bX,bY,_bulletVel * angle.x/dist, _bulletVel * angle.y/dist);
				if(++_curBullet >= _bullets.length)
					_curBullet = 0;
					
				_canShoot = false;
				_coolDown.reset();
				_coolDown.start();
			}
		}
		*/
	}
}