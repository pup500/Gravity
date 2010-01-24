package {
	//import org.flixel.FlxGame;
	import PhysicsGame.*;
	
	import PhysicsLab.*;
	
	import org.flixel.FlxG;
	import org.overrides.*;
	
	[SWF(width="640", height="480", backgroundColor="#ffffff")]
	//[Frame(factoryClass="Preloader")]

	public class Main extends ExGame
	{
		private const MAX_LEVEL:uint = 54;
		
		public function Main():void
		{
			super(640, 480, LevelSelectMenu, 1);
			super.showLogo = false;
			
			for(var i:uint = 1; i <= MAX_LEVEL; i++){
				FlxG.levels.push("data/Maps/level" + i + ".xml");
			}

			FlxG.level = 0;
		}
	}
}

