package ailab.actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class JumpTask extends Task
	{
		public function JumpTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in jump task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			//HACK to allow jumping to always succeed
			if(!bb.getObject("canJump", false)){
				return TaskResult.FAILED;
			}
			
			if(!me) return TaskResult.FAILED;
			
			bb.setObject("canJump", false);
			
			var _applyForce:b2Vec2 = new b2Vec2(0, -5);
			_applyForce.Multiply(me.GetBody().GetMass());
			
			me.GetBody().ApplyImpulse(_applyForce, me.GetBody().GetWorldCenter());
			me.play("jump", true);
			
			return TaskResult.SUCCEEDED;
		}
	}
}