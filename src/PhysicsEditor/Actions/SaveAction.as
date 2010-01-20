package PhysicsEditor.Actions
{
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import org.flixel.FlxG;
	import common.Utilities;
	
	public class SaveAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/save.png")] private var img:Class;
		[Embed(source="../../data/editor/interface/dino.mp3")] private var snd:Class;
		
		public function SaveAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		//Don't run preclick to allow the other modes to continue working...
		override protected function onClick(event:MouseEvent):void{
			//onPreClick();
			//active = !active;
			
			//Use xmlmap and not utilities so that we get start and end points...
			copy(Utilities.CreateXMLRepresentation(state.the_world));
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