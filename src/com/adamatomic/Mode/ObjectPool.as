package com.adamatomic.Mode 
{
	import flash.events.Event;
	
	/**
	 * A basic memory pool, requires a no-arg constructor
	 * @author Steve Shipman
	 */
	public class ObjectPool
	{
		private var clazz:Class;
		private var inactiveInstances:Array;
		
		public function ObjectPool(c:Class) 
		{
			clazz = c;
			inactiveInstances = [];
		}
		
		/**
		 * get an instance of clazz appropriate to use.
		 * preferably gets from the inactive vector,
		 * but if that's empty it creates a new one.
		 * @return
		 */
		public function getObject():* {
			var instance:Object;
			if (inactiveInstances.length == 0) {
				instance = 	new clazz();
			}else {
				instance = inactiveInstances.shift();
			}
			return instance;
		}
		
		/**
		 * return the specified object to the inactiveInstances vector.
		 * does not do any checking for whether the object is still used.
		 * ONLY CALL THIS WHEN THE OBJECT IS REALLY INACTIVE.
		 * @param	obj
		 */
		public function returnObject(obj:Object):void {
			inactiveInstances.push(obj);
		}
		
		/**
		 * convenience listener for returning an object via an event dispatched from that object
		 * assumes that event.target is the object to return.
		 * @param	e
		 */
		public function returnObjectListener(e:Event):void {
			returnObject(e.target);
		}
		
	}

}