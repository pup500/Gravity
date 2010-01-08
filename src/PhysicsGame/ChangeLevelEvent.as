package PhysicsGame 
{
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ChangeLevelEvent implements IEvent
	{
		private var _levelToChangeTo:int;
		
		public function ChangeLevelEvent(destinationLevel:int) 
		{
			_levelToChangeTo = destinationLevel;
		}
		
		/* IEvent interface implementation */
		public function startEvent():void
		{
			FlxG.level = _levelToChangeTo
			FlxG.switchState(XMLPhysState);
		}
		
		public function setTarget():void{};
		public function setArgs():void{};
	}

}