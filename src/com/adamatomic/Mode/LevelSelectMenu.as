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
		
		protected var _buttons:FlxArray;
		
		public function LevelSelectMenu() 
		{
			_buttons = new FlxArray();
			
			FlxG.setCursor(ImgCursor);
			
			var t1m:uint = FlxG.width/2-54;
			
			//for (var i:int = 0; i < FlxG.levels.length; i++)
			//{
				//var buttonHeight:int = 10 + (i*20)
				//
				//_buttons.add(this.add(new ArgsButton(10,buttonHeight,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onButtonClick,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(25,1,100,10,,0x729954),new FlxText(25,1,100,10,level,0xd8eba2), new ButtonArgs(i))) as FlxButton);
				//
			//}
			//One Gap Map button
			_btnOneGap = this.add(new FlxButton(10,10,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onOneGap,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(25,1,100,10,"One Gap",0x729954),new FlxText(25,1,100,10,"One Gap",0xd8eba2))) as FlxButton;
		
			_btnSmallOnePlatform = this.add(new FlxButton(10, 30, new FlxSprite(null, 0, 0, false, false, 104, 15, 0xff3a5c39), onSmallOnePlatform, new FlxSprite(null, 0, 0, false, false, 104, 15, 0xff729954), new FlxText(25, 1, 100, 10, "Small One Platform", 0x729954), new FlxText(25, 1, 100, 10, "Small One Platform", 0xd8eba2))) as FlxButton;
			
			_btnValley = this.add(new FlxButton(10,50,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onValley,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(25,1,100,10,"Valley",0x729954),new FlxText(25,1,100,10,"Valley",0xd8eba2))) as FlxButton;
		}
		
		private function onButtonClick(args:ButtonArgs = null):void
		{
			if(args != null)
				FlxG.level = args.level;
			
			FlxG.play(SndHit);
			FlxG.switchState(PlayStateFlanTiles);
		}
		
		private function onOneGap():void
		{
			FlxG.level = 0;
			FlxG.play(SndHit);
			FlxG.switchState(GravSpawnFlanTilesState);
		}
		
		private function onSmallOnePlatform():void
		{
			FlxG.level = 1;
			FlxG.play(SndHit);
			FlxG.switchState(GravSpawnFlanTilesState);
		}
		
		private function onValley():void
		{
			FlxG.level = 2;
			FlxG.play(SndHit);
			FlxG.switchState(GravSpawnFlanTilesState);
		}
	}

}