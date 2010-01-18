package PhysicsGame
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import PhysicsGame.Events.*;
	
	import common.Utilities;
	
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import flash.display.BitmapData;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;

	public class EventObject extends ExSprite
	{
		[Embed(source="../data/editor/interface/pig-icon.png")] private  var eventImg:Class;
		
		public var _impl:EventBase;
		public var _type:uint;
		
		public static const EVENTS:Array =
			[ LevelEvent, 
			  AnimateEvent,
			  SpawnEvent 
			];
		
		public function EventObject(x:int=0, y:int=0, sprite:Class=null, resource:String="", pixels:BitmapData=null, xml:XML=null, world:b2World=null){
		//EventObject(x:int=0, y:int=0, sprite:Class=null, resource:String="", type:uint = 0):void{
			super(x, y, sprite ? sprite : eventImg, resource);
			_type = 0;
			if(xml){
				this.initFromXML(xml, world);
			}
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
		}
		
		public function activate():void{
			_impl.activate();
		}
		
		override public function update():void{
			trace("before: " + x + "," + y);
			super.update();
			
			_impl.update();
			trace("myeventobjecxy: " + x + "," + y);
		}
		override public function render():void{
			trace("render: " + x + "," + y);
			super.render();
			trace("renderafter: " + x + "," + y);
			
			if(_impl.target && _impl.target.exists){
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
			item.type = _type;
			item.x = final_body.GetPosition().x * ExState.PHYS_SCALE;
			item.y = final_body.GetPosition().y * ExState.PHYS_SCALE;
			
			if(this.getTarget()){
				var t:ExSprite = this.getTarget();
				item.target.x = t.final_body.GetWorldCenter().x * ExState.PHYS_SCALE;
				item.target.y = t.final_body.GetWorldCenter().y * ExState.PHYS_SCALE;
			}
			
			return item;
		}
		
		override protected function initFromXML(xml:XML, world:b2World=null):void{
			super.initFromXML(xml);
			
			changeType(xml.type);
			
			if(xml.target.x.length() > 0 && xml.target.y.length() > 0 && world){
				var t:b2Body = Utilities.GetBodyAtPoint(world, new b2Vec2(xml.target.x, xml.target.y), true);
				setTarget(t.GetUserData());
			}
			
		}
	}
}