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
		
		protected var _active:Boolean;
		
		public function LerpEvent() 
		{
			super();
			
		}
		
		override public function startEvent():void
		{
			trace("START EVENT " + _args["movex"] + " "  + _args["movey"]);
			//var targetPoint:b2Vec2 = new b2Vec2(_args["x"],_args["y"]); 
			_time = _args["time"];
			
			//var state:ExState = FlxG.state as ExState;
			
			//_body = Utilities.GetBodyAtPoint( state.the_world, targetPoint);
			var move:b2Vec2 = new b2Vec2(_args["movex"]/ExState.PHYS_SCALE,_args["movey"]/ExState.PHYS_SCALE);
			target.GetBody().GetPosition().Add(move);//
			//target.GetBody().ApplyImpulse(move, target.GetBody().GetWorldCenter());
			//target.GetBody().SetActive(false);
		}
		
		override public function update():void
		{
		}
	}

}