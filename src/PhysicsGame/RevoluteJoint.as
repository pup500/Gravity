package PhysicsGame
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	import org.overrides.ExSprite;
	
	public class RevoluteJoint extends ExSprite
	{
		private var the_box:b2PolygonDef;
		private var the_pivot:b2CircleDef;
		private var the_rev_joint:b2RevoluteJointDef;
		
		public function RevoluteJoint()
		{
			super();
			
			var the_box:b2PolygonDef = new b2PolygonDef();
			var the_pivot:b2CircleDef = new b2CircleDef();
			var the_rev_joint:b2RevoluteJointDef = new b2RevoluteJointDef();
			
			the_pivot.radius = 0.5;
			the_pivot.density = 0;
			bd = new b2BodyDef();
			bd.position.Set(8.5,6.5);
			var rev_joint:b2Body = the_world.CreateBody(bd);
			rev_joint.CreateShape(the_pivot)
			rev_joint.SetMassFromShapes();
			// box for the revolute joint
			the_box.SetAsBox(4,0.5);
			the_box.density = 0.01;
			the_box.friction = 1;
			the_box.restitution = 0.1;
			bd = new b2BodyDef();
			bd.position.Set(6.5,6.5);
			var rev_box:b2Body = the_world.CreateBody(bd);
			rev_box.CreateShape(the_box)
			rev_box.SetMassFromShapes();
			the_rev_joint.Initialize(rev_joint, rev_box, new b2Vec2(8.5,6.5));
			var joint_added:b2RevoluteJoint = the_world.CreateJoint(the_rev_joint) as b2RevoluteJoint;

		
		}

	}
}