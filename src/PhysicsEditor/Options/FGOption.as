package PhysicsEditor.Options
{
	public class FGOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/fg.png")] private var img:Class;
				
		public function FGOption()
		{
			super(img);
			active = true;
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			state.fg.visible = active;
		}
	}
}