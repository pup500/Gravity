package PhysicsGame 
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Controllers.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class GravityObjectController extends b2Controller
	{
		public var _gravObjects:Array;
		
		public override function Step(step:b2TimeStep):void 
		{
			var edge:b2ControllerEdge = null;
			var force:b2Vec2;
			
			//Apply force to every physics body in this controller.
			for (var i:uint = 0; i < _gravObjects.length; i++)
			{
				if(!_gravObjects[i].exists || _gravObjects[i].dead) continue;
				for (edge = m_bodyList; edge; edge = edge.nextBody)
				{
					if(edge.body.GetType() != b2Body.b2_dynamicBody)
						continue;
					
					//Get force from each gravity object.
					force = _gravObjects[i].GetGravityB2(edge.body);
					
					//trace(edge.body.GetUserData().name + " force: " + force.x + "," + force.y);
					edge.body.ApplyForce(force,edge.body.GetWorldCenter());
				}
			}
		}
	}

}