package PhysicsGame
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import ailab.*;
	import ailab.actions.*;
	import ailab.basic.*;
	import ailab.brains.*;
	import ailab.conditions.*;
	import ailab.decorators.*;
	import ailab.groups.*;
	
	import flash.display.Shape;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class Enemy extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		
		private var brain:TaskTree;
		
		private var gFixture:b2Fixture;

		public function Enemy(x:int=0, y:int=0){
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			//Do this after to set graphics and shape first...
			width = 14;
			height = 30;
			
			var s:b2CircleShape = new b2CircleShape((width/2)/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, (height/4)/ ExState.PHYS_SCALE));
			shape = s;
			
			//initCircleShape();
			//initBoxShape();
			
			fixtureDef.friction = .5;
			fixtureDef.restitution = 0;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			name = "Enemy";
			
			damage = 10;
			
			fixtureDef.filter.categoryBits = FilterData.ENEMY;

			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			//addAnimation("idle_up", [0]);
			//addAnimation("run_up", [6, 7, 8, 5], 12);
			//addAnimation("jump_up", [0]);
			//addAnimation("jump_down", [0]);

			//Working new brain
			brain = BrainFactory.createRandomBrain();//.createBrain(1);
			
			brain.blackboard.setObject("me", this);
			
			var _applyForce:b2Vec2 = new b2Vec2(1,0);
			brain.blackboard.setObject("force", _applyForce);
			
			brain.blackboard.setObject("canWalkForward", true);
		}
		
		private function addHead():void{
			var s:b2CircleShape = new b2CircleShape((width/2)/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, -(height/4) / ExState.PHYS_SCALE));
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			f.friction = 0;
			f.density = 1;
			f.filter.categoryBits = FilterData.ENEMY;
			final_body.CreateFixture(f);
		}
		
		private function addSensor():void{
			//TODO:We can probably add sensors to detect forward motion etc...
			
			var e:ExState;
			var s:b2PolygonShape = new b2PolygonShape();
			//Sensor is only portion of width
			s.SetAsOrientedBox((width/4)/ExState.PHYS_SCALE, 1/ExState.PHYS_SCALE, 
				new b2Vec2(0, (height/2)/ExState.PHYS_SCALE),0);
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			f.isSensor = true;
			f.density = 0;
			f.filter.categoryBits = FilterData.ENEMY;
			gFixture = final_body.CreateFixture(f);
		}
		
		override public function createPhysBody(world:b2World, controller:b2Controller=null):void{
			super.createPhysBody(world, controller);
			addHead();
			addSensor();
		}
		
		public function SetBullets(bullets:Array):void{
		}
		
		override public function update():void
		{
			brain.update();
			
			//UPDATE POSITION AND ANIMATION			
			super.update();
			
			brain.blackboard.setObject("moving", final_body.GetLinearVelocity().x > 0.1);
		}
		
		override public function render():void{
			super.render();
			
			drawGroundRayTrace();
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				brain.blackboard.setObject("canJump", true);
			}
			else{
				brain.blackboard.setObject("blocked", true);
			}
		}
		
		override public function removeImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.removeImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				brain.blackboard.setObject("canJump", false);
			}
			else{
				brain.blackboard.setObject("blocked", false);
			}
		}
	}
}