package PhysicsGame
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.*;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	
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
		private var _isJumping:Boolean;
		private var _antiGravity:Boolean;
		
		//private var _canJumpSensor:b2PolygonDef;
		
		public function Player(x:int=0, y:int=0, bullets:Array=null)
		{
			super(x, y, ImgSpaceman);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			initShape();
			fixtureDef.friction = .5;
			fixtureDef.restitution = .5;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			name = "Player";
			
			var filter:b2FilterData = new b2FilterData();
			fixtureDef.filter.groupIndex = -2;
			fixtureDef.filter.categoryBits = 0x0001;
			
			bodyDef.type = b2Body.b2_dynamicBody;
			
			
			_restart = 0;
			_nextLevel = false;
			//_mass = 100; //default
			
			//basic player physics
			//var runSpeed:uint = 40;//80;
			//_jumpPower = 100;
			//maxVelocity.x = runSpeed;
			//maxVelocity.y = _jumpPower;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			//addAnimation("idle_up", [0]);
			//addAnimation("run_up", [6, 7, 8, 5], 12);
			//addAnimation("jump_up", [0]);
			//addAnimation("jump_down", [0]);
			
			//Bullet shooting stuff
			_bullets = bullets;
			_curBullet = 0;
			_bulletVel = 20;
			_canShoot = true;
			_coolDown = new Timer(500,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
			
			_canJump = false;
			_isJumping = false;
			
			_antiGravity = false;
			
			//_canJumpSensor = new b2PolygonDef();//new Sensor(this.x - (width / 2 - 1), this.y + height / 2 + 1, width - 2, 2, "loaded");
			//_canJumpSensor.SetAsBox((width -1) / 2, 1);
		}
		
		override public function createPhysBody(world:b2World):void
		{
			super.createPhysBody(world);
			//final_body.CreateShape(_canJumpSensor);
		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			/*
			if(_nextLevel){
				FlxG.level++;
				FlxG.switchState(XMLPhysState);
			}
			*/
			
			//final_body.SetLinearDamping(.5);
			
			
			var _applyForce:b2Vec2 = new b2Vec2(0,0);
			
			//trace("vel.x " + final_body.GetLinearVelocity().x);
			//MOVEMENT
			//acceleration.x = 0;
			if(FlxG.keys.A)
			{
				facing = LEFT;
				_applyForce.x = _canJump ? -5 : -2;
				_applyForce.y = 0;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				//final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				
				if(final_body.GetLinearVelocity().x < -2) {
					
				}
				else
				
					final_body.ApplyForce(_applyForce, final_body.GetWorldCenter());
				//final_body.GetLinearVelocity().x = -30;
			}
			else if(FlxG.keys.D)
			{
				facing = RIGHT;
				//final_body.GetLinearVelocity().x = 30;
				_applyForce.x = _canJump ? 5 : 2;
				_applyForce.y = 0;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				if(final_body.GetLinearVelocity().x > 2) {
				}
				else
				//final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
					final_body.ApplyForce(_applyForce, final_body.GetWorldCenter());
			}

			//trace("can jump: " + _canJump);
			//trace("vel" + final_body.m_linearVelocity.y);
			////TODO only when collision from bottom
			if((FlxG.keys.SPACE || FlxG.keys.W) && _canJump)//impactPoint.position.y > y + height - 1)///&& Math.abs(final_body.m_linearVelocity.y) < 0.1)
			{
				//Hack... attempt at jumping...
				//impactPoint.position.y = -100;
				_canJump = false;
				_isJumping = true;
				
				
				//velocity.y = -_jumpPower;
				//final_body.SetLinearVelocity(new b2Vec2(0,-_jumpPower));
				_applyForce.x = 0;
				_applyForce.y = -3;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				
				FlxG.log(_applyForce.y + " || " + final_body.GetMass());
				//trace("mass" + final_body.GetMass());
				
				//Apply a instantaneous upward force.
				final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				//final_body.GetLinearVelocity().Set(_applyForce.x, _applyForce.y);
				FlxG.play(SndJump);
			}
			
			//Make it so player doesn't rotate.
			//final_body.m_sweep.a = 0;
			
			//AIMING
			_up = false;
			_down = false;
			if(FlxG.keys.W) _up = true;
			else if(FlxG.keys.S && velocity.y) _down = true;
			
			//trace("XXXYYY: " + final_body.GetLinearVelocity().x + ", " + final_body.GetLinearVelocity().y);
			
			//ANIMATION
			if(Math.abs(final_body.GetLinearVelocity().y) > 0.1)
			{
				play("jump");
				
				//if(_up) play("jump_up");
				//else if(_down) play("jump_down");
				//else play("jump");
				//trace("jumping");
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
		
		override public function setImpactPoint(point:b2Contact):void{
			super.setImpactPoint(point);
			
			//TODO:This doesn't let us jump when we are on slopes
			if(point.GetManifold().m_localPlaneNormal.y == 1){
				_canJump = true;
			}
			
			//trace("imp: " + impactPoint.position.y + " playy:" + y + " hei: " + height + " both:" + (y + height));
			//if(impactPoint.position.y > y + height-3 && final_body.GetLinearVelocity().y >= 0){
				//_canJump = true;
			//}
			//trace(impactPoint.position.y > y + height-3);
			/*
			if(point.shape1.GetBody().GetUserData() && point.shape1.GetBody().GetUserData().name == "end"){
				_nextLevel = true;
			}
			if(point.shape2.GetBody().GetUserData() && point.shape2.GetBody().GetUserData().name == "end"){
				_nextLevel = true;
			}
			*/
		}
		
		override public function removeImpactPoint(point:b2Contact):void{
			super.removeImpactPoint(point);
			
			if(point.GetManifold().m_localPlaneNormal.y == 1){
				_canJump = false;
			}
			
			//if(impactPoint.position.y > y + height/2){
			//	_canJump = false;
			//}
		}
		
		override public function hurt(Damage:Number):void{
			
		}
	}
}