package PhysicsEditor.Actions
{
	public class SensorAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add_sensor.png")] private var img:Class;
		
		public function SensorAction(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}