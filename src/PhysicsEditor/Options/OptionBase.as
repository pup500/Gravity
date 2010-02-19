package PhysicsEditor.Options
{
	import PhysicsEditor.IAction;
	import PhysicsEditor.IPanel;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;

	public class OptionBase implements IAction
	{
		protected var sprite:Sprite;
		protected var tooltip:String;
		protected var active:Boolean;
		protected var state:ExState;
		protected var panel:IPanel;
		
		public function OptionBase(Graphic:Class, panel:IPanel, active:Boolean)
		{
			sprite = new Sprite();
			
			var bitmap:Bitmap = new Graphic;
			sprite.graphics.beginBitmapFill(bitmap.bitmapData,null,false);
			sprite.graphics.drawRect(0,0,bitmap.bitmapData.width,bitmap.bitmapData.height);
			sprite.graphics.endFill();
			
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			sprite.addEventListener(MouseEvent.MOUSE_OVER, onHover);
			sprite.addEventListener(MouseEvent.MOUSE_OUT, onLeave);
			
			state = FlxG.state as ExState;
			
			this.active = active;
			this.panel = panel;
			
			tooltip = "";
		}
		
		public function getSprite():DisplayObject{
			return sprite;
		}
		
		protected function onClick(event:MouseEvent):void{
			active = !active;
		}
		
		protected function onHover(event:MouseEvent):void{
			//tooltip.visible = tooltip.text.length > 0;
		}
		
		protected function onLeave(event:MouseEvent):void{
			//tooltip.visible = false;
		}
		
		public function update():void
		{
			sprite.alpha = active ? 1 : 0.5;
		}
		
		public function activate(flag:Boolean):void
		{
			active = flag;
		}
		
		public function handleBegin():void
		{
		}
		
		public function handleDrag():void
		{
		}
		
		public function handleEnd():void
		{
		}
		
	}
}