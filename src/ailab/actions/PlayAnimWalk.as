package ailab.actions
{
	import ailab.Task;
	import ailab.TaskResult;
	import ailab.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class PlayAnimWalk extends Task
	{
		public function PlayAnimWalk()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):TaskResult{
			trace("in play walk anim task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return TaskResult.FAILED;
			
			me.play("run", false);
			
			return TaskResult.SUCCEEDED;
		}
	}
}