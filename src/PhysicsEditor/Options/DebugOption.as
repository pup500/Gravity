package PhysicsEditor.Options
{
	import PhysicsEditor.IPanel;
	
	public class DebugOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/frog-icon.png")] private var img:Class;
				
		public function DebugOption(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			this.active = true;
		}
		
		//Maybe we should update things during the click....
		override public function update():void{
			super.update();
			
			state.debug_sprite.visible = active;
			state.getArgs()["debug"] = active;
		}
	}
}