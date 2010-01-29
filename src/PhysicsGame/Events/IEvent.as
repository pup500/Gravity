package PhysicsGame.Events
{
	import flash.utils.Dictionary;
	import org.overrides.ExSprite;
	
	/**
	 * ...
	 * @author Norman
	 */
	public interface IEvent 
	{
		function startEvent():void;
		
		function setTarget(target:ExSprite):void;
		
		function setArgs(args:Dictionary):void;
	}
	
}