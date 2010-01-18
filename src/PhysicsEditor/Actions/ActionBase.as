package PhysicsEditor.Actions
{
	import Box2D.Common.Math.b2Vec2;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	
	public class ActionBase extends OptionBase
	{
		protected var beginDrag:Boolean;
		
		protected var args:Dictionary;
		
		protected var onPreClick:Function;
		protected var onPostRelease:Function;
		
		public function ActionBase(Graphic:Class, preClick:Function, postRelease:Function)
		{
			super(Graphic);
			
			args = new Dictionary();
			
			onPreClick = preClick;
			onPostRelease = postRelease;
		}
		
		override protected function onClick(event:MouseEvent):void{
			onPreClick();
			
			active = true;
		}
		
		override public function handleBegin():void{
			if(!active) return;
			
			beginDrag = true;
			args["start"] = new b2Vec2(FlxG.mouse.x, FlxG.mouse.y);
		}
		
		override public function handleDrag():void{
			if(!active) return;
		}
		
		override public function handleEnd():void{
			if(!active) return;
			
			beginDrag = false;
			args["end"] = new b2Vec2(FlxG.mouse.x, FlxG.mouse.y);
			onPostRelease(args);
		}
	}
}