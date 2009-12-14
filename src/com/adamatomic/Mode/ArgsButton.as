package com.adamatomic.Mode 
{
	import com.adamatomic.flixel.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ArgsButton extends FlxButton
	{
		public var args:ButtonArgs;
		
		public function ArgsButton(X:int,Y:int,Image:FlxSprite,Callback:Function,ImageOn:FlxSprite=null,Text:FlxText=null,TextOn:FlxText=null,args:ButtonArgs=null)
		{
			super(X,Y,Image,Callback, ImageOn, Text,TextOn)
			if(args != null)
				this.args = args;
			else
				this.args = new ButtonArgs();
		}
		
		//@desc	Called by the game loop automatically, handles mouseover and click detection
		override public function update():void
		{
			super.update();

			if((_off != null) && _off.exists && _off.active) _off.update();
			if((_on != null) && _on.exists && _on.active) _on.update();
			if(_offT != null)
			{
				if((_offT != null) && _offT.exists && _offT.active) _offT.update();
				if((_onT != null) && _onT.exists && _onT.active) _onT.update();
			}

			visibility(false);
			if(_off.overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
			{
				if(!FlxG.kMouse)
					_pressed = false;
				else if(!_pressed)
				{
					_pressed = true;
					_callback(args);
				}
				visibility(!_pressed);
			}
			if(_onToggle) visibility(_off.visible);
			updatePositions();
		}
		
	}

}