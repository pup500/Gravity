package ai
{
	import ai.blackboard.BlackBoard;
	
	public class ParallelTask extends Task
	{
		public function ParallelTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			var result:uint = e_succeeded;
			
			trace("in parallel run");
			
			for each(var task:Task in subtasks){
				if(task.run(bb) == e_failed){
					result = e_failed;
				}
			}
			
			return result;
		}
	}
}