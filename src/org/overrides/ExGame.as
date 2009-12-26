package org.overrides
{
	import org.flixel.FlxGame;
	
	public class ExGame extends FlxGame
	{
		public function ExGame(GameSizeX:uint, GameSizeY:uint, InitialState:Class, Zoom:uint=2)
		{
			super(GameSizeX, GameSizeY, InitialState, Zoom);
		}	
	}
}