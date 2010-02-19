package PhysicsEditor.Options
{
	import PhysicsEditor.IPanel;
	
	public class EVOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/ev.png")] private var img:Class;
				
		public function EVOption(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			this.active = true;
		}

		//See if we should move this into onClick
		override public function update():void{
			super.update();
			state.ev.visible = active;
		}
	}
}