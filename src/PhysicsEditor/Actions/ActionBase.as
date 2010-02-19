package PhysicsEditor.Actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import PhysicsEditor.IPanel;
	import PhysicsEditor.Options.OptionBase;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	
	public class ActionBase extends OptionBase
	{
		protected var beginDrag:Boolean;
		
		protected var args:Dictionary;
		
		public function ActionBase(Graphic:Class, panel:IPanel, active:Boolean)
		{
			super(Graphic, panel, active);
			
			args = new Dictionary();
		}
		
		override protected function onClick(event:MouseEvent):void{
			panel.deactivateAllActions();
			active = true;
		}
		
		protected function getMouse(snap:Boolean):b2Vec2{
			var size:uint = 4;
			if(snap)
				return new b2Vec2(FlxG.mouse.x - (FlxG.mouse.x % size), FlxG.mouse.y - (FlxG.mouse.y % size));
			else
				return new b2Vec2(FlxG.mouse.x, FlxG.mouse.y);
		}
		
		override public function update():void{
			super.update();
			
			args["mouse"] = getMouse(false);
			args["mouse_snap"] = getMouse(state.getArgs()["snap"]);
		}
		
		override public function handleBegin():void{
			if(!active) return;
			
			beginDrag = true;
			args["start"] = getMouse(false);
			args["start_snap"] = getMouse(state.getArgs()["snap"]);
			
			onHandleBegin();
		}
		
		override public function handleDrag():void{
			if(!beginDrag) return;
			
			args["drag"] = getMouse(false);
			args["drag_snap"] = getMouse(state.getArgs()["snap"]);
			
			onHandleDrag();
		}
		
		override public function handleEnd():void{
			if(!active) return;
			
			beginDrag = false;
			args["end"] = getMouse(false);
			args["end_snap"] = getMouse(state.getArgs()["snap"]);
			
			onHandleEnd();
		}
		
		virtual public function onHandleBegin():void{}
		virtual public function onHandleDrag():void{}
		virtual public function onHandleEnd():void{}
	}
}