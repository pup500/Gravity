package ailab.groups
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	public class GroupTask extends Task
	{
		private var currentIndex:int;
		
		protected var _subtasks:Array;
		
		private var failWhenSubtaskFail:Boolean;
		private var succeedWhenSubtaskSucceed:Boolean;
		private var resultWhenNoMoreSubtasks:TaskResult;
		
		public function GroupTask(fwsf:Boolean, swss:Boolean, rwnms:TaskResult)
		{
			super();
			_subtasks = new Array();
			currentIndex = -1;
			
			failWhenSubtaskFail = fwsf;
			succeedWhenSubtaskSucceed = swss;
			resultWhenNoMoreSubtasks = rwnms;
		}
		
		override public function addSubtask(task:Task):void{
			if(active)
				throw new Error("Can't add subtask to active task.");
			
			_subtasks.push(task);
		}
		
		protected function getFirstSubtask():Task{
			if(_subtasks.length <= 0)
				return null;
		
			currentIndex = 0;
			return _subtasks[0] as Task;
		}
		
		protected function getCurrentSubtask():Task{
			if(currentIndex < 0 || currentIndex >= _subtasks.length)
				return null;
				
			return _subtasks[currentIndex] as Task;
		}
		
		protected function getNextSubtask():Task{
			if(currentIndex >= _subtasks.length - 1)
				return null;
				
			currentIndex++;
			return _subtasks[currentIndex] as Task;
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("In " + name + " task");
			
			var task:Task = active ? getCurrentSubtask() : getFirstSubtask();
			active = true;
			
			if(task){
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
				
				task = getNextSubtask();
			}
			
			//Determine if we are done with all subtasks
			if(!task){
				active = false;
				return resultWhenNoMoreSubtasks;
			}
			
			return TaskResult.RUNNING;
		}
		
		override public function terminate():void{
			if(active){
				for each(var task:Task in _subtasks){
					task.terminate();
				}
				active = false;
			}
		}
	}
}