package PhysicsEditor.Fields
{
	public class AngleField extends FieldBase
	{
		public function AngleField()
		{
			super("Angle", "0");
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				state.getArgs()["angle"] = getValue();
			else
				setValue(state.getArgs()["angle"]);
		}
	}
}