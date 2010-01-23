package PhysicsEditor.Options
{
	public class SnapOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/snap.jpg")] private var img:Class;
				
		public function SnapOption()
		{
			super(img);
		}
		
		//Maybe we should update things during the click....
		override public function update():void{
			super.update();
			
			state.getArgs()["snap"] = active;
		}

	}
}