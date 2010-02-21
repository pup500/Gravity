package PhysicsEditor
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import PhysicsGame.Components.InputComponent;
	import PhysicsGame.Components.PhysicsComponent;
	import PhysicsGame.FilterData;
	
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
			
			//inputComponent = new InputComponent(this);
			
			//NOTE:This is how you should adjust the player's mass
			//There's 3 parts to him, Head, Torso, And Feet Sensor..
			//Pass in friction, and density
			//TODO:Refactor the shapes out of the physics
			physicsComponent = new PhysicsComponent(this, FilterData.PLAYER);
			physicsComponent.initBody();
			physicsComponent.addHead();
			physicsComponent.addTorso(0, 15);
			gFixture = physicsComponent.addSensor(0.8,1);
			
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
			//_bullets = bullets;
		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			physicsComponent.update();
			//inputComponent.update();
			
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
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			//We can impact with sensor but we just won't use that for jump check
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				//_canJump = true;
			}
		}
		
		override public function removeImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				//_canJump = false;
			}
		}
	}
}