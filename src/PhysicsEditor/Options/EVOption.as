package PhysicsEditor.Options
{
	public class EVOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/ev.png")] private var img:Class;
				
		public function EVOption()
		{
			super(img);
			active = true;
		}

	}
}