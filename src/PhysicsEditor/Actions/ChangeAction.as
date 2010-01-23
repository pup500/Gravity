package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	public class ChangeAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/change.png")] private var img:Class;
		
		public function ChangeAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		override public function onHandleEnd():void{
			
		}

	}
}