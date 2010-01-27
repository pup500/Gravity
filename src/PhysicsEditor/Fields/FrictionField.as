package PhysicsEditor.Fields
{
	public class FrictionField extends FieldBase
	{
		public function FrictionField()
		{
			super("Friction", "0.3");
		}
		
		override public function update():void{
			state.getArgs()["friction"] = getValue();
		}
		
	}
}