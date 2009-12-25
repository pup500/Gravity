package {
	//import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import PhysicsGame.*;
	import org.overrides.*;
	import PhysicsLab.*;
	
	[SWF(width="640", height="480", backgroundColor="#ffffff")]
	//[Frame(factoryClass="Preloader")]

	public class Main extends ExGame
	{
		public function Main():void
		{
			super(320, 240, LevelSelectMenu, 2);
			super.showLogo = false;
			
			FlxG.levels.push("PhysicsGame.MapClasses.MapOneGap");
			FlxG.levels.push("PhysicsGame.MapClasses.MapSmallOnePlatform");
			FlxG.levels.push("PhysicsGame.MapClasses.MapValley");
			FlxG.levels.push("PhysicsGame.MapClasses.MapTestLevel");

			FlxG.level = 0;
		}
	}
}

