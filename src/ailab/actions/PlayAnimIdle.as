package ailab.actions
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class PlayAnimIdle extends Task
	{
		public function PlayAnimIdle()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in play idle anim task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			me.play("idle", false);
			
			return TaskResult.SUCCEEDED;
		}
	}
}