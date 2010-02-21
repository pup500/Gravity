package PhysicsGame
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import PhysicsGame.Components.InputComponent;
	import PhysicsGame.Components.PhysicsComponent;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class Player extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		[Embed(source="../data/gibs.png")] private var ImgGibs:Class;
		[Embed(source="../data/jump.mp3")] private var SndJump:Class;
		[Embed(source="../data/land.mp3")] private var SndLand:Class;
		[Embed(source="../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../data/menu_hit_2.mp3")] private var SndExplode2:Class;
		[Embed(source="../data/hurt.mp3")] private var SndHurt:Class;
		[Embed(source="../data/jam.mp3")] private var SndJam:Class;
		
		private var _lastVel:Point;
		private var _moving:Boolean;
		
		private var _nextLevel:Boolean;
		
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
		
		public var _canJump:Boolean;
		public var _jumpTimer:Timer;
		public var _justJumped:Boolean;
		private var _antiGravity:Boolean;
		
		private var inputComponent:InputComponent;
		public var gFixture:b2Fixture;
		
		public function Player(x:int=0, y:int=0){
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			//Do this after to set graphics and shape first...
			width = 14;
			height = 30;
			
			inputComponent = new InputComponent(this);
			
			//NOTE:This is how you should adjust the player's mass
			//There's 3 parts to him, Head, Torso, And Feet Sensor..
			//Pass in friction, and density
			//TODO:Refactor the shapes out of the physics
			physicsComponent = new PhysicsComponent(this, FilterData.PLAYER);
			physicsComponent.initBody();
			physicsComponent.addHead();
			physicsComponent.addTorso(0, 15);
			gFixture = physicsComponent.addSensor(0.8,1);
			
			loaded = true;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			name = "Player";
			health = 20;
			
			_restart = 0;
			_nextLevel = false;

			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			//addAnimation("idle_up", [0]);
			//addAnimation("run_up", [6, 7, 8, 5], 12);
			//addAnimation("jump_up", [0]);
			//addAnimation("jump_down", [0]);
			
			_curBullet = 0;
			_bulletVel = 20;
			_canShoot = true;
			_coolDown = new Timer(500,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
			
			_jumpTimer = new Timer(500,1);
			_jumpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, jumpTimer);
			
			_canJump = false;
			_justJumped = false;
			
			_antiGravity = false;
		}
		
		override public function GetBody():b2Body{
			return physicsComponent.final_body;
		}
		
		/*
		//Overridden normal behavior, using a physics component,
		//TODO:Fix exsprite to remove physics dependency
		override public function createPhysBody(world:b2World, controller:b2Controller=null):void{
			//Save the world
			_world = world;
			_controller = controller;
			
			if(controller){
				controller.AddBody(GetBody());
			}
			
			loaded = true;
		}
		*/
		
		public function SetBullets(bullets:Array):void{
			_bullets = bullets;
		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			//physicsComponent.update();
			inputComponent.update();
			
			//ANIMATION
			if(Math.abs(GetBody().GetLinearVelocity().y) > 0.1)
			{
				play("jump");
				
				//if(_up) play("jump_up");
				//else if(_down) play("jump_down");
				//else play("jump");
				////trace("jumping");
			}
			else if(Math.abs(GetBody().GetLinearVelocity().x) < 0.1)
			{
				play("idle");
				//if(_up) play("idle_up");
				//else play("idle");
			}
			else
			{
				//if(_up) play("run_up");
				
				if(FlxG.keys.A || FlxG.keys.D)
					play("run");
				else
					play("idle");
			}
			
			//UPDATE POSITION AND ANIMATION			
			super.update();
			
			changeGravityObjectInput();
			
			mouseShoot();
			
			gravObjKillSwitch();
			changeGravObjButton();
		}
		
		private function changeGravObjButton():void
		{
			if (FlxG.keys.justPressed("F"))
			{
				FlxG.play(SndExplode);
				
				_antiGravity = !_antiGravity;
			}
		}
		
		private function gravObjKillSwitch():void
		{
			if (FlxG.keys.justPressed("Q"))
			{
				FlxG.play(SndExplode);
				
				for each(var bullet:Bullet in _bullets)
				{
					bullet.killGravityObject();
				}
			}
		}
		
		private function changeGravityObjectInput():void
		{
			if (FlxG.keys.justPressed("F"))
			{
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
				
				var bX:Number = x + width/2;
				var bY:Number = y + height*.2;
				
				/*
				if(facing == RIGHT)
				{
					bX += width - 4;
				}
				else
				{
					bX -= _bullets[_curBullet].width - 4;
				}*/
				
				/*
				if(angle.y > height){
					bY += height - 4;
				}
				else if(angle.y < -height){
					bY -= height - 4;
				}*/
				
				//Shoot it!!
				_bullets[_curBullet].shoot(bX,bY,_bulletVel * angle.x/dist, _bulletVel * angle.y/dist, _antiGravity);
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
		
		private function jumpTimer($e:TimerEvent):void{
			_justJumped = false;
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			//We can impact with sensor but we just won't use that for jump check
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				_canJump = true;
			}
		}
		
		override public function removeImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				_canJump = false;
			}
		}
		
		override public function hurt(Damage:Number):void{
			health -= Damage;
			
			if(Damage > 0){
				//dead = true;
				flicker(2);
			}
		}
		
		override public function render():void{
			super.render();
			
			drawGroundRayTrace();
		}
	}
}