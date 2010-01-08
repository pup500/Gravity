package PhysicsGame.Events
{
	import flash.utils.Dictionary;
	
	import org.overrides.ExSprite;
	
	public class EventBase
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
		
		public virtual function activate():void{}

	}
}