package PhysicsGame.Events
{
	public class AnimateEvent extends EventBase
	{
		public function AnimateEvent()
		{
			super();
		}
		
		override public function activate():void{
			_target.play(_args["anim"]);
		}
		
	}
}