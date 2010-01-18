package PhysicsGame 
{
	import Box2D.Common.Math.*;
	import Box2D.Common.*;
	import Box2D.Collision.Shapes.*;
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
			var gObj:GravityObject;
			var force:b2Vec2;
			
			//Apply force to every physics body in this controller.
			for (edge = m_bodyList; edge; edge = edge.nextBody)
			{
				//Get force from each gravity object.
				for (var i:uint = 0; i < _gravObjects.length; i++)
				{
					gObj = _gravObjects[i] as GravityObject;
					if(!gObj.exists || gObj.dead) continue;
					
					force = gObj.GetGravityForce(edge.body);
					
					edge.body.ApplyForce(force,edge.body.GetWorldCenter());
				}
			}
		}
	}

}