package PhysicsGame.Events
{
	import PhysicsGame.XMLPhysState;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	
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
		
		public function setTarget(target:ExSprite):void{};
		public function setArgs(args:Dictionary):void{};
	}

}