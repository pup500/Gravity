package PhysicsEditor.Panels
{
	import PhysicsEditor.IAction;
	import PhysicsEditor.Types.*;
	
	public class TypePanel extends PanelBase
	{
		private var TYPES:Array = 
			[StaticType, KinematicType, DynamicType];
			
		public function TypePanel(x:uint=0, y:uint=0, horizontal:Boolean=false)
		{
			super(x, y);
			addItems(TYPES, horizontal);
		}
		
		override protected function createItem(aClass:Class, active:Boolean):IAction{
			return new aClass(this, active);
		}
	}
}