package PhysicsEditor.Fields
{
	public class BounceField extends FieldBase
	{
		public function BounceField()
		{
			super("Bounce", "0");
			
			state.getArgs()["restitution"] = 0;
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["restitution"]);
			else
				state.getArgs()["restitution"] = Number(getValue());
				
		}
	}
}