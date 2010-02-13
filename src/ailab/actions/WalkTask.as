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

	public class WalkTask extends Task
	{
		private var moving:Number;
		
		public function WalkTask()
		{
			super();
			moving = 0;
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in walk task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			//If i'm already walking and I am not moving fast... I amd probably stuck
			//TODO:Cleanup this hack
			/*
			if(bb.getObject("walking")){
				if(Math.abs(me.GetBody().GetLinearVelocity().x) < .01) {
					return TaskResult.FAILED;
				}
			}*/
			
			var _applyForce:b2Vec2 = bb.getObject("force", new b2Vec2(0,0)) as b2Vec2;
			
			//trace("force: " + _applyForce.x + "," + _applyForce.y);
			
			/*
			if(Math.abs(me.GetBody().GetLinearVelocity().x) > 2.5) {
				return TaskResult.SUCCEEDED;
			}*/
			
			me.GetBody().ApplyForce(_applyForce, me.GetBody().GetWorldCenter());
			moving++;
			
			//HACK!!!!!
			/*
			if(moving > 100){
				moving = 0;
				return TaskResult.FAILED;
			}*/
			
			//bb.setObject("walking", true);
			//me.play("run", false);
			
			//TODO: Fix this random hack
			
			//TaskResult.RUNNING here is bad, but we need something..
			//THIS IS BAD Because sometimes we can't move... and this will just loop forever because
			//We can't get to enough speed to go to succeed
			return detectObstacles(bb);//TaskResult.SUCCEEDED;//.RUNNING;
			//return TaskResult.RUNNING;//(Math.random() < .9) ? e_succeeded : e_failed;
			//
			//return e_succeeded;
		}
		
		private function detectObstacles(bb:BlackBoard):TaskResult{
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			var dir:int = me.facing == FlxSprite.RIGHT ? 1 : -1;
			
			var p1:b2Vec2 = me.GetBody().GetWorldPoint(new b2Vec2((me.width/2 -2)/ExState.PHYS_SCALE * dir,(me.height/4) / ExState.PHYS_SCALE));
			var p2:b2Vec2 = me.GetBody().GetWorldPoint(new b2Vec2((me.width)/ExState.PHYS_SCALE * dir, (me.height/2+2)/ ExState.PHYS_SCALE));
				
			var state:ExState = FlxG.state as ExState;
			
			var f:b2Fixture = null;
			var lambda:Number = 1;
			
			function castFunction(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number
			{
				if(fraction < lambda){
					f = fixture;
					lambda = fraction;
				}
				//lambda = lambda < fraction ? lambda : fraction;
				return fraction;
			}
			
			state.the_world.RayCast(castFunction, p1, p2);
			
			/*
			if (f)
			{
				var input:b2RayCastInput = new b2RayCastInput(p1, p2);
				var output:b2RayCastOutput = new b2RayCastOutput();
				f.RayCast(output, input);
				lambda = output.fraction;
			}
			*/
			
			//trace(lambda);
			//TODO:Maybe we can see if lambda is close to 1
			//brain.blackboard.setObject("canWalkForward", lambda > .9); //f != null);
			
			//About .9 is when we detect the ground
			return (f && lambda > .7) ? TaskResult.RUNNING : TaskResult.FAILED;
		}
	}
}