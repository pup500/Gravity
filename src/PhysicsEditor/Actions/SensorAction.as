package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	public class SensorAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add_sensor.png")] private var img:Class;
		
		public function SensorAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
	}
}