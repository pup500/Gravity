package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.overrides.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public dynamic class BulletArray extends Array
	{		
		public var _gravObjects:Array;
		public function get gravObjects():Array {
			return _gravObjects;
		}
		
		private var _physWorld:b2World;
		private var _state:ExState;
		
		public function BulletArray(state:ExState)
		{
			super();
			_gravObjects = new Array();
			
			_state = state;
		}
		
		public function createBullets(gravObjType:Class):void
		{
			//Create GravityObjects
			createGravityObjects(gravObjType)
			
			//Create bullets
			for(var i:uint = 0; i < 8; i++){
				var bullet:Bullet = new Bullet(_state.the_world);
				bullet.setGravityObject(_gravObjects[i]);
				this.push(_state.add(bullet));
				//don't create physical body, wait till bullet is shot.
			}
		}
		
		//TODO: This will change every bullet, even the ones that are in midair. Flag bullets for change and then change them when they're dead?
		public function setNewGravityObjects(gravObjType:Class):void
		{
			//Create GravityObjects
			createGravityObjects(gravObjType)
			
			for (var i:uint = 0; i < this.length; i++)
			{
				this[i].setGravityObject(_gravObjects[i]);
			}
		}
		
		private function createGravityObjects(gravObjType:Class):void
		{
			while (_gravObjects.length > 0)
			{
				_gravObjects.pop();
			}
			
			for (var i:uint = 0; i < 8; i++)
			{
				_gravObjects.push(_state.add(new gravObjType(_state.the_world)));
				//don't create physical body, wait till bullet is shot.
			}
		}
	}

}