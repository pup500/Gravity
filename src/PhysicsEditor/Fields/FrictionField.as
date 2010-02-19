package PhysicsEditor.Fields
{
	public class FrictionField extends FieldBase
	{
		public function FrictionField()
		{
			super("Friction", "0.3");
			state.getArgs()["friction"] = 0.3;
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["friction"]);
			else
				state.getArgs()["friction"] = Number(getValue());
		}
		
	}
}