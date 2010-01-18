package PhysicsEditor.Panels
{
	import PhysicsEditor.Actions.*;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	
	public class ActionPanel extends PanelBase
	{
		private var ACTIONS:Array = 
			[AddAction, RemoveAction, JoinAction, BreakAction, LinkAction];
		
		public function ActionPanel(x:uint=0, y:uint=0)
		{
			super(x,y);
			this.addItems(ACTIONS, true);
		}
		
		override protected function createItem(aClass:Class):IAction{
			return new aClass(deactivateAllActions, onRelease);
		}
		
		private function deactivateAllActions():void{
			for each(var action:IAction in actions){
				action.deactivate();
			}
		}
		
		private function onRelease(args:Dictionary):void{
			trace(args["mode"]);
			trace(args["start"].x + "," + args["start"].y);
			
			//var pointA:b2Vec2 = args["start"];
			//var pointB:b2Vec2 = args["end"];
			
			//On release we get a dictionary of start and end parameters...
			//And what function was set...
			
		}
	}
}