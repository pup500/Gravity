package PhysicsGame.Events 
{
	import PhysicsGame.Events.EventBase;
	
	import common.Utilities;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	import Box2D.Common.Math.b2Vec2
	import Box2D.Dynamics.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class LerpEvent extends EventBase
	{
		protected var _time:Number;
		protected var _body:b2Body;
		public function LerpEvent() 
		{
			super();
			
		}
		
		override public function startEvent():void
		{
			//var targetPoint:b2Vec2 = new b2Vec2(_args["x"],_args["y"]); 
			_time = _args["time"];
			
			var state:ExState = FlxG.state as ExState;
			
			if(target){
				var force:b2Vec2 = new b2Vec2(0,-10);//_args["forcex"],_args["forcey"]);
				force.Multiply(target.GetBody().GetMass());
				target.GetBody().ApplyImpulse(force, target.GetBody().GetWorldCenter());
			}
			
			//_body = Utilities.GetBodyAtPoint( state.the_world, targetPoint);
			//var force:b2Vec2 = new b2Vec2(_args["forcex"],_args["forcey"]);
			//_body.ApplyImpulse(force, _body.GetWorldCenter());
		}
		
		override public function update():void
		{
		}
	}

}