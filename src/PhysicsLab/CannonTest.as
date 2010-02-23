package PhysicsLab 
{
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	import org.flixel.*;

	import PhysicsGame.*;
	
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Common.b2internal;
	use namespace b2internal;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class CannonTest extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursor:Class;
		[Embed(source="../data/end_point.png")] private var endPoint:Class;
		
		[Embed(source = "../data/editor/images/blocks_2.jpg")] private var env1:Class;
		
		private var _bullets:Array;
		private var _gravObjects:Array;
		
		public function CannonTest() 
		{
			super();
			
			bgColor = 0xffeeeeff;
			controller = new GravityObjectController();
			the_world.AddController(controller);
			
			FlxG.showCursor(cursor);
			
			createBullets();
			loadPlayer();
			buildEnvironment();
			
			the_world.SetContactListener(new ContactListener());
		
		}
		
		public function loadPlayer():void
		{
			var p:Cannon = new Cannon(250, 370);
			p.SetBullets(_bullets);
			add(p);
		}
		
		public function buildEnvironment():void
		{
			var b:ExSprite = new ExSprite(200, 400, env1);
			b.initShape( b2Shape.e_polygonShape);
			b.createPhysBody(the_world);
			b.SetBodyType(b2Body.b2_staticBody)
			add(b);
			b = new ExSprite(400, 400, env1);
			b.initShape( b2Shape.e_polygonShape);
			b.createPhysBody(the_world);
			b.SetBodyType(b2Body.b2_staticBody)
			add(b);
		}
		
		private function createBullets():void {
			_bullets = new Array();
			_gravObjects = new Array();
			
			//Create GravityObjects
			for(var i:uint= 0; i < 8; i++){
				_gravObjects.push(this.add(new GravityObject(the_world)));
				//don't create physical body, wait till bullet is shot.
			}
			
			//Create bullets
			for(i = 0; i < 8; i++){
				var bullet:Bullet = new Bullet(the_world, controller);
				bullet.setGravityObject(_gravObjects[i]);
				_bullets.push(this.add(bullet));
				//don't create physical body, wait till bullet is shot.
			}
			
			//Add gravity object to controller so that it can step through them with all other objects
			var gController:GravityObjectController = controller as GravityObjectController;
			gController._gravObjects = _gravObjects;
			
		}
	}

}