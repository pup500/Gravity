package PhysicsEditor.Types
{
	public class RevoluteJointType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/sheep-icon.png")] private var img:Class;
		
		public function RevoluteJointType(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}