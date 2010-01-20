package PhysicsEditor
{
	import flash.display.Sprite;
	
	public interface IAction
	{
		function getSprite():Sprite;
		
		function update():void;
		
		function activate(flag:Boolean):void;
		
		function handleBegin():void;
		
		function handleDrag():void;
		
		function handleEnd():void;
	}
}