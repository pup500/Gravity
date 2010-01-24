package PhysicsEditor
{
	import flash.display.Sprite;
	
	public interface IPanel
	{
		function getSprite():Sprite;
		
		function update():void;
		
		function deactivateAllActions():void;
	}
}