package PhysicsEditor.Options
{
	import flash.events.MouseEvent;
	
	public class DebugOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/frog-icon.png")] private var img:Class;
				
		public function DebugOption()
		{
			super(img);
		}
		
		//Maybe we should update things during the click....
		override public function update():void{
			super.update();
			
			state.debug_sprite.visible = active;
			state.getArgs()["debug"] = active;
		}
	}
}