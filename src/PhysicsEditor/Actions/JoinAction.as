package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import PhysicsGame.Wrappers.WorldWrapper;
	
	import common.JointFactory;
	
	import flash.display.Shape;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	
	public class JoinAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/connect-icon.png")] private var img:Class;
		
		private var line:Shape;
		
		public function JoinAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
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
			line.graphics.moveTo(args["start_snap"].x + FlxG.scroll.x, args["start_snap"].y + FlxG.scroll.y);
			line.graphics.lineTo(args["drag_snap"].x + FlxG.scroll.x, args["drag_snap"].y + FlxG.scroll.y);
		}

		override public function onHandleEnd():void{
			args["type"] = state.getArgs()["jointType"];
			
			var jointArgs:Dictionary = new Dictionary();
			jointArgs["type"] = args["type"];
			jointArgs["start"] = args["start_snap"];
			jointArgs["end"] = args["end_snap"];
			
			var xml:XML = JointFactory.createJointXML(jointArgs);
			JointFactory.addJoint(xml);
		}

	}
}