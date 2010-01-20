package PhysicsEditor.Actions
{
	public class JoinAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/connect-icon.png")] private var img:Class;
		
		public function JoinAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}

	}
}