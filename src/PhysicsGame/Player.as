package PhysicsGame
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	
	public class Player extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		
		public var gFixture:b2Fixture;
		
		public function Player(x:int=0, y:int=0){
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			//Do this after to set graphics and shape first...
			width = 14;
			height = 30;
			
			//NOTE:This is how you should adjust the player's mass
			//There's 3 parts to him, Head, Torso, And Feet Sensor..
			//Pass in friction, and density
			//TODO:Refactor the shapes out of the physics
			//Sets the player physics component to be of type player
			//physicsComponent = new PhysicsComponent(this, FilterData.PLAYER);
			
			physicsComponent.setCategory(FilterData.PLAYER);
			physicsComponent.initBody(b2Body.b2_kinematicBody);
			gFixture = null;
			
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
		}
		
		public function initBody():void{
			physicsComponent.initBody(b2Body.b2_dynamicBody);
			physicsComponent.addHead();
			physicsComponent.addTorso(0, 15);
			gFixture = physicsComponent.addSensor(0.8,1);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			//We can impact with sensor but we just won't use that for jump check
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				components.sendMessage({"type": "IO", "canJump": true});
			}
		}
		
		//Currently, the contact listener is not calling this function
		//So you can jump while falling for now
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