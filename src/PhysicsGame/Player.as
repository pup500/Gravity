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
		
		private var _jumpPower:int;
		private var _gibs:FlxEmitter;
		
		//public var _canJump:Boolean;
		//public var _jumpTimer:Timer;
		//public var _justJumped:Boolean;
		
		//private var inputComponent:InputComponent;
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
			//Sets the player physics component to be of type player
			//physicsComponent = new PhysicsComponent(this, FilterData.PLAYER);
			
			physicsComponent.setCategory(FilterData.PLAYER);
			physicsComponent.initBody(b2Body.b2_dynamicBody);
			physicsComponent.addHead();
			physicsComponent.addTorso(0, 15);
			gFixture = physicsComponent.addSensor(0.8,1);
			
			loaded = true;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			name = "Player";
			health = 20;
				
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			//addAnimation("idle_up", [0]);
			//addAnimation("run_up", [6, 7, 8, 5], 12);
			//addAnimation("jump_up", [0]);
			//addAnimation("jump_down", [0]);
			
			
			//TODO:
			//_jumpTimer = new Timer(500,1);
			//_jumpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, jumpTimer);
			
			//_canJump = false;
			//_justJumped = false;
		}
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			
			
			//UPDATE POSITION AND ANIMATION			
			super.update();
		}
		
		/*
		private function jumpTimer($e:TimerEvent):void{
			_justJumped = false;
		}
		*/
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			//We can impact with sensor but we just won't use that for jump check
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				components.sendMessage({"type": "IO", "canJump": true});
				//_canJump = true;
			}
		}
		
		override public function removeImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				components.sendMessage({"type": "IO", "canJump": false});
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