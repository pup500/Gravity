package PhysicsEditor.Fields
{
	public class FrictionField extends FieldBase
	{
		public function FrictionField()
		{
			super("Friction", "0");
		}
		
		override public function update():void{
			state.getArgs()["friction"] = int(textField.text);
		}
		
	}
}