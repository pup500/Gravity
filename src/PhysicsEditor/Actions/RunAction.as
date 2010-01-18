package PhysicsEditor.Actions
{
	public class RunAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/mammoth-icon.png")] private var img:Class;
		
		public function RunAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
	}
}