package ailab.actions
{
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;
	import org.overrides.ExState;

	public class MoveTask extends Task
	{
		public function MoveTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in move task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			var _applyForce:b2Vec2 = bb.getObject("force", new b2Vec2(0,0)) as b2Vec2;
			
			me.GetBody().ApplyForce(_applyForce, me.GetBody().GetWorldCenter());
			
			return TaskResult.RUNNING;
		}
	}
}