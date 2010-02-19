package PhysicsEditor
{
	import flash.display.DisplayObject;
	
	public interface IAction
	{
		function getSprite():DisplayObject;
		
		function update():void;
		
		function activate(flag:Boolean):void;
		
		function handleBegin():void;
		
		function handleDrag():void;
		
		function handleEnd():void;
	}
}