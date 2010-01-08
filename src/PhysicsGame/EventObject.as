package PhysicsGame
{
	import PhysicsGame.Events.*;
	
	import flash.utils.Dictionary;
	
	import org.overrides.ExSprite;

	public class EventObject extends ExSprite
	{
		[Embed(source="../data/editor/interface/pig-icon.png")] private  var eventImg:Class;
		
		public var _impl:EventBase;
		public var _type:uint;
		
		public static const EVENTS:Array =
			[ LevelEvent, 
			  AnimateEvent 
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
		
		public function setArgs(args:Dictionary):void{
			_impl.setArgs(args);
		}
		
		public function activate():void{
			_impl.activate();
		}
		
		/*
		override public function update():void{
			trace("before: " + x + "," + y);
			super.update();
			trace("myeventobjecxy: " + x + "," + y);
		}
		override public function render():void{
			trace("render: " + x + "," + y);
			super.render();
			trace("renderafter: " + x + "," + y);
		}
		*/
	}
}