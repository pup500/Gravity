package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import org.overrides.ExSprite;
	
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
		
		public function Sensor(x:int=0, y:int=0, triggerName:String="Player")
		//(X:int=0, Y:int=0, Width:int=10, Height:int=10, triggerName:String="Player") 
		{
			super(x, y);
			name = "Sensor";
			//TODO:
			//super.width = Width;
			//super.height = Height;
			Trigger = triggerName;
			_triggered = false;
			//So only player collides with sensors. Without the if statements in SetImpactPoint() it'll still collide with world object that aren't assigned a category..
			fixtureDef.filter.maskBits = 0x0001;
			fixtureDef.isSensor = true;
			bodyDef.type = b2Body.b2_staticBody;
			
			initBoxShape();
			
			_events = new Array();
		}
		
		public function AddEvent(event:IEvent):void
		{
			_events.push(event);
		}
		
		/*
		override public function createPhysBody(world:b2World):void
		{
			super.createPhysBody(world);
			//final_body.SetStatic();
		}
		*/
		
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
		
		override public function setImpactPoint(point:b2Contact):void {
			var spriteA:ExSprite = point.GetFixtureA().GetBody().GetUserData() as ExSprite;
			var spriteB:ExSprite = point.GetFixtureB().GetBody().GetUserData() as ExSprite;
			if ( spriteA.name == Trigger || spriteB.name == Trigger)
				_triggered = true;
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