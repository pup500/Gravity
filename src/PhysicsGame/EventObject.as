package PhysicsGame
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import Box2D.Common.b2internal;
	
	import PhysicsGame.Events.*;
	
	import common.Utilities;
	
	import flash.display.Shape;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	
	use namespace b2internal;

	public class EventObject extends ExSprite
	{
		[Embed(source="../data/editor/interface/add_event.png")] private  var eventImg:Class;
		
		public var _impl:EventBase;
		public var _type:uint;
		
		private var args:Dictionary;
		
		public static const EVENTS:Array =
			[ LevelEvent, 
			  AnimateEvent,
			  SpawnEvent,
			  LerpEvent
			];
		
		public function EventObject(x:int=0, y:int=0){
			super(x, y, eventImg);
			
			physicsComponent.initStaticBody();
			physicsComponent.setCategory(FilterData.SPECIAL);
			physicsComponent.addShape(physicsComponent.createShape(1), 0, 1, true);
			
			//fixtureDef.isSensor = true;
			//fixtureDef.filter.groupIndex = -2;
			//fixtureDef.filter.categoryBits = FilterData.SPECIAL;
			
			args = new Dictionary();
		}
		
		public function changeType(type:uint):void{
			if(type < 0 || type >= EVENTS.length) return;
			
			_type = type;
			
			_impl = new EVENTS[type]();
		}
		
		public function setTarget(target:ExSprite):void{
			_impl.setTarget(target);
		}
		
		public function getTarget():ExSprite{
			return _impl.target;
		}
		
		public function setArgs(args:Dictionary):void{
			_impl.setArgs(args);
			
			this.args = args;
		}
		
		public function activate():void{
			_impl.startEvent();
		}
		
		override public function update():void{
			super.update();
			
			args["x"] = x;
			args["y"] = y;
			
			if(_impl){
				_impl.setArgs(args);
				_impl.update();
			}
		}
		
		override public function render():void{
			//trace("render: " + x + "," + y);
			super.render();
			//trace("renderafter: " + x + "," + y);
			
			if(!visible)
				return;
			
			if(_impl && _impl.target && _impl.target.exists){
				getScreenXY(_p);
				
				var myShape:Shape = new Shape();
				myShape.graphics.lineStyle(2,0x0,1);
				myShape.graphics.moveTo(_p.x + width/2, _p.y + height/2);
				myShape.graphics.lineTo(_p.x  - x + _impl.target.x + _impl.target.width/2, _p.y - y + _impl.target.y + _impl.target.height/2);
				FlxG.buffer.draw(myShape);
			}
			
		}
		
		override public function getXML():XML
		{
			var item:XML = new XML(<event/>);
			item.@type = _type;
			item.@x = GetBody().GetPosition().x * ExState.PHYS_SCALE;
			item.@y = GetBody().GetPosition().y * ExState.PHYS_SCALE;
			
			if(this.getTarget()){
				var t:ExSprite = this.getTarget();
				
				//TODO:If we had deleted the target, the event would still have a reference to it
				//But it won't have a body
				if(t.GetBody()){
					item.target.@x = t.GetBody().GetWorldCenter().x * ExState.PHYS_SCALE;
					item.target.@y = t.GetBody().GetWorldCenter().y * ExState.PHYS_SCALE;
				}
			}
			
			/*
			var arg:XML;
			for (var key:Object in args)

			{
				trace("EventArgs" + key + " || " + args[key]);
				arg = new XML(<arg/>);
				arg.@name = key;
				arg.@value = args[key];
				
				item.appendChild(arg);
			}
			*/
			var arg:XML = <arg/>
			if(args["speed"]){
				arg.@name = "speed"
				arg.@value = args["speed"];
				item.appendChild(arg);
			}
			
			return item;
		}
		
		override public function initFromXML(xml:XML):void{
			super.initFromXML(xml);
			
			changeType(xml.@type);
			
			xml.@shapeType = b2Shape.e_polygonShape;
			var body:b2Body = physicsComponent.createBodyFromXML(xml);
			physicsComponent.createFixtureFromXML(xml, true);
			
			//TODO:Be careful of selecting targets by position, you might have overlapping objects
			if(xml.target.@x.length() > 0 && xml.target.@y.length() > 0){
				var t:b2Body = Utilities.GetBodyAtPoint(new b2Vec2(xml.target.@x, xml.target.@y), true);
				setTarget(t.GetUserData());
			}
			
			if (xml.arg.length() > 0)
			{ 
				for each(var arg:XML in xml.arg)
				{
					//trace("parsing out args: " + arg.@name + " " +  arg.@value);
					args[arg.@name.toString()] = arg.@value;
					trace("parsing out args: " + args[arg.@name.toString()] + " " +  arg.@value);
				}
				setArgs(args);
			}
		}
	}
}