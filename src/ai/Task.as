package ai
{
	import ai.blackboard.BlackBoard;
	
	public class Task
	{
		public static const e_succeeded:uint = 1;
		public static const e_failed:uint = 2;
		public static const e_running:uint = 3;
		
		protected var subtasks:Array;
		
		public function Task()
		{
			subtasks = new Array();
		}
		
		public function run(bb:BlackBoard):uint{
			trace("in task run");
			return e_succeeded;
		}
		
		public function addSubtask(task:Task):void{
			subtasks.push(task);
		}
	}
}