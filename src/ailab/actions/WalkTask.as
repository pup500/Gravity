package ailab.actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

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
			
			trace("force: " + _applyForce.x + "," + _applyForce.y);
			
			if(Math.abs(me.GetBody().GetLinearVelocity().x) > 2.5) {
				return TaskResult.SUCCEEDED;
			}
			
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
			return TaskResult.RUNNING;//(Math.random() < .9) ? e_succeeded : e_failed;
			//
			//return e_succeeded;
		}
	}
}