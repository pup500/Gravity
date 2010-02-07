package PhysicsEditor.Actions
{
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	import flash.display.*;
	import Box2D.Common.Math.b2Vec2;
	import PhysicsEditor.IPanel;
	import PhysicsGame.Sensor;
	
	public class SensorAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add_sensor.png")] private var img:Class;
		
		protected var dragBox:Shape;

		public function SensorAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			dragBox = new Shape();
		}
		
		override public function onHandleDrag():void
		{			
			var startPoint:b2Vec2 = args["start"];
			
			if (FlxG.mouse.x != startPoint.x || FlxG.mouse.y != startPoint.y)
			{
				dragBox.graphics.clear();
				dragBox.graphics.beginFill(0x111111, .25);
				dragBox.graphics.drawRect(startPoint.x+FlxG.scroll.x, startPoint.y+FlxG.scroll.y, FlxG.mouse.x - startPoint.x, FlxG.mouse.y - startPoint.y);
				dragBox.graphics.endFill();
				FlxG.buffer.draw(dragBox);
			}
		}
		
		override public function onHandleEnd():void
		{
			dragBox.graphics.clear();
			
			createSensor();
		}
		
		private function createSensor():void 
		{
			var startPoint:b2Vec2 = args["start"];
			var endPoint:b2Vec2 = args["end"];
			var width:int = Math.abs(endPoint.x - startPoint.x);
			var height:int = Math.abs(endPoint.y - startPoint.y);
			
			if(width == 0 || height == 0){
				return;
			}
			
			var boxCenter:b2Vec2 = new b2Vec2();
			
			//We use the center of the box because Sensor is a sprite and a sprite's x,y coordinates are for its center.
			if(endPoint.x > startPoint.x)
				boxCenter.x = startPoint.x+ (width / 2);
			else
				boxCenter.x = endPoint.x +(width / 2);
			
			if(endPoint.y > startPoint.y)
				boxCenter.y = startPoint.y + (height / 2);
			else
				boxCenter.y = endPoint.y + (height / 2);
			
			//Adjust for flixel's camera offset.
			trace("b4 adjust: at sensorAction CreateSensor: " + boxCenter.x + " " + boxCenter.y);
			trace("b4 adjust SCROLL: at sensorAction CreateSensor: " + FlxG.scroll.x + " " + FlxG.scroll.y);
			//boxCenter.x -= FlxG.scroll.x;
			//boxCenter.y -= FlxG.scroll.y;
			trace("at sensorAction CreateSensor: " + boxCenter.x + " " + boxCenter.y);
			//Add the sensor to the state and XML
			var xml:XML = new XML(<sensor/>);
			//xml.file = state.getArgs()["file"];
			xml.@x = boxCenter.x;		 		
			xml.@y = boxCenter.y;
			xml.@width = width;
			xml.@height = height;
			
			var b2:Sensor = new Sensor();
		    b2.initFromXML(xml, state.the_world, state.getController());
		    
		    state.addToLayer(b2, ExState.EV);
		}
	}
}