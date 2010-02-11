package PhysicsEditor.Fields
{
	public class SpeedField extends FieldBase
	{
		public function SpeedField()
		{
			super("Speed", "0");
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["speed"]);
			else
				state.getArgs()["speed"] = Number(getValue());
		}
	}
}