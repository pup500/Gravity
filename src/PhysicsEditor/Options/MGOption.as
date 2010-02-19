package PhysicsEditor.Options
{
	import PhysicsEditor.IPanel;
	
	public class MGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/mg.png")] private var img:Class;
				
		public function MGOption(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			this.active = true;
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			state.mg.visible = active;
		}
	}
}