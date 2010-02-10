package ailab.conditions
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

	public class CanWalkForward extends Task
	{
		public function CanWalkForward()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("running can walk forward");
			
			//TODO:Maybe this needs to be split, one ray trace to detect ground
			//One ray trace to detect obstacles....
			
			/*
			if(bb.getObject("canWalkForward", false)){
				return e_succeeded;
			}
			else
				return e_failed;
			*/
			
			//if(detectObstacles(bb) == e_failed)
			//	return e_failed;
			
			return detectGround(bb);
		}
		
		private function detectGround(bb:BlackBoard):TaskResult{
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			var dir:int = me.facing == FlxSprite.RIGHT ? 1 : -1;
			
			var p1:b2Vec2 = me.GetBody().GetWorldPoint(new b2Vec2((me.width/2 + .1)/ExState.PHYS_SCALE * dir,(me.height/4) / ExState.PHYS_SCALE));
			var p2:b2Vec2 = me.GetBody().GetWorldPoint(new b2Vec2((me.width)/ExState.PHYS_SCALE * dir, (me.height/2)/ ExState.PHYS_SCALE));
				
			var state:ExState = FlxG.state as ExState;
			var f:b2Fixture = state.the_world.RayCastOne(p1, p2);
			
			var lambda:Number = 0;
			if (f)
			{
				var input:b2RayCastInput = new b2RayCastInput(p1, p2);
				var output:b2RayCastOutput = new b2RayCastOutput();
				f.RayCast(output, input);
				lambda = output.fraction;
			}
			
			trace(lambda);
			//TODO:Maybe we can see if lambda is close to 1
			//brain.blackboard.setObject("canWalkForward", lambda > .9); //f != null);
			
			//About .9 is when we detect the ground
			return (lambda > .9) ? TaskResult.SUCCEEDED : TaskResult.FAILED;
		}
		
		private function detectObstacles(bb:BlackBoard):TaskResult{
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			var dir:int = me.facing == FlxSprite.RIGHT ? 1 : -1;
			
			var p1:b2Vec2 = me.GetBody().GetWorldPoint(new b2Vec2((me.width/2 + .1)/ExState.PHYS_SCALE * dir,(me.height/4) / ExState.PHYS_SCALE));
			var p2:b2Vec2 = me.GetBody().GetWorldPoint(new b2Vec2((me.width)/ExState.PHYS_SCALE * dir, (me.height/4)/ ExState.PHYS_SCALE));
				
			var state:ExState = FlxG.state as ExState;
			var f:b2Fixture = state.the_world.RayCastOne(p1, p2);
			
			var lambda:Number = 0;
			if (f)
			{
				var input:b2RayCastInput = new b2RayCastInput(p1, p2);
				var output:b2RayCastOutput = new b2RayCastOutput();
				f.RayCast(output, input);
				lambda = output.fraction;
			}
			
			trace("detect obstacles: " + f);
			trace(lambda);
			//TODO:Maybe we can see if lambda is close to 1
			//brain.blackboard.setObject("canWalkForward", lambda > .9); //f != null);
			
			//About .9 is when we detect the ground
			return (f) ? TaskResult.FAILED : TaskResult.SUCCEEDED;
		}
	}
}