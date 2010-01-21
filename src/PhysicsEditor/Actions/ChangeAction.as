package PhysicsEditor.Actions
{
	public class ChangeAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/change.png")] private var img:Class;
		
		public function ChangeAction(preClick:Function)
		{
			super(img, preClick);
		}
		
		override public function onHandleEnd():void{
			
		}

	}
}