package PhysicsEditor.Types
{
	import PhysicsEditor.Actions.ActionBase;
	import PhysicsEditor.IPanel;

	//TypeBase is a base class for radio button style objects
	public class TypeBase extends ActionBase
	{
		public function TypeBase(Graphic:Class, panel:IPanel, active:Boolean)
		{
			super(Graphic, panel, active);
		}
		
		override public function handleBegin():void{	
		}
		
		override public function handleDrag():void{
		}
		
		override public function handleEnd():void{
		}
		
	}
}