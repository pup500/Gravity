﻿package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import common.Utilities;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	use namespace b2internal;
	
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
		{
			super(x, y);
			name = "Sensor";
			//TODO:
			//super.width = Width;
			//super.height = Height;
			Trigger = triggerName;
			_triggered = false;
			
			physicsComponent.initStaticBody();
			physicsComponent.setCategory(FilterData.SPECIAL);
			physicsComponent.createFixture(b2Shape.e_polygonShape, 0, 1, true);
			
			_events = new Array();
		}
		
		public function setTrigger(trigger:String):void{
			Trigger = trigger;
		}
		
		public function setTarget(target:ExSprite):void
		{
			_events.push(target);
		}
		
		public function AddEvent(eventObj:EventObject):void
		{
			_events.push(eventObj);
		}
		
		override public function update():void
		{
			super.update();
			
			if (_triggered)
			{
				playEvents();
			}
		}
		
		override public function render():void{
			super.render();
			
			if(!visible)
				return;
			
			//TODO:Need something to specify when to not draw the lines
			for each(var event:EventObject in _events){
				getScreenXY(_p);

				var myShape:Shape = new Shape();
				myShape.graphics.lineStyle(2,0xff3333,1);
				myShape.graphics.moveTo(_p.x + width/2, _p.y + height/2);
				myShape.graphics.lineTo(_p.x  - x + event.x + event.width/2, _p.y - y + event.y + event.height/2);
				FlxG.buffer.draw(myShape);
			}
		}
		
		protected function playEvents():void
		{
			trace("Sensed by sensor.as");
			for each(var eventObj:EventObject in _events)
			{
				eventObj.activate();
			}
			_triggered = false;
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void {
			if(!oFixture) 
				return;
			
			var oSprite:ExSprite = oFixture.GetBody().GetUserData() as ExSprite;
			
			if (oSprite.name == Trigger)
				_triggered = true;
		}
		
		override public function getXML():XML
		{
			var xml:XML = new XML(<sensor/>);
			xml.@x = GetBody().GetWorldCenter().x * ExState.PHYS_SCALE;		 		
			xml.@y = GetBody().GetWorldCenter().y * ExState.PHYS_SCALE;
			xml.@width = _bw;
			xml.@height = _bh;
			xml.@trigger = Trigger;
			
			for each (var event:EventObject in _events){
				var eventXML:XML = new XML(<event/>);
				eventXML.@x = event.GetBody().GetWorldCenter().x * ExState.PHYS_SCALE;;
				eventXML.@y = event.GetBody().GetWorldCenter().y * ExState.PHYS_SCALE;;
				xml.appendChild(eventXML);
			}
			
			return xml;
		}
		
		override protected function onInitXMLComplete(xml:XML, event:Event = null):void
		{
			//Load the bitmap data
			//if(event){
				//var loadinfo:LoaderInfo = LoaderInfo(event.target);
				//var bitmapData:BitmapData = Bitmap(loadinfo.content).bitmapData;
		 		//pixels = bitmapData;
			//}
			
			//Assume we have pixel data already....
			//imageResource = xml.file;
			//layer = xml.@layer;
			
			//Setup the sensor graphics
			var bitmapData:BitmapData = new BitmapData(xml.@width, xml.@height, true, 0x0);
			bitmapData.fillRect(new Rectangle(0,0,xml.@width, xml.@height), 0xff888888);
			pixels = bitmapData;
			
			_bw = xml.@width;
			_bh = xml.@height;
			
			if(xml.@trigger.length() > 0){
				Trigger = xml.@trigger;
			}
			
			xml.@shapeType = b2Shape.e_polygonShape;
			var body:b2Body = physicsComponent.createBodyFromXML(xml);
			physicsComponent.createFixtureFromXML(xml, true);
			
			loaded = true;
			
			for each(var evXML:XML in xml.event){
				//trace("sensor event: " + evXML.@x + "," + evXML.@y);
				var t:b2Body = Utilities.GetBodyAtPoint(new b2Vec2(evXML.@x, evXML.@y), true);
				if(t)
		    		AddEvent(t.GetUserData());
		    }
			
			reset(xml.@x, xml.@y);
			
			update();
		}
	}
}