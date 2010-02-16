package PhysicsEditor.Fields
{
	public class NameField extends FieldBase
	{
		public function NameField()
		{
			super("Name", "");
			textField.restrict = "a-z0-9-.";
			
			state.getArgs()["name"] = "";
		}
		
		override public function update():void{
			super.update();
			
			if(lock)
				setValue(state.getArgs()["name"]);
			else
				state.getArgs()["name"] = getValue();
		}
	}
}