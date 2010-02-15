package ailab.groups
{
	import ailab.Task;
	
	public class RandomTask extends SelectorTask
	{
		public function RandomTask()
		{
			super();
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