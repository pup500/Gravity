package PhysicsEditor.Fields
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	public class FieldBase
	{
		protected var sprite:Sprite;
		protected var labelField:TextField;
		protected var textField:TextField;
		
		protected var state:ExState;
		protected var lock:Boolean;
		
		public function FieldBase(label:String, text:String)
		{
			state = FlxG.state as ExState;
			sprite = new Sprite();
			
			labelField = new TextField();
			labelField.text = label;
			labelField.height = labelField.textHeight + 5;
			labelField.width = 50;//labelField.textWidth + 5;
			labelField.selectable = false;
			labelField.background = true;
			labelField.backgroundColor = 0x888888;
			labelField.border = true;
			labelField.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			sprite.addChild(labelField);
			
			textField = new TextField();
			textField.text = text;
			textField.type = TextFieldType.INPUT;
			//textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = true;
			textField.backgroundColor = 0xeeeeee;
			textField.border = true;
			textField.x = labelField.width;//labelField.textWidth + 5;
			textField.height = textField.textHeight + 5;
			textField.width = 40;
			textField.maxChars = 5;			
			sprite.addChild(textField);
			
			lock = false;
		}
		
		protected function onClick(event:MouseEvent):void{
			lock = !lock;
		}
		
		public function addField(field:TextField):void{
			sprite.addChild(field);
			
		}
		
		public function getSprite():DisplayObject{
			return sprite;
		}
		
		public function update():void{
			labelField.backgroundColor = lock ? 0x3366FF : 0x888888;
			textField.selectable = !lock;
			textField.backgroundColor = lock ? 0x888888 : 0xeeeeee;
			//trace("text: " + textField.text);
		}
		
		public function getValue():String{
			if(textField)
				return textField.text;
			else
				return null;
		}
		
		public function setValue(s:String):void{
			if(textField && s)
				textField.text = s;
		}
	}
}