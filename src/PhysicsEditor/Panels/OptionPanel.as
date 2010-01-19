package PhysicsEditor.Panels
{
	import PhysicsEditor.Options.*;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	
	public class OptionPanel extends PanelBase
	{
		private var OPTIONS:Array = [DebugOption, GridOption, SnapOption];
		
		public function OptionPanel(x:uint=0, y:uint=0, horizontal:Boolean=false)
		{
			super(x,y);
			addItems(OPTIONS, horizontal);
		}
	}
}