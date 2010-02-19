package com.adamatomic.Mode 
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
		[Embed(source="../../../data/cursor.png")] private var ImgCursor:Class;
		[Embed(source="../../../data/menu_hit.mp3")] private var SndHit:Class;
		
		protected var _btnOneGap:FlxButton;
		protected var _btnSmallOnePlatform:FlxButton;
		protected var _btnValley:FlxButton;
		protected var _btnTestLevel:FlxButton;
		
		protected var _buttons:Array;
		
		public function LevelSelectMenu() 
		{
			_buttons = new Array();
			
			FlxG.showCursor(ImgCursor);
			
			var t1m:uint = FlxG.width/2-54;
			
			//for (var i:int = 0; i < FlxG.levels.length; i++)
			//{
				//var buttonHeight:int = 10 + (i*20)
				//
				//_buttons.add(this.add(new ArgsButton(10,buttonHeight,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onButtonClick,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(25,1,100,10,,0x729954),new FlxText(25,1,100,10,level,0xd8eba2), new ButtonArgs(i))) as FlxButton);
				//
			//}
			var x:int = 10;
			var y:int = 10;
			addButton(_btnOneGap,onOneGap, x, y, "One Gap");
			addButton(_btnSmallOnePlatform, onSmallOnePlatform, x, y+=30, "Small One Plat'");
			addButton(_btnValley, onValley, x, y += 30, "Valley");
			addButton(_btnTestLevel, onTestLevel, x, y += 30, "Test Level");
		}
		
		private function addButton(button:FlxButton, onClick:Function, x:int, y:int, text:String):void
		{
			button = new FlxButton(x,y,onClick);
			button.loadGraphic((new FlxSprite()).createGraphic(104,15,0xff3a5c39),(new FlxSprite()).createGraphic(104,15,0xff729954));
			
			var t1:FlxText = new FlxText(25,1,100,text);
			t1.color = 0x729954;
			var t2:FlxText = new FlxText(t1.x,t1.y,t1.width,t1.text);
			t2.color = 0xd8eba2;
			
			button.loadText(t1,t2);
			add(button);
		}
		
		//private function onButtonClick(args:ButtonArgs = null):void
		//{
			//if(args != null)
				//FlxG.level = args.level;
			//
			//FlxG.play(SndHit);
			//FlxG.switchState(GravSpawnFlanTilesState);
		//}
		
		private function onOneGap():void
		{
			loadLevel(0);
		}
		
		private function onSmallOnePlatform():void
		{
			loadLevel(1);
		}
		
		private function onValley():void
		{
			loadLevel(2);
		}
		
		private function onTestLevel():void
		{
			loadLevel(3);
		}
		
		private function loadLevel(levelNum:int):void
		{
			FlxG.level = levelNum;
			FlxG.play(SndHit);
			FlxG.switchState(GravSpawnFlanTilesState);
		}

	}

}