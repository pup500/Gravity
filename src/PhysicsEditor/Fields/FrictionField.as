package PhysicsEditor.Fields
{
	public class FrictionField extends FieldBase
	{
		public function FrictionField()
		{
			super("Friction", "0.3");
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				state.getArgs()["friction"] = Number(getValue());
			else
				setValue(state.getArgs()["friction"]);
		}
		
	}
}