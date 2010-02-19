package ailab.conditions
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;

	public class CanJump extends Task
	{
		public function CanJump()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("running can jump");
			
			if(bb.getObject("canJump", false)){
				return TaskResult.SUCCEEDED;
			}
			else
				return TaskResult.FAILED;
		}
		
	}
}