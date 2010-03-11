package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	
	import PhysicsEditor.IPanel;
	
	import PhysicsGame.EventObject;
	import PhysicsGame.Sensor;
	
	import common.Utilities;
	
	import flash.display.Shape;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	
	public class LinkAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/link.png")] private var img:Class;
		
		private var line:Shape;
		
		public function LinkAction(panel:IPanel, active:Boolean)
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
			line.graphics.moveTo(args["start"].x + FlxG.scroll.x, args["start"].y + FlxG.scroll.y);
			line.graphics.lineTo(args["drag"].x + FlxG.scroll.x, args["drag"].y + FlxG.scroll.y);
		}

		override public function onHandleEnd():void{
			var body1:b2Body = Utilities.GetBodyAtPoint(args["start"], true);
			var body2:b2Body = Utilities.GetBodyAtPoint(args["end"], true);
			
			//TODO:Fix this
			if(body1 && body2){
				if(body1.GetUserData() is Sensor && body2.GetUserData() is EventObject){
					linkSensorToEvent(body1.GetUserData(), body2.GetUserData());
				}
				else if(body1.GetUserData() is EventObject && body2.GetUserData() is Sensor){
					linkSensorToEvent(body2.GetUserData(), body1.GetUserData());	
				}
				else if(body1.GetUserData() is EventObject){
					linkEventToTarget(body1.GetUserData(), body2.GetUserData());
				}
				else{
					linkEventToTarget(body2.GetUserData(), body1.GetUserData());
				}
			}
			else if(body1 && !body2){
				if(body1.GetUserData() && body1.GetUserData() is EventObject){
					linkEventToTarget(body1.GetUserData(), null);
				}
			}
		}
		
		private function linkSensorToEvent(sensor:Sensor, event:EventObject):void{
			sensor.AddEvent(event);
		}
		  
		private function linkEventToTarget(event:EventObject, target:ExSprite):void{
			event.setTarget(target);
			
			var temp:Dictionary = new Dictionary();
			temp["speed"] = state.getArgs()["speed"];
			event.setArgs(temp);
		}
	}
}