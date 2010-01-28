package PhysicsEditor.Fields
{
	public class BounceField extends FieldBase
	{
		public function BounceField()
		{
			super("Bounce", "0");
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				state.getArgs()["restitution"] = Number(getValue());
			else
				setValue(state.getArgs()["restitution"]);
		}
	}
}