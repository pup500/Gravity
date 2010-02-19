package PhysicsEditor.Fields
{
	import Box2D.Dynamics.b2Body;
	
	public class DensityField extends FieldBase
	{
		public function DensityField()
		{
			super("Density", "1");
			state.getArgs()["density"] = 1;
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["density"]);				
			else
				state.getArgs()["density"] = Number(getValue());
		}
	}
}