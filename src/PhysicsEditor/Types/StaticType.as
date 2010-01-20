package PhysicsEditor.Types
{
	public class StaticType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/elephant-icon.png")] private var img:Class;
		
		public function StaticType(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}