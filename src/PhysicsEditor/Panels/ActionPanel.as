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
			return new aClass(deactivateAllActions, onRelease);
		}
		
		protected function deactivateAllActions():void{
			for each(var action:IAction in actions){
				action.activate(false);
			}
		}
		
		private function onRelease(args:Dictionary):void{
			//Ok, sometimes, mouse begin does not register so the end calls and args start isn't valid...
			
			trace(args["mode"]);
			trace(args["start"].x + "," + args["start"].y);
			
			//var pointA:b2Vec2 = args["start"];
			//var pointB:b2Vec2 = args["end"];
			
			//On release we get a dictionary of start and end parameters...
			//And what function was set...
			
		}
	}
}