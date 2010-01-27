package PhysicsEditor.Fields
{
	import Box2D.Dynamics.b2Body;
	
	public class DensityField extends FieldBase
	{
		public function DensityField()
		{
			super("Density", "1");
		}
		
		override public function update():void{
			textField.visible = state.getArgs()["bodyType"] == b2Body.b2_dynamicBody;
			
			state.getArgs()["density"] = getValue();
		}
	}
}