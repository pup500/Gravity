package PhysicsEditor.Fields
{
	public class AngleField extends FieldBase
	{
		public function AngleField()
		{
			super("Angle", "0");
		}
		
		override public function update():void{
			state.getArgs()["angle"] = int(textField.text);
		}
	}
}