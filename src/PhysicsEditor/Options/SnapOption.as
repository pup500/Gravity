package PhysicsEditor.Options
{
	public class SnapOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/snap.jpg")] private var img:Class;
				
		public function SnapOption()
		{
			super(img);
		}

	}
}