package ailab.conditions
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class IsFalling extends Task
	{
		public function IsFalling()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("running falling");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			trace("movement: " + me.GetBody().GetLinearVelocity().Length());
			
			if(me.GetBody().GetLinearVelocity().y < .2)
				return TaskResult.FAILED;
			else
				return TaskResult.SUCCEEDED;
		}
		
	}
}