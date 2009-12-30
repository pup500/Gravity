package PhysicsGame 
{
	import org.overrides.ExSprite;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Sensor extends ExSprite
	{
		public function Sensor(X:int, Y:int, Width:int, Height:int) 
		{
			super(X, Y, null)
			name = "sensor";
			super.width = Width;
			super.height = Height;
			
			shape.isSensor = true;
			initShape();
		}
		
		override public function createPhysBody(world:b2World):void
		{
			super.createPhysBody(world);
			final_body.SetStatic();
		}
		
		override public function setImpactPoint(point:b2ContactPoint):void{
			super.setImpactPoint(point);
			
			if(point.shape1.GetBody().GetUserData() && point.shape1.GetBody().GetUserData().name == "Player"){
				FlxG.switchState(LevelSelectMenu);
			}
			if(point.shape2.GetBody().GetUserData() && point.shape2.GetBody().GetUserData().name == "Player"){
				FlxG.switchState(LevelSelectMenu);
			}
		}
	}
}