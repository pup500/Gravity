package ai
{
	import ai.blackboard.BlackBoard;
	
	public class SelectorTask extends Task
	{
		public function SelectorTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			
			trace("in selector run");
			
			for each(var task:Task in subtasks){
				if(task.run(bb) == e_succeeded){
					return e_succeeded;
				}
			}
			
			return e_failed;
		}
	}
}