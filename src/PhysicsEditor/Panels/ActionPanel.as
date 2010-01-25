package PhysicsEditor.Panels
{
	import PhysicsEditor.Actions.*;
	import PhysicsEditor.IAction;
	
	public class ActionPanel extends PanelBase
	{
		private var ACTIONS:Array = 
			[AddAction, RemoveAction, ChangeAction, JoinAction, BreakAction, 
			EventAction, LinkAction, SensorAction, SelectAction, StartAction, EndAction];
		
		public function ActionPanel(x:uint=0, y:uint=0, horizontal:Boolean=false)
		{
			super(x,y);
			addItems(ACTIONS, horizontal);
		}
		
		override protected function createItem(aClass:Class, active:Boolean):IAction{
			return new aClass(this, active);
		}
	}
}