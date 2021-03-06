package PhysicsGame.Events
{
	import flash.utils.Dictionary;
	
	import org.overrides.ExSprite;
	
	public class EventBase implements IEvent
	{
		protected var _target:ExSprite;
		protected var _args:Dictionary;
		
		public function EventBase()
		{
		}
		
		public virtual function setArgs(args:Dictionary):void{
			_args = args;
		}
		
		public virtual function setTarget(target:ExSprite):void{
			_target = target;
		}
		
		public virtual function startEvent():void{}
		public virtual function update():void{}
		
		public virtual function get target():ExSprite{
			return _target;
		}

	}
}