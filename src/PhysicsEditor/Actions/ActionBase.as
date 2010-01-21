package PhysicsEditor.Actions
{
	import PhysicsEditor.Options.OptionBase;
	import Box2D.Common.Math.b2Vec2;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	
	public class ActionBase extends OptionBase
	{
		protected var beginDrag:Boolean;
		
		protected var args:Dictionary;
		
		protected var onPreClick:Function;
		
		public function ActionBase(Graphic:Class, preClick:Function)
		{
			super(Graphic);
			
			args = new Dictionary();
			
			//TODO:Preclick should probably be the panel....
			onPreClick = preClick;
		}
		
		override protected function onClick(event:MouseEvent):void{
			onPreClick();
			
			active = true;
		}
		
		override public function handleBegin():void{
			if(!active) return;
			
			beginDrag = true;
			args["start"] = new b2Vec2(FlxG.mouse.x, FlxG.mouse.y);
			
			onHandleBegin();
		}
		
		override public function handleDrag():void{
			if(!beginDrag) return;
			
			onHandleDrag();
		}
		
		override public function handleEnd():void{
			if(!active) return;
			
			beginDrag = false;
			args["end"] = new b2Vec2(FlxG.mouse.x, FlxG.mouse.y);
			
			onHandleEnd();
		}
		
		virtual public function onHandleBegin():void{}
		virtual public function onHandleDrag():void{}
		virtual public function onHandleEnd():void{}
	}
}