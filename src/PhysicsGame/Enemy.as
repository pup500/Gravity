package PhysicsGame
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import ai.*;
	import ai.actions.*;
	import ai.brains.BrainFactory;
	import ai.conditions.*;
	import ai.decorators.*;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class Enemy extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		
		//private var task:Task;
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
			name = "Player";
			
			//fixtureDef.filter.groupIndex = -2;
			fixtureDef.filter.categoryBits = 0x0002;

			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			//addAnimation("idle_up", [0]);
			//addAnimation("run_up", [6, 7, 8, 5], 12);
			//addAnimation("jump_up", [0]);
			//addAnimation("jump_down", [0]);
			
			brain = BrainFactory.createDefaultBrain();
			brain.blackboard.setObject("me", this);
		}
		
		private function addHead():void{
			var s:b2CircleShape = new b2CircleShape((width/2)/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, -(height/4) / ExState.PHYS_SCALE));
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			f.friction = 0;
			f.density = 1;
			//f.filter.groupIndex = -2;
			f.filter.categoryBits = 0x0002;
			final_body.CreateFixture(f);
		}
		
		private function addSensor():void{
			var e:ExState;
			var s:b2PolygonShape = new b2PolygonShape();
			//Sensor is only portion of width
			s.SetAsOrientedBox((width/4)/ExState.PHYS_SCALE, 1/ExState.PHYS_SCALE, 
				new b2Vec2(0, (height/2)/ExState.PHYS_SCALE),0);
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			f.isSensor = true;
			f.density = 0;
			//f.filter.groupIndex = -2;
			f.filter.categoryBits = 0x0002;
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
		}
		
		
		override public function setImpactPoint(point:b2Contact, oBody:b2Body):void{
			super.setImpactPoint(point, oBody);
			
			//TODO:Fix this so that the sensor doesn't do any collision impact with point
			//I think we might have to do this in presolve...
			if(oBody.GetUserData() is GravityObject || oBody.GetUserData() is Bullet) return;
			
			if(point.GetFixtureA() == gFixture || point.GetFixtureB() == gFixture){
				brain.blackboard.setObject("canJump", true);
			}
		}
		
		override public function removeImpactPoint(point:b2Contact, oBody:b2Body):void{
			super.setImpactPoint(point, oBody);
			
			//TODO:Fix this so that the sensor doesn't do any collision impact with point
			//I think we might have to do this in presolve...
			if(oBody.GetUserData() is GravityObject || oBody.GetUserData() is Bullet) return;
			
			
			if(point.GetFixtureA() == gFixture || point.GetFixtureB() == gFixture){
				brain.blackboard.setObject("canJump", true);
			}
		}
	}
}