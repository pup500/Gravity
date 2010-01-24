package PhysicsEditor.Options
{
	import PhysicsEditor.IPanel;
	
	import flash.events.MouseEvent;
	
	public class SnapOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/snap.jpg")] private var img:Class;
				
		public function SnapOption(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		//Maybe we should update things during the click....
		override public function update():void{
			super.update();
			
			state.getArgs()["snap"] = active;
		}

	}
}