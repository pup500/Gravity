package PhysicsEditor.Options
{
	import flash.events.MouseEvent;
	import org.overrides.ExState;
	
	public class BGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/bg.png")] private var img:Class;
				
		public function BGOption()
		{
			super(img);
			active = true;
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			state.bg.visible = active;
		}
	}
}