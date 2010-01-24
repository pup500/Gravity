package PhysicsEditor.Fields
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	public class FieldBase
	{
		protected var sprite:Sprite;
		protected var labelField:TextField;
		protected var textField:TextField;
		
		protected var state:ExState;
		
		public function FieldBase(label:String, text:String)
		{
			state = FlxG.state as ExState;
			sprite = new Sprite();
			
			labelField = new TextField();
			labelField.text = label;
			labelField.height = labelField.textHeight + 5;
			labelField.width = labelField.textWidth + 5;
			labelField.selectable = false;
			labelField.background = true;
			labelField.backgroundColor = 0xffffff;
			labelField.border = true;
			sprite.addChild(labelField);
			
			textField = new TextField();
			textField.text = text;
			textField.type = TextFieldType.INPUT;
			//textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = true;
			textField.backgroundColor = 0xffffff;
			textField.border = true;
			textField.x = labelField.textWidth + 5;
			textField.height = textField.textHeight + 5;
			textField.width = 40;
			textField.maxChars = 5;			
			sprite.addChild(textField);
		}
		
		public function addField(field:TextField):void{
			sprite.addChild(field);
			
		}
		
		public function getSprite():DisplayObject{
			return sprite;
		}
		
		public function update():void{
			//trace("text: " + textField.text);
		}

	}
}