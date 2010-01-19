package PhysicsEditor.Actions
{
	public class SensorAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add.png")] private var img:Class;
		
		public function SensorAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
	}
}