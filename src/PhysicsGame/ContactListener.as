package PhysicsGame
{
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;

	public class ContactListener extends b2ContactListener
	{
		public function ContactListener()
		{
			super();
		}
		
		/// Called when a contact point is added. This includes the geometry
		/// and the forces.
		override public function BeginContact(contact:b2Contact) : void {
			super.BeginContact(contact);
		
			//trace("normal" + contact.GetManifold().m_localPlaneNormal.x + "," + contact.GetManifold().m_localPlaneNormal.y);
			//var body1:b2Body = point.shape1.GetBody();
			//var body2:b2Body = point.shape2.GetBody();
			
			//Changed to this for Box2D 2.1a. We're using b2Fixtures instead of b2Shapes.
			var body1:b2Body = contact.GetFixtureA().GetBody();
			var body2:b2Body = contact.GetFixtureB().GetBody();
			//trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				
			if(body1.GetUserData()){
				//trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				body1.GetUserData().setImpactPoint(contact, body2);
				//body1.GetUserData().hurt(0);
			}
			
			if(body2.GetUserData()){
				//trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				body2.GetUserData().setImpactPoint(contact, body1);
				//body2.GetUserData().hurt(0);
			}
			
			//save contact point... use this info to determine hitwall, hitfloor, hitceiling...
			//the contact point can be used in bullet to create grav object
		}
	
		/// Called when a contact point persists. This includes the geometry
		/// and the forces.
		//override public function Persist(point:b2ContactPoint) : void{
			//point.shape1.GetUserData().hurt(0);
			//point.shape2.GetUserData().hurt(0);
			//var body1:b2Body = point.shape1.GetBody();
			//var body2:b2Body = point.shape2.GetBody();
			//trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
			//trace("normal: " + point.normal.x + ", " + point.normal.y);
			//point.separation;
			
			//This isn't right yet as it will allow the player to continually jump because the contact keeps refreshing
			/*
			var body1:b2Body = point.shape1.GetBody();
			var body2:b2Body = point.shape2.GetBody();
			//trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				
			if(body1.GetUserData()){
				trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				body1.GetUserData().setImpactPoint(point);
				body1.GetUserData().hurt(0);
			}
			
			if(body2.GetUserData()){
				trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				body2.GetUserData().setImpactPoint(point);
				body2.GetUserData().hurt(0);
			}
			*/
			
		//}
	
		/// Called when a contact point is removed. This includes the last
		/// computed geometry and forces.
		override public function EndContact(contact:b2Contact) : void{
			
			super.EndContact(contact);
			/*
			//point.shape1.GetUserData().hurt(0);
			//point.shape2.GetUserData().hurt(0);
			var body1:b2Body = point.shape1.GetBody();
			var body2:b2Body = point.shape2.GetBody();
			//trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				
			if(body1.GetUserData()){
				trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				body1.GetUserData().removeImpactPoint(point);
				//body1.GetUserData().hurt(0);
			}
			
			if(body2.GetUserData()){
				trace("Body1: "+ body1.GetUserData().name + " Body2: " + body2.GetUserData().name);
				body2.GetUserData().removeImpactPoint(point);
				//body2.GetUserData().hurt(0);
			}
			*/
		}
		
		/// Called after a contact point is solved.
		//override public function Result(point:b2ContactResult) : void{
		
		//}
			
	}
}