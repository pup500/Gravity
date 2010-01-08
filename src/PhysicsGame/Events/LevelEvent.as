package PhysicsGame.Events
{
	import org.flixel.FlxG;
	import PhysicsGame.XMLPhysState;
	
	public class LevelEvent extends EventBase
	{
		public function LevelEvent()
		{
			super();
		}
		
		//Fake for now....
		override public function activate():void{
			FlxG.level = _args["level"];
			FlxG.switchState(XMLPhysState);
		}
		
	}
}