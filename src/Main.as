package {
	import com.adamatomic.flixel.FlxGame;
	import com.adamatomic.Mode.MenuState;
	import com.adamatomic.Mode.NewPlayState;
	import com.adamatomic.Mode.PlayStateFlanTiles;
	import com.adamatomic.Mode.MapNewMap;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(320,240,PlayStateFlanTiles,3,0xff131c1b,false,0xff729954);
			help("Jump", "Shoot", "Nothing");
		}
	}
}

