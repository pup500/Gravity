package ai.conditions
{
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class CanJump extends Task
	{
		public function CanJump()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("running can jump");
			
			if(bb.getObject("canJump", false)){
				return e_succeeded;
			}
			else
				return e_failed;
		}
		
	}
}