package ailab.groups
{
	import ailab.Task;
	import ailab.TaskResult;
	
	public class RandomTask extends GroupTask
	{
		public function RandomTask()
		{
			super(true, true, TaskResult.SUCCEEDED);
			name = "Random";
		}
		
		override protected function getFirstSubtask():Task{
			return getRandomSubtask();
		}
		
		override protected function getNextSubtask():Task{
			return getRandomSubtask();
		}
		
		protected function getRandomSubtask():Task{
			if(_subtasks.length <= 0)
				return null;
		
			currentIndex = Math.random() * _subtasks.length;
			return _subtasks[currentIndex] as Task;
		}
	}
}