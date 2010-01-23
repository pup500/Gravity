package PhysicsEditor.Types
{
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.Joints.b2Joint;
	
	import PhysicsEditor.IPanel;
	use namespace b2internal;
	
	public class DistanceJointType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/gas-soldier-icon.png")] private var img:Class;
		
		public function DistanceJointType(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			
			if(active){
				state.getArgs()["jointType"] = b2Joint.e_distanceJoint;
			}
		}
	}
}