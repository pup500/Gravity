package ailab.basic
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;

	public class SucceedTask extends Task
	{
		public function SucceedTask()
		{
			super();
			name = "Succeed";
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("Succeed task");
			return TaskResult.SUCCEEDED;
		}
	}
}