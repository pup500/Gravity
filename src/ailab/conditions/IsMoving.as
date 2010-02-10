package ailab.conditions
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class IsMoving extends Task
	{
		public function IsMoving()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("Is moving?");
			
			//TODo:The problem is that movement picks up, so we can be turning incorrectly because
			//We don't give it the chance to turn....
			
			/*
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			trace("movement: " + me.GetBody().GetLinearVelocity().Length());
			
			if(me.GetBody().GetLinearVelocity().Length() < .01)
				return TaskResult.FAILED;
			else
				return TaskResult.SUCCEEDED;
			*/
			
			if(bb.getObject("moving", false)){
				return TaskResult.SUCCEEDED;
			}
			else
				return TaskResult.FAILED;
		}
		
	}
}