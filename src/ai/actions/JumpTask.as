package ai.actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class JumpTask extends Task
	{
		public function JumpTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("in jump task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!bb.getObject("canJump", false)){
				return e_failed;
			}
			
			if(!me) return e_failed;
			
			bb.setObject("canJump", false);
			
			var _applyForce:b2Vec2 = new b2Vec2(0, -5);
			_applyForce.Multiply(me.GetBody().GetMass());
			
			me.GetBody().ApplyImpulse(_applyForce, me.GetBody().GetWorldCenter());
			me.play("jump", true);
			
			return e_succeeded;
		}
	}
}