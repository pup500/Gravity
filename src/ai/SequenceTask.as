package ai
{
	import ai.blackboard.BlackBoard;
	
	public class SequenceTask extends Task
	{
		public function SequenceTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			
			trace("in sequence run");
			
			for each(var task:Task in subtasks){
				if(task.run(bb) == e_failed){
					return e_failed;
				}
			}
			
			return e_succeeded;
		}
	}
}