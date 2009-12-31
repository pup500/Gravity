package common
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class XMLMap
	{
		private var configXML:XML;
		//private var _config:Array;
		private var _state:ExState;
		
		private var _start:Point;
		private var _end:Point;
		
		//private var _undo:Array;
		
		private var _bodies:Array;
		private var number:uint;
		private var initialNumber:uint;
		private var _loaded:Boolean;
		
		public function XMLMap(state:ExState)
		{
			_state = state;	
			_start = new Point();
			_end = new Point();
			
			_bodies = new Array();
			
			number = 0;
			initialNumber = 0;
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
			
			initialNumber = configXML.objects.shape.length();
			
			for each(var shape:XML in configXML.objects.shape){
				addXMLObject(shape);
			}
			
			//Joints will be added after all objects have been created...
			
			_start.x = configXML.points.start.x;
			_start.y = configXML.points.start.y;
			_end.x = configXML.points.end.x;
			_end.y = configXML.points.end.y;
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
		    b2.imageResource = shape.file;
		    b2.pixels = bitmapData;
		    //b2.initShape();
		    b2.initShapeFromSprite();
			b2.createPhysBody(_state.the_world);
			
			if(shape.isStatic == "true"){
				b2.final_body.SetStatic();
			}
			
			/*
			if(shape.type == "static"){
				b2.final_body.SetStatic();
			}*/
			
			if(shape.angle != 0){
				b2.body.angle = shape.angle;
			}
			
			_state.add(b2);
    		
    		number++;
    		
    		//We need to add the joints....
    		//but can only do that after all bodies are loaded...
    		if(!_loaded && (number == initialNumber)){
    			_loaded = true;
    			addAllJoints();
	    		_state.init();
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
					bSprite.destroyPhysBody();
					bSprite.kill();
						
					number--;
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
		public function registerObjectAtPoint(point:Point, includeStatic:Boolean=false, allowSameBody:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			var vec:b2Vec2 = new b2Vec2();
			vec.x = point.x;
			vec.y = point.y;
			_bodies.push([b2,vec]);
		}
		
		//Add all joints from configuration file, also pass configuration jointXML along
		private function addAllJoints():void{
			for each (var jointXML:XML in configXML.objects.joint){
				registerObjectAtPoint(new Point(jointXML.body1.x, jointXML.body1.y), true);
				registerObjectAtPoint(new Point(jointXML.body2.x, jointXML.body2.y), true);
				addJoint(jointXML.type, jointXML);
			}
		}
		
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
			
			if(body1 && body2 && body1 != body2){
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
				axis.Normalize();
				
				var anchor:b2Vec2 = new b2Vec2();
				
				if(body1 == null){
					//If body1 isn't found, use world ground body
					body1 = _state.the_world.GetGroundBody();
					
					//Also the anchor point should be where we placed the joint
					anchor.x = point1.x;
					anchor.y = point1.y;
				}else{
					//There's two bodies, we want the anchor point to be at the midpoint of the line we drew
					anchor.x = (point2.x - point1.x)/2 + point1.x;
					anchor.y = (point2.y - point1.y)/2 + point1.y;
				}
				
				//If we have xml data loaded from the config file, then use that
				//NO way to ensure correct values if the level was simulated....
				if(jointXML){
					axis.x = jointXML.axis.x;
					axis.y = jointXML.axis.y;
					
					anchor.x = jointXML.anchor.x;
					anchor.y = jointXML.anchor.y;
				}
				
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
		
		public function getItemCount():uint{
			return number;
		}
	}
}