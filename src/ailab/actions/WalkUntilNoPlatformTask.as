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

	public class WalkUntilNoPlatformTask extends Task
	{
		public function WalkUntilNoPlatformTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in walk until no platform task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			var _applyForce:b2Vec2 = bb.getObject("force", new b2Vec2(0,0)) as b2Vec2;
			
			trace("forward force" + _applyForce.x + ", " + _applyForce.y);
			
			
			me.GetBody().ApplyForce(_applyForce, me.GetBody().GetWorldCenter());
			
			me.rayTrace();
			
			trace("is ground forward? " + me.isGroundForward());
			
			//TODO:Probably make into different types of walk behaviors
			
			//If I am blocked forward, then stop walking
			//Thus, if there's jump after this task, it will jump if it is stopped by something ahead
			//return me.isBlockedForward() ? TaskResult.FAILED : TaskResult.RUNNING;
			
			//If there's anything ahead of me, including the ground then stop walking
			//return me.isAnythingForward() ? TaskResult.FAILED : TaskResult.RUNNING;
			
			//If there is no ground ahead of me, then stop walking
			//This would allow for jumping away from platforms
			return !me.isGroundForward() ? TaskResult.FAILED : TaskResult.RUNNING;
		}
	}
}