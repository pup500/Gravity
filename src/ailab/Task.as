package ailab
{
	import ailab.blackboard.BlackBoard;
	
	public class Task
	{
		public var name:String;
		
		protected var active:Boolean;
		
		public function Task()
		{
			active = false;
			name = "Task";
		}
		
		public function decide():Boolean{
			return true;
		}
		
		public function addSubtask(task:Task):void{
			throw new Error("Can't add subtasks to a non-group task.");
		}
		
		public function run(bb:BlackBoard):TaskResult{
			trace("In " + name + " run ");
			
			active = true;
			return TaskResult.RUNNING;
		}
		
		public function terminate():void{
			active = false;
		}
	}
}