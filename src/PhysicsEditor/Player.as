package PhysicsEditor
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	
	public class Player extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		
		public function Player(x:int=0, y:int=0)
		//(x:int=0, y:int=0, bullets:Array=null)
		{
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			bodyDef.type = b2Body.b2_kinematicBody;
			
			initShape();
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
	}
}