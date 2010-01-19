package PhysicsEditor.Types
{
	public class KinematicType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/fish-icon.png")] private var img:Class;
		
		public function KinematicType(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}