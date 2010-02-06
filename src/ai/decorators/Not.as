package ai.decorators
{
	import ai.Task;
	import ai.blackboard.BlackBoard;

	public class Not extends Task
	{
		public function Not(task:Task=null)
		{
			super();
			if(task){
				subtasks.push(task);
			}
		}
		
		override public function run(bb:BlackBoard):uint{
			
			trace("running not");
			if(!subtasks || subtasks.length == 0)
				return e_succeeded;
			
			var task:Task = subtasks[0];
			
			return task.run(bb) == e_succeeded ? e_failed : e_succeeded;
		}
		
	}
}