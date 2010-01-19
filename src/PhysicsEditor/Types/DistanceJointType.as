package PhysicsEditor.Types
{
	public class DistanceJointType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/sheep-icon.png")] private var img:Class;
		
		public function DistanceJointType(preClick:Function)
		{
			super(img, preClick);
		}
		
	}
}