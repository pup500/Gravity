package PhysicsGame
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
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
		
		private var _canJump:Boolean;
		private var _jumpTimer:Timer;
		private var _justJumped:Boolean;
		private var _antiGravity:Boolean;
		
		private var gFixture:b2Fixture;
		
		public function Player(x:int=0, y:int=0){
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			//Do this after to set graphics and shape first...
			width = 14;
			height = 30;
			
			//var s:b2CircleShape = new b2CircleShape(0);//(width/2)/ExState.PHYS_SCALE);
			//s.SetLocalPosition(new b2Vec2(0, (height/4)/ ExState.PHYS_SCALE));
			var s:b2PolygonShape = new b2PolygonShape();
			s.SetAsOrientedBox(width/2/ExState.PHYS_SCALE, height/4/ExState.PHYS_SCALE,
				new b2Vec2(0, height/4/ExState.PHYS_SCALE));
			
			shape = s;
			
			//initCircleShape();
			//initBoxShape();
			
			fixtureDef.friction = 0;
			fixtureDef.restitution = 0;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			name = "Player";
			health = 20;
			
			fixtureDef.filter.categoryBits = FilterData.PLAYER;
			
			//adding this to play around with player's density to get maximum platformy/gravity-y goodness - MK
			fixtureDef.density = 15;
			
			
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
		
		private function addHead():void{
			var s:b2CircleShape = new b2CircleShape((width/2)/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, -(height/4) / ExState.PHYS_SCALE));
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			f.friction = 0;
			f.density = 1;
			f.filter.categoryBits = FilterData.PLAYER;
			final_body.CreateFixture(f);
		}
		
		private function addSensor():void{
			var e:ExState;
			
			var s:b2CircleShape = new b2CircleShape(1/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, (height/2)/ExState.PHYS_SCALE));
			
			//var s:b2PolygonShape = new b2PolygonShape();
			//Sensor is only portion of width
			//s.SetAsOrientedBox((width/4)/ExState.PHYS_SCALE, 1/ExState.PHYS_SCALE, 
			//	new b2Vec2(0, (height/2)/ExState.PHYS_SCALE),0);
			
			
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			//f.isSensor = true;
			f.friction = .8;
			f.density = 0;
			f.filter.categoryBits = FilterData.PLAYER;
			gFixture = final_body.CreateFixture(f);
		}
		
		override public function createPhysBody(world:b2World, controller:b2Controller=null):void{
			super.createPhysBody(world, controller);
			addHead();
			addSensor();
		}
		
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
			
			//final_body.SetLinearDamping(.5);
			
			
			var _applyForce:b2Vec2 = new b2Vec2(0,0);
			
			////trace("vel.x " + final_body.GetLinearVelocity().x);
			//MOVEMENT
			//acceleration.x = 0;
			if(FlxG.keys.A)
			{
				facing = LEFT;
				_applyForce.x = -75;//_canJump ? -7 : -2;  (this was originally -7 -MK)
				_applyForce.y = 0;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				//final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				
				if(final_body.GetLinearVelocity().x < -3.5) {
					
				}
				else
				
					final_body.ApplyForce(_applyForce, final_body.GetWorldCenter());
				//final_body.GetLinearVelocity().x = -30;
			}
			else if(FlxG.keys.D)
			{
				facing = RIGHT;
				//final_body.GetLinearVelocity().x = 30;
				_applyForce.x = 75;//_canJump ? 7 : 2;    (this was originally 7  -MK)
				_applyForce.y = 0;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				if(final_body.GetLinearVelocity().x > 3.5) {
				}
				else
				//final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
					final_body.ApplyForce(_applyForce, final_body.GetWorldCenter());
			}

			////trace("can jump: " + _canJump);
			////trace("vel" + final_body.m_linearVelocity.y);
			////TODO only when collision from bottom
			if((FlxG.keys.SPACE || FlxG.keys.W) && _canJump && !_justJumped)//impactPoint.position.y > y + height - 1)///&& Math.abs(final_body.m_linearVelocity.y) < 0.1)
			{
				//Hack... attempt at jumping...
				//impactPoint.position.y = -100;
				_canJump = false;
				_justJumped = true;
				_jumpTimer.start();
				
				//velocity.y = -_jumpPower;
				//final_body.SetLinearVelocity(new b2Vec2(0,-_jumpPower));
				_applyForce.x = 0;
				_applyForce.y = -5;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				_applyForce.Multiply(final_body.GetMass());
				
				FlxG.log(_applyForce.y + " || " + final_body.GetMass());
				////trace("mass" + final_body.GetMass());
				
				//Apply a instantaneous upward force.
				final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				//final_body.GetLinearVelocity().Set(_applyForce.x, _applyForce.y);
				FlxG.play(SndJump);
			}
			
			//AIMING
			_up = false;
			_down = false;
			if(FlxG.keys.W) _up = true;
			else if(FlxG.keys.S && velocity.y) _down = true;
			
			////trace("XXXYYY: " + final_body.GetLinearVelocity().x + ", " + final_body.GetLinearVelocity().y);
			
			//ANIMATION
			if(Math.abs(final_body.GetLinearVelocity().y) > 0.1)
			{
				play("jump");
				
				//if(_up) play("jump_up");
				//else if(_down) play("jump_down");
				//else play("jump");
				////trace("jumping");
			}
			else if(Math.abs(final_body.GetLinearVelocity().x) < 0.1)
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