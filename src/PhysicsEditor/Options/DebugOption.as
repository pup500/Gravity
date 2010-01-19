package PhysicsEditor.Options
{
	public class DebugOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/frog-icon.png")] private var img:Class;
				
		public function DebugOption()
		{
			super(img);
		}

	}
}