package PhysicsEditor.Options
{
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	public class DebugOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/frog-icon.png")] private var img:Class;
				
		public function DebugOption()
		{
			super(img);
		}
		
		override public function update():void{
			super.update();
			
			var state:ExState = FlxG.state as ExState;
			state.debug_sprite.visible = active;
		}

	}
}