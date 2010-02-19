package ailab.decorators
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.flixel.FlxG;

	public class TimeOut extends Decorator
	{
		protected var _time:Number;
		protected var result:TaskResult;
		protected var _elapsed:Number;
		protected var _timeOutResult:TaskResult;
		
		public function TimeOut(task:Task, time:Number=0, timeOutResult:TaskResult=null)
		{
			super(task);
			name = "Time out";
			_time = time;
			_timeOutResult = timeOutResult ? timeOutResult : TaskResult.FAILED;
			
			_elapsed = 0;
		}
		
		//Run the task until success or failure, otherwise time out after time with timeoutresult
		override public function run(bb:BlackBoard):TaskResult{
			trace("in time task");
			result = super.run(bb);
			
			if(!(result === TaskResult.RUNNING)){
				_elapsed = 0;
				return result;
			}
						
			_elapsed += FlxG.elapsed;
			trace("elapsed: " + _elapsed);
			
			if(_time != 0 && _elapsed >= _time){
				_elapsed = 0;
				trace("subtask timed out");
				terminate();
				return _timeOutResult;
			}
			
			trace("subtask still running.");
			return TaskResult.RUNNING;
		}
	}
}