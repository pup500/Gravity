package PhysicsGame.Wrappers
{
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.b2World;
	
	public class WorldWrapper
	{
		protected static var _world:b2World;
		protected static var _controller:b2Controller;
		
		public function WorldWrapper()
		{
		}
		
		public static function set the_world(world:b2World):void{
			_world = world;
		}
		
		public static function get the_world():b2World{
			return _world;
		}
		
		public static function set controller(controller:b2Controller):void{
			_controller = controller;
		}
		
		public static function get controller():b2Controller{
			return _controller;
		}
	}
}