package common.joints
{
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.b2World;
	
	public class DistanceJoint extends Joint
	{
		public function DistanceJoint(world:b2World, xml:XML)
		{
			super(world, xml);
		}
		
		override public function SetJointDef():void{
			joint = new b2DistanceJointDef();
			
			var distJoint:b2DistanceJointDef = joint as b2DistanceJointDef;
			
			if(body2){
				if(body1 == null || body1 == body2){
					//If body1 isn't found, use world ground body
					body1 = world.GetGroundBody();
				}
				
				distJoint.Initialize(body1, body2, point1, point2);
				distJoint.collideConnected = true;
				valid = true;
			}
			else{
				valid = false;
			}
		}
	}
}