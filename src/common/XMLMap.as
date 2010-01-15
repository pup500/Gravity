package common
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.b2Body;
	
	import PhysicsGame.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class XMLMap
	{	
		private var configXML:XML;
		private var _state:ExState;
		
		private var _start:Point;
		private var _end:Point;
		
		private var _bodies:Array;
		private var expBodyCount:uint;
		private var _loaded:Boolean;
		
		public function XMLMap(state:ExState)
		{
			_state = state;	
			_start = new Point();
			_end = new Point();
			
			_bodies = new Array();
			
			_loaded = false;
		}

		//Load the config file to set up world...
		public function loadConfigFile(file:String):void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadXMLConfigComplete);
			//loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(file));
		}
		
		//Actual callback function for load finish
		private function onLoadXMLConfigComplete(event:Event):void{
			configXML = new XML(event.target.data);
			
			//Save the start and end positions right away
			_start.x = configXML.points.start.x;
			_start.y = configXML.points.start.y;
			_end.x = configXML.points.end.x;
			_end.y = configXML.points.end.y;
			
			expBodyCount = getItemCount() + configXML.objects.shape.length();
			
			trace("initialnum: " + expBodyCount);
			trace("count:" + getItemCount());
			
			//If we have no bodies to load...
			if (expBodyCount == getItemCount()) {
				addAllEvents();
				if(!_loaded){
    				_loaded = true;
    				_state.init();
    				return;
    			}
			}
			
			for each(var shape:XML in configXML.objects.shape){
				addXMLObject(shape);
			}
			
			//Joints will be added after all objects have been created...
		}
		
		//Adds a XML file that contains the resource we want...
		public function addObjectsInXMLFile(file:String, offset:Point):void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, 
				function(e:Event):void{
					onAddObjectsInXMLComplete(e,offset)
				});
			//loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(file));
		}
		
		private function onAddObjectsInXMLComplete(event:Event, point:Point):void{
			configXML = new XML(event.target.data);
			
			//Save the body count so that we can check when we are done
			expBodyCount = getItemCount() + configXML.objects.shape.length();
			
			//Should we figure out a better way for offset...
			var shape:XML = configXML.objects.shape[0];
			var offset:Point = new Point();
			var min:Point = new Point(shape.x, shape.y);
			var max:Point = new Point(shape.x, shape.y);
			
			for each(shape in configXML.objects.shape){
				if(int(shape.x) < min.x) min.x = int(shape.x);
				if(int(shape.y) < min.y) min.y = int(shape.y);
				if(int(shape.x) > max.x) max.x = int(shape.x);
				if(int(shape.y) > max.y) max.y = int(shape.y);
			}
			
			//Offset is to make the midpoint of the whole object at the mouse coordinate
			offset.x = point.x - (min.x + max.x)/2;
			offset.y = point.y - (min.y + max.y)/2;
			
			//Or we can make offset at the top-left corner...
			//offset.x = point.x - min.x;
			//offset.y = point.y - min.y;
			
			
			for each(shape in configXML.objects.shape){
				shape.x = int(shape.x) + offset.x;
		    	shape.y = int(shape.y) + offset.y;
			}
			
			for each(var joint:XML in configXML.objects.joint){
				joint.body1.x = int(joint.body1.x) + offset.x;
		    	joint.body1.y = int(joint.body1.y) + offset.y;
		    	joint.body2.x = int(joint.body2.x) + offset.x;
		    	joint.body2.y = int(joint.body2.y) + offset.y;
		    	
		    	//Don't offset axis, that's a normalized vector...
		    	//joint.axis.x = int(joint.axis.x) + offset.x;
		    	//joint.axis.y = int(joint.axis.y) + offset.y;
		    	joint.anchor.x = int(joint.anchor.x) + offset.x;
		    	joint.anchor.y = int(joint.anchor.y) + offset.y;
			}
			
			for each(var eventXML:XML in configXML.objects.event){
				eventXML.x = int(eventXML.x) + offset.x;
		    	eventXML.y = int(eventXML.y) + offset.y;
		    	
		    	if(eventXML.target.x.length() > 0 && eventXML.target.y.length() > 0){
		    		eventXML.target.x = int(eventXML.target.x) + offset.x;
		    		eventXML.target.y = int(eventXML.target.y) + offset.y;
		    	}
			}
			
			for each(shape in configXML.objects.shape){
				addXMLObject(shape);
			}
		}

		//Load the xml config object at the specified coordinates
		public function addXMLObject(shape:XML, mouse:Boolean=false):void{
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
    			function(e:Event):void{
    				onComplete(e, shape, mouse)
    			});
    			
    		loader.load(new URLRequest(shape.file));
		}
		
		//Actual function that creates the sprite with the bitmap data
		private function onComplete(event:Event, shape:XML, mouse:Boolean=false):void
		{
			var loadinfo:LoaderInfo = LoaderInfo(event.target);
		    var bitmapData:BitmapData = Bitmap(loadinfo.content).bitmapData;
		    
		    if(mouse){
		    	//The mouse coordinate should be the x and y... but it always put the object at center
		    	//So we need this offset
		    	shape.x = int(shape.x) + bitmapData.width/2;
		    	shape.y = int(shape.y) + bitmapData.height/2;
		    }
		    
		    var b2:ExSprite = new ExSprite(shape.x, shape.y);
		    b2.name = "loaded";
		    b2.layer = shape.layer;
		    b2.imageResource = shape.file;
		    b2.pixels = bitmapData;
		    
		    trace(shape.polyshape);
		    if(shape.polyshape == "true")
		    	b2.initShapeFromSprite();
		    else
		    	b2.initCircleShape();
		    
		    //TODO:Make this better
		    //Objects in foreground or background should not interact with player
		    b2.shape.filter.categoryBits = shape.layer == ExState.MG ? 1 : 0;
		    
		    
		    //You have to put rotation first before you can create it...
		    if(shape.angle != 0){
				b2.body.angle = shape.angle;
			}
			
			b2.createPhysBody(_state.the_world);
			
			if(shape.isStatic == "true"){
				//b2.final_body.SetStatic();
			}
			
			_state.addToLayer(b2, shape.layer);
    		
    		//number++;
    		
    		trace("itemcount" + getItemCount());
    		trace("expbody" + expBodyCount);
    		//We need to add the joints....
    		//but can only do that after all bodies are loaded...
    		
    		if(getItemCount() == expBodyCount){
    			addAllJoints();
    			addAllEvents();
    			if(!_loaded){
    				_loaded = true;
    				_state.init();
    			}
    		}
		}
		
		//Create new configuration file
		public function createNewConfiguration():String{
			var config:XML = Utilities.CreateXMLRepresentation(_state.the_world);
			
			var points:XML = new XML(<points/>);
			points.start.x = _start.x
			points.start.y = _start.y;
			points.end.x = _end.x;
			points.end.y = _end.y;
			
			//Create the config file as below
			config.appendChild(points);
			
			return config.toXMLString();
		}
		
		
		public function setStartPoint(point:Point):void{
			_start = point;
		}
		
		public function setEndPoint(point:Point):void{
			_end = point;
		}
		
		public function getStartPoint():Point{
			return _start;
		}
		
		public function getEndPoint():Point{
			return _end;
		}
		
		public function setObjectTypeAtPoint(point:Point, includeStatic:Boolean=false, type:String="static"):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					//TODO:This is a really bad way
					if(type == "static"){
						bSprite.final_body.SetStatic();
					}
					else{
						bSprite.final_body.SetMassFromShapes();
					}
				}
			}
		}
		
		public function removeObjectAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.kill();
				}
			}
		}
		
		public function removeJointAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.destroyAllJoints();
				}
			}
		}
		
		//Registers a point and see if we get a body from it.  Null bodies will be checked during add joint
		public function registerObjectAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			var vec:b2Vec2 = new b2Vec2();
			vec.x = point.x;
			vec.y = point.y;
			_bodies.push([b2,vec]);
		}
		
		//Add all joints from configuration file, also pass configuration jointXML along
		private function addAllJoints():void{
			for each (var jointXML:XML in configXML.objects.joint){
				/*
				registerObjectAtPoint(new Point(jointXML.body1.x, jointXML.body1.y), true);
				registerObjectAtPoint(new Point(jointXML.body2.x, jointXML.body2.y), true);
				addJoint(jointXML.type, jointXML);
				*/
				jointXML.loaded = "true";
				JointFactory.addJoint(_state.the_world, jointXML);
			}
		}
		
		public function addJoint(args:Dictionary):void{
			JointFactory.addJoint(_state.the_world, JointFactory.createJointXML(args));
		}
		
		/*
		//Always make sure we have registered two points
		public function addJoint(jointType:uint, jointXML:XML=null):void{
			if(_bodies.length != 2){
				_bodies = new Array();
				return;
			}
			
			//Figure out all the bodies and points info
			var b1:Array = _bodies[0] as Array;
			var b2:Array = _bodies[1] as Array;
			
			var body1:b2Body = b1[0] as b2Body;
			var body2:b2Body = b2[0] as b2Body;
			
			var point1:b2Vec2 = b1[1];
			var point2:b2Vec2 = b2[1];
			
			//Switch to create different joint types
			var result:Boolean = false;
			switch(jointType){
			case Utilities.e_distanceJoint:
				result = addDistanceJoint(body1, body2, point1, point2, jointXML);
				break;
			case Utilities.e_prismaticJoint:
				result = addPrismaticJoint(body1, body2, point1, point2, jointXML);
				break;
			case Utilities.e_revoluteJoint:
				result = addRevoluteJoint(body1, body2, point1, point2, jointXML);
				break;
			}
			
			//Clear out bodies regardless of outcomes
			_bodies = new Array();
		}
		
		private function addDistanceJoint(body1:b2Body, body2:b2Body, point1:b2Vec2, point2:b2Vec2, jointXML:XML=null):Boolean{
			var joint:b2DistanceJointDef = new b2DistanceJointDef();
			
			if(body2){
				if(body1 == null || body1 == body2){
					//If body1 isn't found, use world ground body
					body1 = _state.the_world.GetGroundBody();
				}
				
				joint.Initialize(body1, body2, point1, point2);
				joint.collideConnected = true;
				_state.the_world.CreateJoint(joint);	
				return true;
			}
			
			return false;
		}
		
		private function addPrismaticJoint(body1:b2Body, body2:b2Body, point1:b2Vec2, point2:b2Vec2, jointXML:XML=null):Boolean{
			var joint:b2PrismaticJointDef = new b2PrismaticJointDef();
			
			//Always draw from static to nonstatic...
			if(body2){
				//Axis is currently set as the normalized vector from our two points
				var axis:b2Vec2 = new b2Vec2(point2.x, point2.y);
				axis.Subtract(point1);
				
				var anchor:b2Vec2 = new b2Vec2();
				
				if(body1 == null){
					//If body1 isn't found, use world ground body
					body1 = _state.the_world.GetGroundBody();
					
					//Also the anchor point should be where we placed the joint
					anchor.x = point1.x;
					anchor.y = point1.y;
				}else{
					//There's two bodies, we want the anchor point to be at the midpoint of the line we drew
					anchor.x = (point2.x + point1.x)/2;
					anchor.y = (point2.y + point1.y)/2;
				}
				
				//If we have xml data loaded from the config file, then use that
				//NO way to ensure correct values if the level was simulated....
				if(jointXML){
					axis.x = jointXML.axis.x;
					axis.y = jointXML.axis.y;
					
					anchor.x = jointXML.anchor.x;
					anchor.y = jointXML.anchor.y;
				}
				
				//Axis should be normalized
				axis.Normalize();
				
				//Initialize some sample values for now...
				joint.Initialize(body1, body2, anchor, axis);
				joint.enableMotor = true;
				joint.enableLimit = true;
				joint.maxMotorForce = 100 * body2.GetMass();
				joint.motorSpeed = 10;
				joint.upperTranslation = 50;
				joint.lowerTranslation = -50;
				joint.collideConnected = true;
				joint.userData = axis;
				_state.the_world.CreateJoint(joint);	
				return true;
			}
			
			return false;
		}
		
		private function addRevoluteJoint(body1:b2Body, body2:b2Body, point1:b2Vec2, point2:b2Vec2, jointXML:XML=null):Boolean{
			var joint:b2RevoluteJointDef = new b2RevoluteJointDef();
			
			if(body2){
				if(body1 == null || body1 === body2){
					body1 = _state.the_world.GetGroundBody();
				}
				
				var anchor:b2Vec2 = new b2Vec2();
				anchor.x = point1.x;
				anchor.y = point1.y;
				
				//Should we use body2 center?  This happens when we press and release inside one object
				if(body1 === body2){
					anchor.x = body2.GetWorldCenter().x;
					anchor.y = body2.GetWorldCenter().y;
				}
				
				//If we have xml data, use that
				if(jointXML){
					anchor.x = jointXML.anchor.x;
					anchor.y = jointXML.anchor.y;
				}
				
				//Compute distance of the center point to the center of our main object
				var dist:b2Vec2 = new b2Vec2();
				dist.x = body2.GetWorldCenter().x;
				dist.y = body2.GetWorldCenter().x;
				dist.Subtract(anchor);
				
				var distance:Number = dist.Length();
				
				joint.Initialize(body1, body2, anchor);
				//joint.lowerAngle = 3.14/2; // -90 degrees
				//joint.upperAngle = 0.25 * 3.14; // 45 degrees
				//joint.enableLimit = true;
				
				//The mass and distance has to be in so that longer distances will still work...
				joint.maxMotorTorque = 100.0 * body2.GetMass() * distance;
				joint.motorSpeed = 100;
				joint.enableMotor = true;

				_state.the_world.CreateJoint(joint);	
				return true;
			}
			
			return false;
		}
		
		*/
		
		//Add all joints from configuration file, also pass configuration jointXML along
		private function addAllEvents():void{
			for each (var eventXML:XML in configXML.objects.event){
				addXMLEvent(eventXML);
			}
		}
		
		public function addXMLEvent(event:XML, sprite:Class=null):void{
			//The synchronous time when adding objects that requires loading a bitmap will allow the object
			//to get updated before it renders
			//This doesn't work when there's no synchronous events... So this add takes place before the render...
			//Which means we have to worry about the updated sprite position... 
			
			var b2:EventObject = new EventObject(event.x, event.y, sprite, "", event.type);
		    b2.name = "event";
		    b2.layer = event.layer;
		    b2.imageResource = "";
		    b2._type = event.type;
		    
		    b2.initShape();
		    b2.shape.filter.categoryBits = 0;
		    
		    b2.createPhysBody(_state.the_world);
			
			b2.final_body.SetStatic();
			
			//Call this to fix position of object before render phase
			b2.update();
			
			trace("eventargetX:" + event.target.x + "," + event.target.y);
			if(event.target.x.length() > 0 && event.target.y.length() > 0){
				var tbody:b2Body = Utilities.GetBodyAtMouse(_state.the_world, new Point(event.target.x, event.target.y), true);
				b2.setTarget(tbody.GetUserData());
			}
			
			_state.addToLayer(b2, ExState.EV);
		}
		
		public function addXMLSensor(sensorXML:XML, sprite:Class = null):void {
			var sensor:Sensor = new Sensor(sensorXML.x, sensorXML.y, sensorXML.width, sensorXML.height);
			sensor.loadGraphic(sprite);
			sensor.createPhysBody(_state.the_world);
			_state.addToLayer(sensor, ExState.EV);
		}
		
		public function addEventTarget():void{
			if(_bodies.length != 2){
				_bodies = new Array();
				return;
			}
			
			//Figure out all the bodies and points info
			var b1:Array = _bodies[0] as Array;
			var b2:Array = _bodies[1] as Array;
			
			var body1:b2Body = b1[0] as b2Body;
			var body2:b2Body = b2[0] as b2Body;
			
			var point1:b2Vec2 = b1[1];
			var point2:b2Vec2 = b2[1];
			
			_bodies = new Array();
			
			if(!body1 || !body2) return;
				
			if(!(body1.GetUserData() is EventObject)) {
				return;
			}
			
			if(!(body2.GetUserData() is ExSprite)) {
				return;
			}
			
			//This only happens if we select an event and link it to the target
			var event:EventObject = body1.GetUserData();
			var target:ExSprite = body2.GetUserData();
			
			event.setTarget(target);
		}
		
		public function getItemCount():uint{
			return _state.the_world.GetBodyCount();
		}
	}
}