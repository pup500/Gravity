package PhysicsEditor.Actions
{
	public class LinkAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/connect-icon.png")] private var img:Class;
		
		public function LinkAction(preClick:Function)
		{
			super(img, preClick);
		}

	}
}