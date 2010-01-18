package PhysicsEditor.Actions
{
	public class AddAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add.png")] private var img:Class;
		
		public function AddAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		override public function handleEnd():void{
			if(!active) return;
			
			//Change args here and it will be passed back to the postRelease function
			args["mode"] = "add";
			
			super.handleEnd();
		}

	}
}