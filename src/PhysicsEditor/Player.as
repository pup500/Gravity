package PhysicsEditor
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class Player extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		
		private var gFixture:b2Fixture;
		
		public function Player(x:int=0, y:int=0)
		//(x:int=0, y:int=0, bullets:Array=null)
		{
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			bodyDef.type = b2Body.b2_kinematicBody;
			
			initBoxShape();
			fixtureDef.isSensor = true;
			fixtureDef.filter.groupIndex = -2;
			fixtureDef.density = 0;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			
			name = "Player";
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			
		}
		
		private function addSensor():void{
			var e:ExState;
			var s:b2PolygonShape = new b2PolygonShape();
			//Sensor is only portion of width
			s.SetAsOrientedBox((width*.4)/ExState.PHYS_SCALE, 1/ExState.PHYS_SCALE, 
				new b2Vec2(0, (height/2)/ExState.PHYS_SCALE),0);
			
			//var s:b2CircleShape = new b2CircleShape(2 / ExState.PHYS_SCALE);
			
			//s.SetLocalPosition(new b2Vec2(0, (height/2) / ExState.PHYS_SCALE));
			
			var f:b2FixtureDef = new b2FixtureDef();
			f.shape = s;
			f.isSensor = true;
			f.density = 0;
			fixtureDef.filter.groupIndex = -2;
			//final_body.SetPosition(new b2Vec2(x/ ExState.PHYS_SCALE, (y + 32) / ExState.PHYS_SCALE));
			gFixture = final_body.CreateFixture(f);
		}
		
		override public function createPhysBody(world:b2World, controller:b2Controller=null):void{
			super.createPhysBody(world, controller);
			addSensor();
		}
		
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			var _applyForce:b2Vec2 = new b2Vec2(0,0);
			
			final_body.GetLinearVelocity().SetZero();
			if(FlxG.keys.A)
			{
				facing = LEFT;
				final_body.GetLinearVelocity().x = -10;
				play("run");
			}
			else if(FlxG.keys.D)
			{
				facing = RIGHT;
				final_body.GetLinearVelocity().x = 10;
				play("run");
			}
			else if(FlxG.keys.W){
				final_body.GetLinearVelocity().y = -10;
				play("run");
			}
			else if(FlxG.keys.S){
				final_body.GetLinearVelocity().y = 10;
				play("run");
			}
			else{
					
				play("idle");
			}

			super.update();
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			if(myFixture == gFixture){
				trace("canJump");
			}
			else{
				trace("can't jump");
			}
		}
	}
}