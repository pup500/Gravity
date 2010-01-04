package PhysicsGame 
{
	import PhysicsGame.GravityObject;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
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
	}

}