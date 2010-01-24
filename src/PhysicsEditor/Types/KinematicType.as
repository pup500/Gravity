package PhysicsEditor.Types
{
	import Box2D.Dynamics.b2Body;
	
	import PhysicsEditor.IPanel;
	
	public class KinematicType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/fish-icon.png")] private var img:Class;
		
		public function KinematicType(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			
			if(active){
				state.getArgs()["bodyType"] = b2Body.b2_kinematicBody;
			}
		}
	}
}