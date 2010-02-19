package ailab
{
	public class TaskResult
	{
		public static var RUNNING:TaskResult = new TaskResult();
		public static var SUCCEEDED:TaskResult = new TaskResult();
		public static var FAILED:TaskResult = new TaskResult();
		
		public function TaskResult(){}
	}
}