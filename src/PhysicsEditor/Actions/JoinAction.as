package PhysicsEditor.Actions
{
	import common.JointFactory;
	
	import flash.display.Shape;
	
	import org.flixel.FlxG;
	
	public class JoinAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/connect-icon.png")] private var img:Class;
		
		private var line:Shape;
		
		public function JoinAction(preClick:Function)
		{
			super(img, preClick);
			line = new Shape();
			state.addChild(line);
		}
		
		override public function update():void{
			super.update();
			line.visible = beginDrag;
		}
		
		override public function onHandleDrag():void{
			line.graphics.clear();
			line.graphics.lineStyle(1,0xFF0000,1);
			line.graphics.moveTo(args["start"].x + FlxG.scroll.x, args["start"].y + FlxG.scroll.y);
			line.graphics.lineTo(FlxG.mouse.x + FlxG.scroll.x, FlxG.mouse.y + FlxG.scroll.y);
		}

		override public function onHandleEnd():void{
			args["type"] = 1;
			
			var xml:XML = JointFactory.createJointXML(args);
			JointFactory.addJoint(state.the_world, xml);
		}

	}
}