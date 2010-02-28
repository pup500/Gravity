package common.joints
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.b2Body;
	
	import PhysicsGame.Wrappers.WorldWrapper;
	
	import common.Utilities;
	
	import org.overrides.ExState;
	
	public class Joint
	{
		protected var valid:Boolean;
		protected var body1:b2Body;
		protected var body2:b2Body;
		protected var point1:b2Vec2;
		protected var point2:b2Vec2;
		protected var xml:XML;
		protected var joint:b2JointDef;
		
		public function Joint(xml:XML)
		{
			this.xml = xml;
			
			point1 = new b2Vec2(xml.body1.@x, xml.body1.@y);
			point2 = new b2Vec2(xml.body2.@x, xml.body2.@y);
			
			//trace("point before:" + point1.x + "," + point1.y);
			
			body1 = Utilities.GetBodyAtPoint(point1, true);
			body2 = Utilities.GetBodyAtPoint(point2, true);
			
			point1.Multiply(1/ExState.PHYS_SCALE);
			point2.Multiply(1/ExState.PHYS_SCALE);
			
			//trace("point after:" + point1.x + "," + point1.y);
		}
		
		public virtual function SetJointDef():void{
			
		}
		
		public virtual function GetJointDef():b2JointDef{
			return joint;
		}
		
		public virtual function AddJoint():void{
			if(valid){
				WorldWrapper.createJoint(joint);
			}
		}
	}
}