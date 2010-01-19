package PhysicsEditor.Actions
{
	public class ChangeAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/change.png")] private var img:Class;
		
		public function ChangeAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		override public function handleEnd():void{
			if(!active) return;
			
			//Change args here and it will be passed back to the postRelease function
			args["mode"] = "change";
			
			super.handleEnd();
		}

	}
}