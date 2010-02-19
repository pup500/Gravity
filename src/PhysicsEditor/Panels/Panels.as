package PhysicsEditor.Panels
{
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	public class Panels
	{
		protected var panels:Array;
		
		public function Panels(state:ExState)
		{
			//This is how you create new panels
			panels = [
				new ActionPanel(5, 5), 
				new OptionPanel(5+46, 5),
				new TypePanel(5+46*2, 5),
				new ShapePanel(5+46*3, 5),
				new JointPanel(5+46*4, 5),
				new ControlPanel(594, 5)
			];
			
			for each(var panel:PanelBase in panels){
				state.addChild(panel.getSprite());
			}
		}
		
		public function update():void{
			for each(var panel:PanelBase in panels){
				panel.update();
			}
		}
	}
}