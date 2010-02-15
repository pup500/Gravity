package ailab.groups
{
	import ailab.TaskResult;
	
	public class SelectorTask extends GroupTask
	{
		public function SelectorTask()
		{
			super(false, true, TaskResult.FAILED);
			name = "Selector";
		}
	}
}