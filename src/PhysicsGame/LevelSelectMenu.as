package PhysicsGame 
{
	import org.flixel.*;
	
	/**
	 * Class acts as a way to load any level we want. 
	 * @author Norman
	 */
	public class LevelSelectMenu extends FlxState
	{
		[Embed(source="../data/cursor.png")] private var ImgCursor:Class;
		[Embed(source="../data/menu_hit.mp3")] private var SndHit:Class;
		
		public function LevelSelectMenu() 
		{
			FlxG.showCursor(ImgCursor);
			
			//Display in square tiles....
			for (var i:int = 0; i < FlxG.levels.length; i++)
			{
				addBlock((i%9*32)+17, Math.floor(i/9)*32 + 30, String(i+1), wrapper(i));
			}
		}
		
		private function addBlock(x:int, y:int, text:String, onClick:Function):void
		{
			//Create the button, image and highlighted image
			var button:FlxButton = new FlxButton(x,y,onClick);
			var image:FlxSprite = (new FlxSprite()).createGraphic(30,30,0xff3a5c39);
			var imagehl:FlxSprite = (new FlxSprite()).createGraphic(30,30,0xff729954);
			
			button.loadGraphic(image, imagehl);
			
			var t1:FlxText = new FlxText(0,0,text.length*10,text);
			t1.color = 0x729954;
			var t2:FlxText = new FlxText(t1.x,t1.y,t1.width,t1.text);
			t2.color = 0xd8eba2;
			
			button.loadText(t1,t2);
			
			add(button);
		}
		
		//Old way was to just display a text button...
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
		
		//This function wraps the loadlevel function into another scope in order for value to be evaluated
		//before the loop terminates
		private function wrapper(value:int):Function{
			return function():void{loadLevel(value)};
		}
		
		//Actual function to load set the current level and load the play state
		private function loadLevel(levelNum:int):void
		{
			FlxG.level = int(levelNum);
			FlxG.play(SndHit);
			FlxG.switchState(XMLPhysState);
		}
	}
}