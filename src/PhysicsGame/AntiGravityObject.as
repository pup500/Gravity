package PhysicsGame 
{
	import PhysicsGame.GravityObject;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Shape;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class AntiGravityObject extends GravityObject
	{
		public function AntiGravityObject(world:b2World):void
		{
			super(world);
		}
		
		override public function GetGravityForce(physBody:b2Body):b2Vec2
		{
			var force:b2Vec2 = super.GetGravityForce(physBody);
			return force.Negative();
		}
		
		override public function render():void
		{
			if(!visible)
				return;
			getScreenXY(_p);

			var myShape:Shape = new Shape();
			myShape.graphics.beginFill(0xff0000, alpha/2);//alpha/3+.1);
			 
			  myShape.graphics.drawCircle(_p.x + width/2,_p.y + height/2, alpha*50);
			myShape.graphics.endFill();
			  FlxG.buffer.draw(myShape);
			
			super.render();
			
		}
	}

}