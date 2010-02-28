package PhysicsGame.Wrappers
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import org.flixel.FlxG;
	
	public class WorldWrapper
	{
		protected static var _world:b2World;
		protected static var _controller:b2Controller;
		
		public function WorldWrapper()
		{
		}
		
		public static function update():void{
			if(_world){
				_world.Step(FlxG.elapsed, 10, 10);
				_world.ClearForces();
			}
		}
		
		public static function setDebugDraw(debug_draw:b2DebugDraw):void{
			_world.SetDebugDraw(debug_draw);
		}
		
		public static function render():void{
			_world.DrawDebugData();
		}
		
		public static function setGravity(gravity:b2Vec2):void{
			_world.SetGravity(gravity);
		}
		
		public static function addBody(bodyDef:b2BodyDef):b2Body{
			var body:b2Body = null;
			
			if(_world){
				body = _world.CreateBody(bodyDef);

				if(controller){
					controller.AddBody(body);
				}
			}
			
			return body;
		}
		
		public static function createJoint(def:b2JointDef):void{
			_world.CreateJoint(def);
		}
		
		public static function destroyPhysBody(body:b2Body):b2Body{
			if(!body)
				return null;
			
			if(controller){
				controller.RemoveBody(body);
			}
			
			if(_world){
				_world.DestroyBody(body);
			}
			
			return null;
		}
		
		public static function destroyAllJoints(body:b2Body):void{
			var joints:b2JointEdge;
			while(joints = body.GetJointList()){
				_world.DestroyJoint(joints.joint);
			}
		}
		
		public static function setContactListener(cl:b2ContactListener):void{
			_world.SetContactListener(cl);
		}
		
		public static function setAllAwake(awake:Boolean):void{
			var bb:b2Body;
			for (bb = _world.GetBodyList(); bb; bb = bb.GetNext()) {
				if(bb.GetType() == b2Body.b2_dynamicBody)
					bb.SetAwake(awake);
			}
		}
		
		/*
		public static function GetBodyAtPoint(_p:b2Vec2, includeStatic:Boolean = false):b2Body{
			if(!_p) return null;
			
			var body:b2Body;
			var p:b2Vec2 = new b2Vec2(_p.x, _p.y);
			
			//trace("original p" + p.x + "," + p.y);
			p.Multiply(1/ExState.PHYS_SCALE);
			//trace("p" + p.x + "," + p.y);
			
			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					body = fixture.GetBody();
					return false
				}
				return true;
			}
			
			_world.QueryPoint(GetBodyCallback, p);
			
			return body;
		}
		*/
		
		public static function getBodyCount():uint{
			return _world.GetBodyCount();
		}
		
		public static function queryPoint(GetBodyCallback:Function, p:b2Vec2):void{
			_world.QueryPoint(GetBodyCallback, p);
		}
		
		public static function getBodyList():b2Body{
			return _world.GetBodyList();
		}
		
		public static function getJointList():b2Joint{
			return _world.GetJointList();
		}
		
		public static function getGroundBody():b2Body{
			return _world.GetGroundBody();
		}
		
		public static function rayCast(castFunction:Function, p1:b2Vec2, p2:b2Vec2):void{
			_world.RayCast(castFunction, p1, p2);
		}
		
		//Getters and Setters
		public static function set the_world(world:b2World):void{
			_world = world;
		}
		
		/*
		public static function get the_world():b2World{
			return _world;
		}
		*/
		
		public static function set controller(controller:b2Controller):void{
			_controller = controller;
			_world.AddController(_controller);
		}
		
		public static function get controller():b2Controller{
			return _controller;
		}
	}
}