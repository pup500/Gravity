package PhysicsGame 
{
	import org.flixel.*;
	
	/**
	 * TODO: Does NOT work yet. Need to figure architecture for calling different levels.
	 * 			For now, change levels by changing the MapBase class that's instantiated
	 * 			in PlayStateFlanTiles.as. 
	 * @author Norman
	 */
	public class LevelSelectMenu extends FlxState
	{
		[Embed(source="../data/cursor.png")] private var ImgCursor:Class;
		[Embed(source="../data/menu_hit.mp3")] private var SndHit:Class;
		
		public function LevelSelectMenu() 
		{
			FlxG.showCursor(ImgCursor);
			
			var t1m:uint = FlxG.width/2-54;
			
			for (var i:int = 0; i < FlxG.levels.length; i++)
			{
				addButton(10, (i+1) * 30, FlxG.levels[i].substring(23), function():void{loadLevel(i)});
			}
		}
		
		private function addButton(x:int, y:int, text:String, onClick:Function):void
		{
			//Create the button, image and highlighted image
			var button:FlxButton = new FlxButton(x,y,onClick);
			var image:FlxSprite = (new FlxSprite()).createGraphic(104,15,0xff3a5c39);
			var imagehl:FlxSprite = (new FlxSprite()).createGraphic(104,15,0xff729954);
			
			button.loadGraphic(image, imagehl);
			
			//Create the text and highlighted text on the button
			var t1:FlxText = new FlxText(25,1,100,text);
			t1.color = 0x729954;
			var t2:FlxText = new FlxText(t1.x,t1.y,t1.width,t1.text);
			t2.color = 0xd8eba2;
			button.loadText(t1,t2);
			
			add(button);
		}
		
		private function loadLevel(levelNum:int):void
		{
			FlxG.level = levelNum;
			FlxG.play(SndHit);
			FlxG.switchState(PhysState);
		}
	}

}