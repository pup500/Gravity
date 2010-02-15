package ailab.groups
{
	import ailab.TaskResult;
	
	public class SequenceTask extends GroupTask
	{
		public function SequenceTask()
		{
			super(true, false, TaskResult.SUCCEEDED);
			name = "Sequence";
		}
	}
}