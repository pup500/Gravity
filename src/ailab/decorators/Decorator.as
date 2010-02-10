package ailab.decorators
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;

	public class Decorator extends Task
	{
		protected var _subtask:Task;
		
		public function Decorator(task:Task)
		{
			super();
			_subtask = task;
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			return _subtask.run(bb);
		}
		
		override public function terminate():void{
			_subtask.terminate();
		}
		
	}
}