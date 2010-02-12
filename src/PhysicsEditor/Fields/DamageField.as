package PhysicsEditor.Fields
{
	public class DamageField extends FieldBase
	{
		public function DamageField()
		{
			super("Damage", "0");
			
			state.getArgs()["damage"] = 0;
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["damage"]);
			else
				state.getArgs()["damage"] = Number(getValue());
		}
	}
}