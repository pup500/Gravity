package common
{
	import Box2D.Dynamics.b2World;
	
	import common.joints.*;
	
	import flash.utils.Dictionary;
	
	public class JointFactory
	{
		public static const e_unknownJoint:int = 0;
		public static const e_revoluteJoint:int = 1;
		public static const e_prismaticJoint:int = 2;
		public static const e_distanceJoint:int = 3;
		public static const e_pulleyJoint:int = 4;
		public static const e_mouseJoint:int = 5;
		public static const e_gearJoint:int = 6;
		public static const e_lineJoint:int = 7;
		
		private static var JOINTS:Array = [
			Joint,					//e_unknownJoint
			RevoluteJoint,
			PrismaticJoint,
			DistanceJoint,
			Joint,					//e_pulleyJoint
			Joint,					//e_mouseJoint
			Joint,					//e_gearJoint
			Joint					//e_lineJoint
		];
		
		public function JointFactory()
		{
		}
		
		//Always make sure we have registered two points
		public static function addJoint(jointXML:XML):void{
			//if(jointXML.@type.length() > 0){
				var joint:Joint = new JOINTS[jointXML.@type](jointXML);
				joint.SetJointDef();
				joint.AddJoint();
			//}
		}
		
		public static function createJointXML(args:Dictionary):XML{
			var xml:XML = new XML(<joint/>);
			xml.@type = args["type"];
			xml.body1.@x = args["start"].x;
			xml.body1.@y = args["start"].y;
			xml.body2.@x = args["end"].x;
			xml.body2.@y = args["end"].y;
			xml.@speed = args["speed"];
			xml.loaded = false;
			return xml;
		}
	}
}