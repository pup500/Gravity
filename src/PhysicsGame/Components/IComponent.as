package PhysicsGame.Components
{
	import flash.utils.Dictionary;
	
	public interface IComponent
	{
		function update():void;
		
		function receive(args:Object):Boolean;
	}
}