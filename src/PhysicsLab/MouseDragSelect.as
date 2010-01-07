package PhysicsLab 
{
	import org.flixel.FlxG;
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Norman
	 */
	public class MouseDragSelect
	{
		protected var clickDragStart:Point;
		protected var dragBox:Shape;
		protected var onRelease:Function;
		protected var active:Boolean;
		protected var shiftAndClick:Boolean;
		
		//@desc Handles a mouse click-drag input and renders a box to show the area selected. update() needs to be called in game loop. Must be activated by Activate() to begin input handling.
		//	@param OnDragRelease function called with the mouse button is released. Takes MouseDragSelectEventArgs as argument
		public function MouseDragSelect(OnDragRelease:Function) 
		{
			clickDragStart = new Point();
			dragBox = new Shape();
			onRelease = OnDragRelease;
			
			active = false;
			shiftAndClick = false;
		}
		
		//@desc When the MouseDragSelect is activated, on the next click, a box will appear.
		public function Activate():void
		{
			active = true;
		}
		
		//@desc Handles mouse input and renders the drag box.
		public function update():void
		{
			if (!active) return;
			
			if (FlxG.mouse.justPressed() && FlxG.keys.SHIFT)
			{
				shiftAndClick = true; //set this so these handlers aren't set off immediately when this is activated by a click.
				clickDragStart.x = FlxG.mouse.x;
				clickDragStart.y = FlxG.mouse.y;
			}
			if (FlxG.mouse.pressed() && shiftAndClick)
			{
				if (FlxG.mouse.x != clickDragStart.x || FlxG.mouse.y != clickDragStart.y)
				{
					dragBox.graphics.clear();
					dragBox.graphics.beginFill(0x111111, .25);
					dragBox.graphics.drawRect(clickDragStart.x, clickDragStart.y, FlxG.mouse.x - clickDragStart.x, FlxG.mouse.y - clickDragStart.y);
					dragBox.graphics.endFill();
					FlxG.buffer.draw(dragBox);
				}
			}
			
			if (FlxG.mouse.justReleased() && shiftAndClick)
			{
				active = false;
				shiftAndClick = false;
				
				dragBox.graphics.clear();
				//Call the event handler and pass it the start and ending x, y coordinates
				onRelease(new MouseDragSelectEventArgs(clickDragStart, new Point(FlxG.mouse.x, FlxG.mouse.y)));
			}
		}
	}
	
	
}