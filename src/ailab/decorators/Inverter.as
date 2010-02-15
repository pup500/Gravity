package ailab.decorators
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;

	public class Inverter extends Decorator
	{
		
		public function Inverter(task:Task=null)
		{
			super(task);
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in inverter");
			
			var result:TaskResult = _subtask.run(bb);
			if(result === TaskResult.FAILED)
				return TaskResult.SUCCEEDED;
			else if(result === TaskResult.SUCCEEDED)
				return TaskResult.FAILED;
			return TaskResult.RUNNING;
		}	
	}
}