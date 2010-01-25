package PhysicsGame 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class PlayAnimationEvent extends FlxSprite implements IEvent
	{
		//protected var _animationSprite:FlxSprite;
		protected var _animName:String;
		
		public function PlayAnimationEvent(x:int, y:int ,graphic:Class, animationToPlay:String) 
		{
			super(x, y);
			loadGraphic(graphic, true);
			//_animationSprite = sprite;
			visible = false;
			//_animationSprite.visible = false;
			
			_animName = animationToPlay;
		}
		
		override public function update():void
		{
			super.update();
			
			if (finished) //if animation has finished
			{
				visible = false;
			}
		}
		
		/* IEvent interface implementation */
		public function startEvent():void
		{
			trace("sensed in animEvent sprite!");
			visible = true;
			play(_animName, true); //Animation won't play again unless we force loop. Weird...
			
			//_animationSprite.visible = true;
			//_animationSprite.play(_animName);
		}
		
		public function setTarget():void
		{
			
		}
		
		public function setArgs():void 
		{
			
		}
	}

}