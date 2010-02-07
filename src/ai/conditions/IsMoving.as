package ai.conditions
{
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class IsMoving extends Task
	{
		public function IsMoving()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("running moving");
			
			//TODo:The problem is that movement picks up, so we can be turning incorrectly because
			//We don't give it the chance to turn....
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return e_failed;
			
			trace("movement: " + me.GetBody().GetLinearVelocity().Length());
			
			if(me.GetBody().GetLinearVelocity().Length() < .01)
				return e_failed;
			else
				return e_succeeded;
		}
		
	}
}