package PhysicsGame
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.b2ContactPoint;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	
	public class EndPoint extends ExSprite
	{
		[Embed(source="../data/end_point.png")] private var EndSprite:Class;
		
		
		public function EndPoint(x:int=0, y:int=0)
		{
			super(x, y, EndSprite);
			loadGraphic(EndSprite,true,true);
			
			initShape();
			shape.friction = 0.02;
			name = "end";
			
			//animations
			addAnimation("idle", [0]);
		}
		
		
		override public function update():void
		{
			//game restart timer
			if(dead)
			{
				return;
			}
			
			
			super.update();
		}
		
		override public function setImpactPoint(point:b2ContactPoint):void{
			super.setImpactPoint(point);
		}
	}
}