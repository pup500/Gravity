package com.adamatomic.Mode
{
	import org.flixel.*;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Player extends MassedFlxSprite
	{
		[Embed(source="../../../data/spaceman.png")] private var ImgSpaceman:Class;
		[Embed(source="../../../data/gibs.png")] private var ImgGibs:Class;
		[Embed(source="../../../data/jump.mp3")] private var SndJump:Class;
		[Embed(source="../../../data/land.mp3")] private var SndLand:Class;
		[Embed(source="../../../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../../../data/menu_hit_2.mp3")] private var SndExplode2:Class;
		[Embed(source="../../../data/hurt.mp3")] private var SndHurt:Class;
		[Embed(source="../../../data/jam.mp3")] private var SndJam:Class;
		
		
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
		
		public function Player(X:int,Y:int,Bullets:Array)
		{
			super(X, Y, ImgSpaceman);
			loadGraphic(ImgSpaceman,true,true,8);
			_restart = 0;
			_mass = 100; //default
			
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
			
			//bullet stuff
			_bullets = Bullets;
			_curBullet = 0;
			_bulletVel = 200;//360;
			
			//_gibs = FlxG.state.add(new FlxEmitter());//0,0,0,0,null,-1.5,-150,150,-200,0,-720,720,400,0,ImgGibs,60,true)) as FlxEmitter;
		
			_coolDown = new Timer(500,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
			_canShoot = true;
			
			_moving = false;
			_lastVel = new Point();
			_lastVel.x = velocity.x;
		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				_restart += FlxG.elapsed;
				if(_restart > 2)
					FlxG.switchState(GravSpawnFlanTilesState);
				return;
			}
			
			//facing = acceleration.x < 0;
			
			//MOVEMENT
			//acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x -= (40 * 8);//drag.x;
				_moving = true;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x += (40 * 8);//drag.x;
				_moving = true;
			}
			
			if(!velocity.x || (_lastVel.x > 0 && velocity.x < 0) || (_lastVel.x < 0 && velocity.x > 0)){
				_moving = false;
			}
			
			//if(!velocity.y && !FlxG.kRight && !FlxG.kLeft){
			
			if(!velocity.y){
				var mu:Number = _moving ? .9 : 1.59;
				
				var friction:Number = acceleration.y * mu;
				
				var pullRight:Boolean = velocity.x > 0;
				
				friction = pullRight ? -friction : friction;
				trace("fr: " + friction + " acce.y" + acceleration.y +  " acce.x" + acceleration.x + " vel.x" + velocity.x + " last.vx" + _lastVel.x);
				
				if(Math.abs(friction) - Math.abs(acceleration.x) >= 0) {
					acceleration.x = 0;
					velocity.x = 0;
				}
				else{
					acceleration.x += friction;
				}
			}
			
			//if(!velocity.x && !FlxG.kRight && !FlxG.kLeft){
			//	acceleration.x = 0;
			//}
			
			//Trying to see if we don't have to use C, instead just use up....
			//if(FlxG.justPressed(FlxG.A) && !velocity.y)
			if(FlxG.keys.UP && !velocity.y)
			{
				velocity.y = -_jumpPower;
				FlxG.play(SndJump);
			}
			
			//AIMING
			_up = false;
			_down = false;
			if(FlxG.keys.UP) _up = true;
			else if(FlxG.keys.DOWN && velocity.y) _down = true;
			
			//ANIMATION
			if(velocity.y != 0)
			{
				if(_up) play("jump_up");
				else if(_down) play("jump_down");
				else play("jump");
			}
			else if(velocity.x == 0)
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
			
			_lastVel.x = velocity.x;
			super.update();
			
			mouseShoot();
			
			//keyShoot();
		}
		
		private function keyShoot():void{
			if(flickering())
			{
				if(FlxG.keys.C)
					FlxG.play(SndJam);
				return;
			}
			if(FlxG.keys.C)
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;
				if(_up)
				{
					bY -= _bullets[_curBullet].height - 4;
					bYVel = -_bulletVel;
				}
				else if(_down)
				{
					bY += height - 4;
					bYVel = _bulletVel;
					velocity.y -= 36;
				}
				else if(facing == RIGHT)
				{
					bX += width - 4;
					bXVel = _bulletVel;
				}
				else
				{
					bX -= _bullets[_curBullet].width - 4;
					bXVel = -_bulletVel;
				}
				
				//Make the player push in opposite direction as bullet
				//velocity.x = -bXVel;
				//velocity.y = -bYVel;
				
				_bullets[_curBullet].shoot(bX,bY,bXVel,bYVel);
				if(++_curBullet >= _bullets.length)
					_curBullet = 0;
			}
		}
		
		private function stopTimer($e:TimerEvent):void{
			_canShoot = true;
		}
		
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
		
		override public function hitFloor(Contact:FlxCore=null):Boolean
		{
			if(velocity.y > 50)
				FlxG.play(SndLand);
			return super.hitFloor();
		}
		
		
		override public function hitWall(Contact:FlxCore=null):Boolean
		{
			return super.hitWall();
		}
		
		override public function hurt(Damage:Number):void
		{
			Damage = 0;
			if(flickering())
				return;
			FlxG.play(SndHurt);
			flicker(1.3);
			if(FlxG.score > 1000) FlxG.score -= 1000;
			if(velocity.x > 0)
				velocity.x = -maxVelocity.x;
			else
				velocity.x = maxVelocity.x;
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			FlxG.play(SndExplode);
			FlxG.play(SndExplode2);
			super.kill();
			flicker(-1);
			exists = true;
			visible = false;
			FlxG.quake(0.005,0.35);
			FlxG.flash(0xffd8eba2,0.35);
			_gibs.x = x + width/2;
			_gibs.y = y + height/2;
			_gibs.restart();
		}
	}
}