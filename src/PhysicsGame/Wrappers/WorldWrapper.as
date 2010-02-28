package PhysicsGame.Wrappers
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.b2World;
	
	public class WorldWrapper
	{
		protected var _world:b2World;
		protected var _controller:b2Controller;
		
		public function WorldWrapper()
		{
			var gravity:b2Vec2 = new b2Vec2(0.0, 10);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			_world = new b2World(gravity, doSleep);
			_world.SetWarmStarting(true);
		}
		
		public function get the_world():b2World{
			return _world;
		}
		
		public function set controller(controller:b2Controller):void{
			_controller = controller;
		}
		
		public function get controller():b2Controller{
			return _controller;
		}
	}
}