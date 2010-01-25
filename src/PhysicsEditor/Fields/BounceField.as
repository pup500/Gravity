package PhysicsEditor.Fields
{
	public class BounceField extends FieldBase
	{
		public function BounceField()
		{
			super("Bounce", "0");
		}
		
		override public function update():void{
			state.getArgs()["restitution"] = int(textField.text);
		}
	}
}