package PhysicsEditor.Actions
{
	public class EventAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/pig-icon.png")] private var img:Class;
		
		public function EventAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
	}
}