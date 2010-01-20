package PhysicsEditor.Actions
{
	public class BreakAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/disconnect-icon.png")] private var img:Class;
		
		public function BreakAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}

	}
}