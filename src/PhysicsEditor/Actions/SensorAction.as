package PhysicsEditor.Actions
{
	import org.flixel.FlxG;
	import flash.display.*;
	import Box2D.Common.Math.b2Vec2;
	
	public class SensorAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add_sensor.png")] private var img:Class;
		
		protected var dragBox:Shape;

		public function SensorAction(preClick:Function)
		{
			super(img, preClick);
		}
		
		override public function handleBegin():void
		{
			super.handleBegin();
		}
		
		override public function handleDrag():void
		{
			if (!active) return;
			
			var startPoint:b2Vec2 = args["start"];
			
			if (FlxG.mouse.x != startPoint.x || FlxG.mouse.y != startPoint.y)
			{
				dragBox.graphics.clear();
				dragBox.graphics.beginFill(0x111111, .25);
				dragBox.graphics.drawRect(startPoint.x, startPoint.y, FlxG.mouse.x - startPoint.x, FlxG.mouse.y - startPoint.y);
				dragBox.graphics.endFill();
				FlxG.buffer.draw(dragBox);
			}
		}
		
		override public function handleEnd():void
		{
			if(!active) return;
			
			beginDrag = false;
			args["end"] = new b2Vec2(FlxG.mouse.x, FlxG.mouse.y);
			//onPostRelease(args);
			
			dragBox.graphics.clear();
			
			createSensor();
		}
		
		private function createSensor():void 
		{
			var startPoint:b2Vec2 = args["start"];
			var endPoint:b2Vec2 = args["end"];
			var width:int = endPoint.x - startPoint.x;
			var height:int = endPoint.y - startPoint.y;
			//We use the center of the box because Sensor is a sprite and a sprite's x,y coordinates are for its center.
			var boxCenterX:int = startPoint.x + width / 2;
			var boxCenterY:int = startPoint.y + height / 2;
			
			//TODO: what if the end point is less than the start point?

			//Add the sensor to the state and XML
		}
	}
}