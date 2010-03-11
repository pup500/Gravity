package PhysicsGame.Components
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	
	public class AnimationComponent implements IComponent
	{
		protected var me:ExSprite;
		
		public function AnimationComponent(obj:ExSprite)
		{
			me = obj;
		}

		public function update():void
		{
			//ANIMATION
			if(Math.abs(me.GetBody().GetLinearVelocity().y) > 0.1)
			{
				me.play("jump");
				
				//if(_up) play("jump_up");
				//else if(_down) play("jump_down");
				//else play("jump");
				////trace("jumping");
			}
			else if(Math.abs(me.GetBody().GetLinearVelocity().x) < 0.1)
			{
				me.play("idle");
				//if(_up) play("idle_up");
				//else play("idle");
			}
			else
			{
				//if(_up) play("run_up");
				
				//TODO:This might be counter to inputcomponent, so have to worry about this
				//Whether this should be in animation or in inputcomponent
				if(FlxG.keys.A || FlxG.keys.D)
					me.play("run");
				else
					me.play("idle");
			}
		}
		
		public function receive(args:Object):Boolean{
			return false;
		}
	}
}