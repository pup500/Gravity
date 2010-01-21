package PhysicsEditor.Options
{
	public class MGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/mg.png")] private var img:Class;
				
		public function MGOption()
		{
			super(img);
			active = true;
		}

	}
}