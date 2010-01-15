package common.joints
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2World;

	public class RevoluteJoint extends Joint
	{	
		public function RevoluteJoint(world:b2World, xml:XML)
		{
			super(world, xml);
			
		}
		
		override public function SetJointDef():void{
			joint = new b2RevoluteJointDef();
			
			var revJoint:b2RevoluteJointDef = joint as b2RevoluteJointDef;
			
			if(body2){
				if(body1 == null || body1 === body2){
					body1 = world.GetGroundBody();
				}
				
				var anchor:b2Vec2 = new b2Vec2();
				anchor.x = point1.x;
				anchor.y = point1.y;
				
				//Should we use body2 center?  This happens when we press and release inside one object
				if(body1 === body2){
					anchor.x = body2.GetWorldCenter().x;
					anchor.y = body2.GetWorldCenter().y;
				}
				
				//If we have xml data, use that
				if(xml.loaded == "true"){
					anchor.x = xml.anchor.x;
					anchor.y = xml.anchor.y;
				}
				
				//Compute distance of the center point to the center of our main object
				var dist:b2Vec2 = new b2Vec2();
				dist.x = body2.GetWorldCenter().x;
				dist.y = body2.GetWorldCenter().x;
				dist.Subtract(anchor);
				
				var distance:Number = dist.Length();
				
				revJoint.Initialize(body1, body2, anchor);
				//joint.lowerAngle = 3.14/2; // -90 degrees
				//joint.upperAngle = 0.25 * 3.14; // 45 degrees
				//joint.enableLimit = true;
				
				//The mass and distance has to be in so that longer distances will still work...
				revJoint.maxMotorTorque = 100.0 * body2.GetMass() * distance;
				revJoint.motorSpeed = 100;
				revJoint.enableMotor = true;
				valid = true;
			}
			else{
				valid = false;
			}
		}
		
	}
}