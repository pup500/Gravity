package PhysicsGame.Components
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;
	
	public class EditorInputComponent implements IComponent
	{
		protected var me:ExSprite;
		
		public function EditorInputComponent(obj:ExSprite)
		{
			me = obj;
		}

		public function update():void
		{
			me.GetBody().SetAwake(true);
			me.GetBody().GetLinearVelocity().SetZero();
			
			if(FlxG.keys.LEFT)
			{
				me.facing = FlxSprite.LEFT;
				me.GetBody().GetLinearVelocity().x = -10;
				me.play("run");
			}
			else if(FlxG.keys.RIGHT)
			{
				me.facing = FlxSprite.RIGHT;
				me.GetBody().GetLinearVelocity().x = 10;
				me.play("run");
			}
			else if(FlxG.keys.UP){
				me.GetBody().GetLinearVelocity().y = -10;
				me.play("jump");
			}
			else if(FlxG.keys.DOWN){
				me.GetBody().GetLinearVelocity().y = 10;
				me.play("jump");
			}
			else{	
				me.play("idle");
			}
			
			trace("speed: " + me.GetBody().GetLinearVelocity().x + "," + me.GetBody().GetLinearVelocity().y);
		}
		
		public function receive(args:Object):Boolean{
			return false;
		}
	}
}