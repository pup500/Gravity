package {
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import com.adamatomic.Mode.*;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(320, 240, LevelSelectMenu, 2);
			super.showLogo = false;
			
			FlxG.levels.push("com.adamatomic.Mode.MapOneGap");
			FlxG.levels.push("com.adamatomic.Mode.MapSmallOnePlatform");
			FlxG.levels.push("com.adamatomic.Mode.MapValley");
			FlxG.levels.push("com.adamatomic.Mode.MapTestLevel");

			FlxG.level = 0;
		}
	}
}

