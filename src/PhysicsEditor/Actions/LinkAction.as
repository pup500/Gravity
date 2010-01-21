package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	
	import PhysicsGame.EventObject;
	
	import common.Utilities;
	
	import flash.display.Shape;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	
	public class LinkAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/connect-icon.png")] private var img:Class;
		
		private var line:Shape;
		
		public function LinkAction(preClick:Function)
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
			var body1:b2Body = Utilities.GetBodyAtPoint(state.the_world, args["start"], true);
			var body2:b2Body = Utilities.GetBodyAtPoint(state.the_world, args["end"], true);
			
			if(body1){
				if(body1.GetUserData() && body1.GetUserData() is EventObject){
					//This only happens if we select an event and link it to the target
					var event:EventObject = body1.GetUserData() as EventObject;
					if(body2 && body2.GetUserData() && body2.GetUserData() is ExSprite){
						var target:ExSprite = body2.GetUserData() as ExSprite;
						event.setTarget(target);
					}
					else{
						event.setTarget(null);
					}
				}
			}
		}
	}
}