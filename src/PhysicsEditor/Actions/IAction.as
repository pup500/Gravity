package PhysicsEditor.Actions
{
	import flash.display.Sprite;
	
	public interface IAction
	{
		function getSprite():Sprite;
		
		function update():void;
		
		function deactivate():void;
		
		function handleBegin():void;
		
		function handleDrag():void;
		
		function handleEnd():void;
	}
}