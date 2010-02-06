package ai.conditions
{
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class CanWalkForward extends Task
	{
		public function CanWalkForward()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("running can jump");
			
			if(bb.getObject("canWalkForward", false)){
				return e_succeeded;
			}
			else
				return e_failed;
		}
		
	}
}