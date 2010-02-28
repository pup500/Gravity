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
		
		//Override onClick to not deactivate other actions in the panel...
		override protected function onClick(event:MouseEvent):void{
			var xml:XML = Utilities.CreateXMLRepresentation(state.worldWrapper.the_world);
			var points:XML = new XML(<points/>);
			
			if(state.getArgs()["startPoint"]){
				points.start.@x = state.getArgs()["startPoint"].x;
				points.start.@y = state.getArgs()["startPoint"].y;
			}
			else{
				points.start.@x = 0;
				points.start.@y = 0;
			}
			
			if(state.getArgs()["endPoint"]){
				points.end.@x = state.getArgs()["endPoint"].x;
				points.end.@y = state.getArgs()["endPoint"].y;
			}
			else{
				points.end.@x = 0;
				points.end.@y = 0;
			}
			
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