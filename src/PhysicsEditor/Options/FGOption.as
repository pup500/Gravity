package PhysicsEditor.Options
{
	import PhysicsEditor.IPanel;
	
	public class FGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/fg.png")] private var img:Class;
				
		public function FGOption(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			this.active = true;
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			state.fg.visible = active;
		}
	}
}