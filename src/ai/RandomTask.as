package ai
{
	import ai.blackboard.BlackBoard;
	
	public class RandomTask extends Task
	{
		public function RandomTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			if(!subtasks || subtasks.length == 0)
				return e_succeeded;
			
			trace("in random run");
			
			var index:uint = Math.floor(Math.random() * subtasks.length);
			trace("index from " + subtasks.length + " is " + index);
			var task:Task = subtasks[index];
			
			return task.run(bb);
		}
	}
}