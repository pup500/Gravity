package ai.actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class PlayAnimWalk extends Task
	{
		public function PlayAnimWalk()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("in play walk anim task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return e_failed;
			
			me.play("run", false);
			
			return e_succeeded;
		}
	}
}