package ailab.basic
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;

	public class FailTask extends Task
	{
		public function FailTask()
		{
			super();
			name = "Fail";
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("Failed task");
			return TaskResult.FAILED;
		}
	}
}