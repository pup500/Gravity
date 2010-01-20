package PhysicsEditor.Actions
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class HelpAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/help.png")] private var img:Class;
		[Embed(source="../../data/editor/help.txt", mimeType="application/octet-stream")] public var helpFile:Class;
		
		private var helpText:TextField;
		
		public function HelpAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		private function initHelp():void{
			helpText = new TextField();
			helpText.selectable = false;
			helpText.width = 448;
            helpText.height = 460;
            helpText.x = (640-helpText.width)/2;
			helpText.y = (480-helpText.height)/2;
            helpText.background = true;
            helpText.border = true;
            helpText.text = (new helpFile);
            helpText.visible = false;
            
            state.addChild(helpText);
		}
		
		//Don't run preclick to allow the other modes to continue working...
		override protected function onClick(event:MouseEvent):void{
			//onPreClick();
			active = !active;
			
			//Allows us to add help text later to make it appear in front of everything
			if(!helpText){
				initHelp();
			}
			
			helpText.visible = active;
		}
	}
}