package PhysicsEditor.Types
{
	public class PrismaticJointType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/mosu-icon.png")] private var img:Class;
		
		public function PrismaticJointType(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}