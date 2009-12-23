package PhysicsGame
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;

	public class ContactListener extends b2ContactListener
	{
		public function ContactListener()
		{
			super();
		}
		
		/// Called when a contact point is added. This includes the geometry
		/// and the forces.
		override public function Add(point:b2ContactPoint) : void{
			var body1:b2Body = point.shape1.GetBody();
			var body2:b2Body = point.shape2.GetBody();
			trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
			body1.GetUserData().hurt(0);
			body2.GetUserData().hurt(0);
		}
	
		/// Called when a contact point persists. This includes the geometry
		/// and the forces.
		override public function Persist(point:b2ContactPoint) : void{
			//point.shape1.GetUserData().hurt(0);
			//point.shape2.GetUserData().hurt(0);
		}
	
		/// Called when a contact point is removed. This includes the last
		/// computed geometry and forces.
		override public function Remove(point:b2ContactPoint) : void{
			//point.shape1.GetUserData().hurt(0);
			//point.shape2.GetUserData().hurt(0);
		}
		
		/// Called after a contact point is solved.
		//override public function Result(point:b2ContactResult) : void{
		
		//}
			
	}
}