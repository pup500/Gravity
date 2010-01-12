package PhysicsGame
{
	import PhysicsGame.Events.*;
	
	import flash.utils.Dictionary;
	import flash.display.Shape;
	import org.flixel.FlxG;
	
	import org.overrides.ExSprite;

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
		
		public function EventObject(x:int=0, y:int=0, sprite:Class=null, resource:String="", type:uint = 0):void{
			super(x, y, sprite ? sprite : eventImg, resource);
			changeType(type);
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
	}
}