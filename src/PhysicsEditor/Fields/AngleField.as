package PhysicsEditor.Fields
{
	public class AngleField extends FieldBase
	{
		public function AngleField()
		{
			super("Angle", "0");
			
			state.getArgs()["angle"] = 0;
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["angle"]);
			else
				state.getArgs()["angle"] = Number(getValue());
		}
	}
}