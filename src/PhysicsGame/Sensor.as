package PhysicsGame 
{
	import org.overrides.ExSprite;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Sensor extends ExSprite
	{
		[Embed(source = "../data/button.mp3")] private var SndTick:Class;
		
		protected var _events:Array;
		protected var _triggered:Boolean;
		//@desc Name of object that will trigger this sensor on collision.
		public var Trigger:String;
		
		public function Sensor(X:int=0, Y:int=0, Width:int=10, Height:int=10, triggerName:String="Player") 
		{
			super(X, Y);
			name = "Sensor";
			super.width = Width;
			super.height = Height;
			Trigger = triggerName;
			_triggered = false;
			//So only player collides with sensors. Without the if statements in SetImpactPoint() it'll still collide with world object that aren't assigned a category..
			fixtureDef.filter.maskBits = 0x0001;
			fixtureDef.isSensor = true;
			
			initShape();
			
			_events = new Array();
		}
		
		/*
		override public function initShape():void
		{
			var polyDef:b2PolygonDef = new b2PolygonDef();
			polyDef.SetAsBox(width / 2, height / 2);
			super.shape = polyDef;
		}
		*/
		
		public function AddEvent(event:IEvent):void
		{
			_events.push(event);
		}
		
		override public function createPhysBody(world:b2World):void
		{
			super.createPhysBody(world);
			//final_body.SetStatic();
		}
		
		override public function update():void
		{
			super.update();
			
			if (_triggered)
			{
				playEvents();
			}
		}
		
		protected function playEvents():void
		{
			//trace("Sensed by sensor.as");
			for each(var event:IEvent in _events)
			{
				event.startEvent();
			}
			_triggered = false;
		}
		
		//TODO: Can we use shape.filter to make collisions happen exclusively with the Player? If I eliminate these if statements, world objects will collide with the end level sensor.
		/*
		override public function setImpactPoint(point:b2ContactPoint):void{
			super.setImpactPoint(point);
			
			if(point.shape1.GetBody().GetUserData() && point.shape1.GetBody().GetUserData().name == Trigger){
				_triggered = true;
			}
			else if(point.shape2.GetBody().GetUserData() && point.shape2.GetBody().GetUserData().name == Trigger){
				_triggered = true;
			}
		}
		*/
	}
}