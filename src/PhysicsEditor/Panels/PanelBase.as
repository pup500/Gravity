package PhysicsEditor.Panels
{
	import PhysicsEditor.IAction;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	
	public class PanelBase
	{
		protected var layer:Sprite;
		protected var actions:Array;
		
		public function PanelBase(x:uint=0, y:uint=0)
		{
			layer = new Sprite();
			layer.x = x;
			layer.y = y;
			
			actions = new Array();
		}
		
		public function getSprite():Sprite{
			return layer;
		}
		
		//Allows for overriding the constructor with other specific ones..
		protected function createItem(aClass:Class):IAction{
			return new aClass();
		}
		
		protected function addItems(items:Array, horizontal:Boolean):void{
			var rect:Rectangle = new Rectangle();
			
			for(var i:uint=0; i < items.length; i++){
				var aClass:Class = items[i];
				var action:IAction = createItem(aClass);
				action.activate(i==0);
				action.getSprite().x = horizontal ? i*40 + 5 : 5;
				action.getSprite().y = horizontal ? 5 : i*40 + 5;				
				actions.push(action);
				layer.addChild(action.getSprite());
			}
			
			//Define the Panel box based on the number of actions we have
			rect.width = horizontal ? items.length * 40 + 10 : 45;
			rect.height = horizontal ? 45 : items.length * 40 + 10;
			
			layer.graphics.beginFill(0x888888,1);
			layer.graphics.lineStyle(2,0x000000,1);
			layer.graphics.drawRoundRect(rect.x, rect.y, rect.width, rect.height, 10, 10);
			layer.graphics.endFill();
			layer.visible = true;
		}
		
		public function update():void{
			for each(var action:IAction in actions){
				action.update();
				
				if(FlxG.mouse.justPressed() && FlxG.keys.SHIFT){
					action.handleBegin();
				}
				
				action.handleDrag();
				
				if(FlxG.mouse.justReleased() && FlxG.keys.SHIFT){
					action.handleEnd();
				}
			}
		}

	}
}