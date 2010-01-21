package PhysicsEditor.Actions
{
	import common.JointFactory;
	
	import flash.display.Shape;
	
	import org.flixel.FlxG;
	
	public class JoinAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/connect-icon.png")] private var img:Class;
		
		private var line:Shape;
		
		public function JoinAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
			line = new Shape();
			state.addChild(line);
		}
		
		override public function update():void{
			super.update();
			line.visible = beginDrag;
			line.x += FlxG.scroll.x;
			line.y += FlxG.scroll.y;
		}
		
		override public function handleDrag():void{
			if(!beginDrag) return;
			
			line.graphics.clear();
			line.graphics.lineStyle(1,0xFF0000,1);
			line.graphics.moveTo(args["start"].x, args["start"].y);
			line.graphics.lineTo(FlxG.mouse.x, FlxG.mouse.y);//point.x, point.y);
		}

		override public function handleEnd():void{
			if(!active) return;
			
			//TODOLBOOOO I hate doing this... will make all of these callbacks 
			super.handleEnd();
			
			args["type"] = 1;
			
			var xml:XML = JointFactory.createJointXML(args);
			JointFactory.addJoint(state.the_world, xml);
		}

	}
}