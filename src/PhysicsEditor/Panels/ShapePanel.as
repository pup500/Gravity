package PhysicsEditor.Panels
{
	import PhysicsEditor.Types.*;
	import PhysicsEditor.IAction;
	
	public class ShapePanel extends PanelBase
	{
		private var TYPES:Array = 
			[PolyShapeType, CircleShapeType, EdgeShapeType];
			
		public function ShapePanel(x:uint=0, y:uint=0, horizontal:Boolean=false)
		{
			super(x, y);
			addItems(TYPES, horizontal);
		}
		
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