package PhysicsEditor.Types
{
	import PhysicsEditor.Actions.ActionBase;

	//TypeBase is a base class for radio button style objects
	public class TypeBase extends ActionBase
	{
		public function TypeBase(Graphic:Class, preClick:Function)
		{
			super(Graphic, preClick, null);
		}
		
		override public function handleBegin():void{	
		}
		
		override public function handleDrag():void{
		}
		
		override public function handleEnd():void{
		}
		
	}
}