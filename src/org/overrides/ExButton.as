package org.overrides
{
	import flash.events.MouseEvent;
	
	import org.flixel.FlxButton;
	import org.flixel.FlxCore;
	import org.flixel.FlxG;

	public class ExButton extends FlxButton
	{
		public function ExButton(X:int, Y:int, Callback:Function)
		{
			super(X, Y, Callback);
		}
		
		override public function update():void
		{
			if(!_initialized)
			{
				if(FlxG.state == null) return;
				if(FlxG.state.parent == null) return;
				if(FlxG.state.parent.stage == null) return;
				FlxG.state.parent.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_initialized = true;
			}
			
			//super.update();
			last.x = x;
			last.y = y;
			
			if(flickering())
			{
				if(_flickerTimer > 0)
				{
					_flickerTimer -= FlxG.elapsed;
					if(_flickerTimer == 0)
						_flickerTimer = -1;
				}
				if(_flickerTimer < 0)
					flicker(-1);
				else
				{
					_flicker = !_flicker;
					visible = !_flicker;
				}
			}
			//END Core Super Class updates

			if((_off != null) && _off.exists && _off.active) _off.update();
			if((_on != null) && _on.exists && _on.active) _on.update();
			if(_offT != null)
			{
				if((_offT != null) && _offT.exists && _offT.active) _offT.update();
				if((_onT != null) && _onT.exists && _onT.active) _onT.update();
			}

			visibility(false);
			//FIX:Fixed scrolling issue with having mouse coordinates not being correctly handled for offset...
			//if(_off.overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
			if(_off.overlapsPoint(FlxG.mouse.x+(1-scrollFactor.x)*FlxG.scroll.x,FlxG.mouse.y+(1-scrollFactor.y)*FlxG.scroll.y))//_off.overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
			{
				if(!FlxG.mouse.pressed())
					_pressed = false;
				else if(!_pressed)
				{
					_pressed = true;
					if(!_initialized) _callback();
				}
				visibility(!_pressed);
			}
			if(_onToggle) visibility(_off.visible);
			updatePositions();
		}
	}
}