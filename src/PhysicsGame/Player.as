package PhysicsGame
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.events.TimerEvent;
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
		private var _up:Boolean;
		private var _down:Boolean;
		private var _restart:Number;
		private var _gibs:FlxEmitter;
		
		private var _bullets:Array;
		private var _curBullet:uint;
		private var _bulletVel:int;
		private var _coolDown:Timer;
		private var _canShoot:Boolean;
		
		public function Player(x:int=0, y:int=0, bullets:Array=null)
		{
			super(x, y, ImgSpaceman);
			loadGraphic(ImgSpaceman,true,true);
			initShape();
			//Make this part of group -2, and do not collide with other in the same negative group...
			shape.filter.groupIndex = -2;
			
			name = "Player";
			
			_restart = 0;
			//_mass = 100; //default
			
			//basic player physics
			var runSpeed:uint = 40;//80;
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
			
			//Bullet shooting stuff
			_bullets = bullets;
			_curBullet = 0;
			_bulletVel = 200;
			_canShoot = true;
			_coolDown = new Timer(500,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
		}
		
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			var _applyForce:b2Vec2 = new b2Vec2(0,0);
			
			//MOVEMENT
			//acceleration.x = 0;
			if(FlxG.keys.A)
			{
				facing = LEFT;
				final_body.GetLinearVelocity().x = -20;
			}
			else if(FlxG.keys.D)
			{
				facing = RIGHT;
				final_body.GetLinearVelocity().x = 20;
			}

			//trace("vel" + final_body.m_linearVelocity.y);
			trace("ipy: " + impactPoint.y + " y: " + y);
			////TODO only when collision from bottom
			if((FlxG.keys.SPACE || FlxG.keys.W) && impactPoint.y > y + height - 1)///&& Math.abs(final_body.m_linearVelocity.y) < 0.1)
			{
				//Hack... attempt at jumping...
				impactPoint.y = -100;
				
				
				//velocity.y = -_jumpPower;
				//final_body.SetLinearVelocity(new b2Vec2(0,-_jumpPower));
				_applyForce.x = 0;
				_applyForce.y = -80;
				_applyForce.Multiply(final_body.GetMass());
				
				//trace("mass" + final_body.GetMass());
				
				//Apply a instantaneous upward force.
				final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				FlxG.play(SndJump);
			}
			
			//Make it so player doesn't rotate.
			//final_body.m_sweep.a = 0;
			
			//AIMING
			_up = false;
			_down = false;
			if(FlxG.keys.W) _up = true;
			else if(FlxG.keys.S && velocity.y) _down = true;
			
			//ANIMATION
			if(Math.abs(final_body.GetLinearVelocity().y) > 0.1)
			{
				if(_up) play("jump_up");
				else if(_down) play("jump_down");
				else play("jump");
				//trace("jumping");
			}
			else if(Math.abs(final_body.GetLinearVelocity().x) < 0.1)
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
			
			mouseShoot();
			
			gravObjKillSwitch();
		}
		
		private function gravObjKillSwitch():void
		{
			if (FlxG.keys.Q)
			{
				for each(var bullet:Bullet in _bullets)
				{
					bullet.killGravityObject();
				}
			}
		}
		
		private function mouseShoot():void{
			if(FlxG.mouse.justPressed() && _canShoot){
				FlxG.log("mouse x: " + FlxG.mouse.x + " mouse y: " + FlxG.mouse.y);
				FlxG.log("player x: " + x + " player y: " + y);
				
				var angle:Point = new Point(FlxG.mouse.x - x, FlxG.mouse.y - y);
				var dist:Number = Math.sqrt(angle.x * angle.x + angle.y * angle.y);
				
				FlxG.log("angle.x: " + angle.x + " angle.y: " + angle.y);
				FlxG.log("dist" + dist);
				
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
				
				if(angle.y > height){
					bY += height - 4;
				}
				else if(angle.y < -height){
					bY -= height - 4;
				}
				
				//Shoot it!!
				_bullets[_curBullet].shoot(bX,bY,_bulletVel * angle.x/dist, _bulletVel * angle.y/dist);
				//Set the next bullet to be shot to the first in the array for recycling.
				if(++_curBullet >= _bullets.length)
					_curBullet = 0;
				
				//Maybe we should try to work with elapsed time instead of creating timer events...
				_canShoot = false;
				_coolDown.reset();
				_coolDown.start();
			}
		}
		
		private function stopTimer($e:TimerEvent):void{
			_canShoot = true;
		}
		
		override public function hurt(Damage:Number):void{
			
		}
	}
}