package PhysicsEditor.Panels
{
	import PhysicsEditor.IAction;
	import PhysicsEditor.Actions.*;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	
	public class ActionPanel extends PanelBase
	{
		private var ACTIONS:Array = 
			[AddAction, RemoveAction, ChangeAction, JoinAction, BreakAction, 
			EventAction, LinkAction, SensorAction, RunAction, SaveAction, HelpAction];
		
		public function ActionPanel(x:uint=0, y:uint=0, horizontal:Boolean=false)
		{
			super(x,y);
			addItems(ACTIONS, horizontal);
		}
		
		//Maybe we should just have every action know what panel it is on...
		//Then it can call the panel's function to deactive group or item...
		override protected function createItem(aClass:Class):IAction{
			return new aClass(deactivateAllActions);
		}
		
		protected function deactivateAllActions():void{
			for each(var action:IAction in actions){
				action.activate(false);
			}
		}
	}
}