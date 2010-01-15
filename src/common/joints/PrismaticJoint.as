package common.joints
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2World;
	

	public class PrismaticJoint extends Joint
	{
		public function PrismaticJoint(world:b2World, xml:XML)
		{
			super(world, xml);
		}
		
		override public function SetJointDef():void{
			joint = new b2PrismaticJointDef();
			
			var prisJoint:b2PrismaticJointDef = joint as b2PrismaticJointDef;
			
			//Always draw from static to nonstatic...
			if(body2){
				//Axis is currently set as the normalized vector from our two points
				var axis:b2Vec2 = new b2Vec2(point2.x, point2.y);
				axis.Subtract(point1);
				
				var anchor:b2Vec2 = new b2Vec2();
				
				if(body1 == null){
					//If body1 isn't found, use world ground body
					body1 = world.GetGroundBody();
					
					//Also the anchor point should be where we placed the joint
					anchor.x = point1.x;
					anchor.y = point1.y;
				}else{
					//There's two bodies, we want the anchor point to be at the midpoint of the line we drew
					anchor.x = (point2.x + point1.x)/2;
					anchor.y = (point2.y + point1.y)/2;
				}
				
				//If we have xml data loaded from the config file, then use that
				if(xml.loaded == "true"){
					axis.x = xml.axis.x;
					axis.y = xml.axis.y;
					
					anchor.x = xml.anchor.x;
					anchor.y = xml.anchor.y;
				}
				
				//Axis should be normalized
				axis.Normalize();
				
				//Initialize some sample values for now...
				prisJoint.Initialize(body1, body2, anchor, axis);
				prisJoint.enableMotor = true;
				prisJoint.enableLimit = true;
				prisJoint.maxMotorForce = 100 * body2.GetMass();
				prisJoint.motorSpeed = 10;
				prisJoint.upperTranslation = 50;
				prisJoint.lowerTranslation = -50;
				prisJoint.collideConnected = true;
				prisJoint.userData = axis;
				valid = true;
			}
			else{
				valid = false;
			}
		}
		
	}
}