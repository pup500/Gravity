package ailab.groups
{
	import ailab.Task;
	import ailab.TaskResult;
	
	public class PrioritizedTask extends GroupTask
	{
		public function PrioritizedTask()
		{
			super(false, true, TaskResult.SUCCEEDED);
			name = "Prioritized";
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("In " + name + " task");
			
			var activeTask:Task = active ? getCurrentSubtask() : null;
			active = true;
			
			//TODO:If we have decide, then we can terminate afterwards with comparisons
			if(activeTask){
				activeTask.terminate();
			}
			
			//TODO:We need like a decider function instead of run
			for(var i:uint = 0; i < _subtasks.length; i++){
				var task:Task = _subtasks[i] as Task;
				var result:TaskResult = task.run(bb);
				if(result === TaskResult.RUNNING){
					return result;
				}
				
				if(result === TaskResult.SUCCEEDED && succeedWhenSubtaskSucceed){
					active = false;
					return TaskResult.SUCCEEDED;
				}
				else if(result === TaskResult.FAILED && failWhenSubtaskFail){
					active = false;
					return TaskResult.FAILED;
				}
			}
			
			active = false;
			return resultWhenNoMoreSubtasks;
		}
	}
}