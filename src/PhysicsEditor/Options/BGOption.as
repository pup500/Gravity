package PhysicsEditor.Options
{
	import PhysicsEditor.IPanel;
	
	public class BGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/bg.png")] private var img:Class;
				
		public function BGOption(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			this.active = true;
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			state.bg.visible = active;
		}
	}
}