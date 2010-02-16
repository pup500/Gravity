package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class HelpAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/help.png")] private var img:Class;
		[Embed(source="../../data/editor/help.txt", mimeType="application/octet-stream")] public var helpFile:Class;
		
		private var helpText:TextField;
		
		public function HelpAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
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
		
		//Override onClick to not deactivate other actions in the panel...
		override protected function onClick(event:MouseEvent):void{
			active = !active;
			
			//Allows us to add help text later to make it appear in front of everything
			if(!helpText){
				initHelp();
			}
			
			helpText.visible = active;
		}
	}
}