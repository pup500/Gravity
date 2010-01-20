package PhysicsEditor.Options
{
	public class BGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/bg.png")] private var img:Class;
				
		public function BGOption()
		{
			super(img);
		}

	}
}