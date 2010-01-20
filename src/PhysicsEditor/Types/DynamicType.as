package PhysicsEditor.Types
{
	public class DynamicType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/sheep-icon.png")] private var img:Class;
		
		public function DynamicType(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}