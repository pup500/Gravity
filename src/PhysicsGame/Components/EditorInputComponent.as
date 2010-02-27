package PhysicsGame.Components
{
	import Box2D.Common.Math.b2Vec2;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;
	
	public class EditorInputComponent implements IComponent
	{
		protected var me:ExSprite;
		
		//TODO:Change this into ExSprite
		public function EditorInputComponent(obj:ExSprite)
		{
			me = obj;
		}

		public function update():void
		{
			me.GetBody().GetLinearVelocity().SetZero();
			
			if(FlxG.keys.A)
			{
				me.facing = FlxSprite.LEFT;
				me.GetBody().GetLinearVelocity().x = -10;
				me.play("run");
			}
			else if(FlxG.keys.D)
			{
				me.facing = FlxSprite.RIGHT;
				me.GetBody().GetLinearVelocity().x = 10;
				me.play("run");
			}
			else if(FlxG.keys.W){
				me.GetBody().GetLinearVelocity().y = -10;
				me.play("run");
			}
			else if(FlxG.keys.S){
				me.GetBody().GetLinearVelocity().y = 10;
				me.play("run");
			}
			else{	
				me.play("idle");
			}
		}
	}
}