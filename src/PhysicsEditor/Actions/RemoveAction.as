package PhysicsEditor.Actions
{
	public class RemoveAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/delete.png")] private var img:Class;
		
		public function RemoveAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}

	}
}