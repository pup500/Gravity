package ai.actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;

	public class TurnTask extends Task
	{
		public function TurnTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("in turn task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return e_failed;
			
			var _applyForce:b2Vec2 = bb.getObject("force", new b2Vec2(2,0)) as b2Vec2;
			_applyForce.x *= -1;
			bb.setObject("force", _applyForce);
			
			me.facing = _applyForce.x > 0 ? FlxSprite.RIGHT : FlxSprite.LEFT;
			
			return e_succeeded;
		}
	}
}