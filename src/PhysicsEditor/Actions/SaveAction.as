package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import common.Utilities;
	
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import org.flixel.FlxG;
	
	public class SaveAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/save.png")] private var img:Class;
		[Embed(source="../../data/editor/interface/dino.mp3")] private var snd:Class;
		
		public function SaveAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		//Don't run preclick to allow the other modes to continue working...
		override protected function onClick(event:MouseEvent):void{
			var xml:XML = Utilities.CreateXMLRepresentation(state.the_world);
			var points:XML = new XML(<points/>);
			points.start.x = state.getArgs()["startPoint"].x;
			points.start.y = state.getArgs()["startPoint"].y;
			points.end.x = state.getArgs()["endPoint"].x;
			points.end.y = state.getArgs()["endPoint"].y;
			
			//Create the config file as below
			xml.appendChild(points);
			
			//Use xmlmap and not utilities so that we get start and end points...
			copy(xml);
			FlxG.play(snd);
		}
		
		private function copy(text:String):void{
            System.setClipboard(text);
        }
		
		//Override to prevent transparency change
		override public function update():void{
			
		}
		
	}
}