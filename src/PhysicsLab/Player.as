package PhysicsLab
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	
	public class Player extends ExSprite
	{
		[Embed(source="../data/spaceman.png")] private var ImgSpaceman:Class;
		
		public function Player(x:int=0, y:int=0, bullets:Array=null)
		{
			super(x, y, ImgSpaceman);
			loadGraphic(ImgSpaceman,true,true);
			initShape();
			//Make this part of group -2, and do not collide with other in the same negative group...
			//shape.filter.groupIndex = -2;
			
			shape.isSensor = true;
			
			name = "Player";
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);
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
				final_body.GetLinearVelocity().x = -70;
			}
			else if(FlxG.keys.D)
			{
				facing = RIGHT;
				final_body.GetLinearVelocity().x = 70;
			}
			
			if(FlxG.keys.W){
				final_body.GetLinearVelocity().y = -70;
			}
			if(FlxG.keys.S){
				final_body.GetLinearVelocity().y = 70;
			}

			super.update();
		}
	}
}