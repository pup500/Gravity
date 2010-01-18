package PhysicsEditor.Actions
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;

	public class OptionBase implements IAction
	{
		protected var sprite:Sprite;
		protected var active:Boolean;
		
		public function OptionBase(Graphic:Class)
		{
			sprite = new Sprite();
			
			var bitmap:Bitmap = new Graphic;
			sprite.graphics.beginBitmapFill(bitmap.bitmapData,null,false);
			sprite.graphics.drawRect(0,0,bitmap.bitmapData.width,bitmap.bitmapData.height);
			sprite.graphics.endFill();
			
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		}

		public function getSprite():Sprite
		{
			return sprite;
		}
		
		protected function onClick(event:MouseEvent):void{
			active = !active;
		}
		
		public function update():void
		{
			sprite.alpha = active ? 1 : 0.5;
		}
		
		public function deactivate():void
		{
			active = false;
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