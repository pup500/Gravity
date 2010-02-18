package PhysicsEditor.Panels
{
	import PhysicsEditor.Actions.*;
	import PhysicsEditor.IAction;
	
	public class ControlPanel extends PanelBase
	{
		private var ACTIONS:Array = 
			[SaveAction, HelpAction, RunAction];
		
		public function ControlPanel(x:uint=0, y:uint=0, horizontal:Boolean=false)
		{
			super(x,y);
			addItems(ACTIONS, horizontal);
		}
		
		override protected function createItem(aClass:Class, active:Boolean):IAction{
			return new aClass(this, active);
		}
	}
}