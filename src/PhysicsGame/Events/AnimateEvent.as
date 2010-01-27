package PhysicsGame.Events
{
	public class AnimateEvent extends EventBase
	{
		public function AnimateEvent()
		{
			super();
		}
		
		override public function startEvent():void{
			_target.play(_args["anim"]);
		}
		
	}
}