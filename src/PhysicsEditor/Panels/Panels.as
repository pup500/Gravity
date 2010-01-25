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
				new ActionPanel(5,5), 
				new OptionPanel(590, 5),
				new TypePanel(55, 5, true),
				new ShapePanel(190, 5, true),
				new JointPanel(325, 5, true),
				new ControlPanel(55, 325)
			];
			
			for each(var panel:PanelBase in panels){
				state.addChild(panel.getSprite());
			}
		}
		
		public function update():void{
			for each(var panel:PanelBase in panels){
				//Toggle visibility of control panels when SHIFT key is held
				panel.getSprite().visible = !FlxG.keys.SHIFT;
				panel.update();
			}
		}
	}
}