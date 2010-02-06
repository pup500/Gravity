package ai.actions
{
	import Box2D.Common.Math.b2Vec2;
	
	import ai.Task;
	import ai.blackboard.BlackBoard;
	
	import org.overrides.ExSprite;

	public class StopTask extends Task
	{
		public function StopTask()
		{
			super();
		}
		
		override public function run(bb:BlackBoard):uint{
			trace("in walk task");
			
			var me:ExSprite = bb.getObject("me", null) as ExSprite;
			
			if(!me) return e_failed;
			
			//var _applyForce:b2Vec2 = bb.getObject("force", new b2Vec2(0,0)) as b2Vec2;
			
			//trace("force: " + _applyForce.x + "," + _applyForce.y);
			
			//if(Math.abs(me.GetBody().GetLinearVelocity().x) > 2.5) {
				//return e_failed;
			//}
			
			var vel:b2Vec2 = me.GetBody().GetLinearVelocity();
			vel.x = 0;
			me.GetBody().SetLinearVelocity(vel);
			//.ApplyForce(_applyForce, me.GetBody().GetWorldCenter());
			//me.play("run", false);
			
			//TODO: Fix this random hack
			return e_succeeded;//(Math.random() < .9) ? e_succeeded : e_failed;
			//
			//return e_succeeded;
		}
	}
}