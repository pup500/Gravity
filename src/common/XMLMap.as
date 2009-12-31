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
		private var _config:Array;
		private var _state:ExState;
		
		private var _start:Point;
		private var _end:Point;
		
		private var _undo:Array;
		
		private var _bodies:Array;
		private var number:uint;
		private var initialNumber:uint;
		private var _loaded:Boolean;
		
		public static const DISTANCE:uint = 0;
		public static const PRISMATIC:uint = 1;
		public static const REVOLUTE:uint = 2;
		
		public function XMLMap(state:ExState)
		{
			_state = state;	
			_config = new Array();
			_undo = new Array();
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
		    b2.pixels = bitmapData;
		    //b2.initShape();
		    b2.initShapeFromSprite();
			b2.createPhysBody(_state.the_world);
			if(shape.type == "static"){
				b2.final_body.SetStatic();
			}
			if(shape.angle != 0){
				b2.body.angle = shape.angle;
			}
			
			_state.add(b2);
			
			_undo.push(b2);
			
    		_config.push(shape);
    		
    		number++;
    		
    		//We need to add the joints....
    		//but can only do that after all bodies are loaded...
    		if(!_loaded && (number == initialNumber)){
    			_loaded = true;
    			addAllJoints();
	    		_state.init();
    		}
		}
		
		public function getConfiguration():String{
			var config:XML = new XML(<config/>);
			var shape:XML;
			var objects:XML = new XML(<objects/>);
			for(var i:uint = 0; i < _config.length; i++){
				shape = _config[i] as XML;
				objects.appendChild(shape);
			}
			
			var points:XML = new XML(<points/>);
			points.start.x = _start.x
			points.start.y = _start.y;
			points.end.x = _end.x;
			points.end.y = _end.y;
			
			//Create the config file as below
			config.appendChild(points);
			config.appendChild(objects);
			
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
		
		public function undo():void{
			var b2:ExSprite = _undo.pop();
			if(b2){
				b2.destroyPhysBody();
				b2.kill();	
				
				_config.pop();
				number--;
			}
		}
		
		public function setObjectTypeAtPoint(point:Point, includeStatic:Boolean=false, type:String="static"):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					var index:int = _undo.indexOf(bSprite);
					
					//TODO:This is a really bad way
					if(type == "static"){
						bSprite.final_body.SetStatic();
					}
					else{
						bSprite.final_body.SetMassFromShapes();
					}
					
					//Update the config settings
					var shape:XML = _config[index] as XML;
					shape.type = type;
				}
			}
		}
		
		public function removeObjectAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					var index:int = _undo.indexOf(bSprite);
					var removed:Array = _undo.splice(index,1);
					var rSprite:ExSprite = removed.pop();
					if(rSprite){
						rSprite.destroyPhysBody();
						rSprite.kill();
						
						_config.splice(index,1);
						number--;
					}
				}
			}
		}
		
		public function removeJointAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			if(b2){
				if(b2.GetUserData()){
					var sprite:ExSprite = b2.GetUserData();
					sprite.destroyAllJoints();
					
					//remove from config xml...
					var xml:XML;
					for(var i:uint = 0; i < _config.length; i++){
						xml = _config[i];
						
						//Find all xml elements of type joint...
						if(xml.name() == "joint"){
							var b3:b2Body = Utilities.GetBodyAtMouse(_state.the_world, new Point(xml.body1.x, xml.body1.y), includeStatic);
							var b4:b2Body = Utilities.GetBodyAtMouse(_state.the_world, new Point(xml.body2.x, xml.body2.y), includeStatic);
							
							//Remove the joint if it connects with the body
							if(b2 === b3 || b2 === b4){
								_config.splice(i,1);
								i--;
							}
						}
					}
				}
			}
		}
		
		//Make the AddJoint functions figure out the logic...
		public function registerObjectAtPoint(point:Point, includeStatic:Boolean=false, allowSameBody:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtMouse(_state.the_world, point, includeStatic);
			
			var vec:b2Vec2 = new b2Vec2();
			vec.x = point.x;
			vec.y = point.y;
			_bodies.push([b2,vec]);
				
			/*
			if(b2){
				if(!allowSameBody){
					for(var i:uint = 0; i < _bodies.length; i++){
						var bb:b2Body = _bodies[i][0];
						if(bb == b2){
							return;
						}
					}
				}
				var vec:b2Vec2 = new b2Vec2();
				vec.x = point.x;
				vec.y = point.y;
				_bodies.push([b2,vec]);
			}
			*/
		}
		
		private function addAllJoints():void{
			for each (var joint:XML in configXML.objects.joint){
				registerObjectAtPoint(new Point(joint.body1.x, joint.body1.y), true);
				registerObjectAtPoint(new Point(joint.body2.x, joint.body2.y), true);
				//Maybe depending on the config... we can use different functions
				addJoint(joint.type);
			}
		}
		
		public function addJoint(jointType:uint):void{
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
			case DISTANCE:
				result = addDistanceJoint(body1, body2, point1, point2);
				break;
			case PRISMATIC:
				result = addPrismaticJoint(body1, body2, point1, point2);
				break;
			case REVOLUTE:
				result = addRevoluteJoint(body1, body2, point1, point2);
				break;
			}
			
			if(result){
				addJointToConfig(jointType, point1, point2);
			}
			
			_bodies = new Array();
		}
		
		private function addDistanceJoint(body1:b2Body, body2:b2Body, point1:b2Vec2, point2:b2Vec2):Boolean{
			var joint:b2DistanceJointDef = new b2DistanceJointDef();
			
			if(body1 && body2 && body1 != body2){
				joint.Initialize(body1, body2, point1, point2);
				joint.collideConnected = true;
				_state.the_world.CreateJoint(joint);	
				return true;
			}
			
			return false;
		}
		
		private function addPrismaticJoint(body1:b2Body, body2:b2Body, point1:b2Vec2, point2:b2Vec2):Boolean{
			var joint:b2PrismaticJointDef = new b2PrismaticJointDef();
			
			//Always draw from static to nonstatic...
			//We might allow for body1 to be null, in which case, use world static body
			if(body2){
				var axis:b2Vec2 = new b2Vec2(point2.x, point2.y);
				axis.Subtract(point1);
				axis.Normalize();
				
				if(body1 == null || body1 === body2){
					body1 = _state.the_world.GetGroundBody();
				}
				
				joint.Initialize(body1, body2, point1 , axis);
				joint.enableMotor = true;
				joint.enableLimit = true;
				joint.maxMotorForce = 100 * body2.GetMass();
				joint.motorSpeed = 10;
				joint.upperTranslation = 50;
				joint.lowerTranslation = -50;
				joint.collideConnected = true;
				_state.the_world.CreateJoint(joint);	
				return true;
			}
			
			return false;
		}
		
		private function addRevoluteJoint(body1:b2Body, body2:b2Body, point1:b2Vec2, point2:b2Vec2):Boolean{
			var joint:b2RevoluteJointDef = new b2RevoluteJointDef();
			
			if(body2){
				if(body1 == null || body1 === body2){
					body1 = _state.the_world.GetGroundBody();
				}
				
				//Compute distance of the center point to the center of our main object
				var dist:b2Vec2 = new b2Vec2();
				dist.x = body2.GetWorldCenter().x;
				dist.y = body2.GetWorldCenter().x;
				dist.Subtract(point1);
				
				var distance:Number = dist.Length();
				
				joint.Initialize(body1, body2, point1);
				//joint.lowerAngle = 3.14/2; // -90 degrees
				//joint.upperAngle = 0.25 * 3.14; // 45 degrees
				//joint.enableLimit = true;
				trace(body2.GetMass());
				
				//The mass and distance has to be in so that longer distances will still work...
				joint.maxMotorTorque = 100.0 * body2.GetMass() * distance;
				joint.motorSpeed = 100;
				joint.enableMotor = true;

				_state.the_world.CreateJoint(joint);	
				return true;
			}
			
			return false;
		}
		
		private function addJointToConfig(jointType:uint, point1:b2Vec2, point2:b2Vec2):void{
			var xml:XML = new XML(<joint/>);
			xml.type = jointType;
			xml.body1.x = point1.x;
			xml.body1.y = point1.y;
			xml.body2.x = point2.x;
			xml.body2.y = point2.y;
			
			//We can add more customization here as to whatever fields we like...
			//Also, we might just have the update loop handle all joints and not have to worry about
			//having to do it in the body....
			_config.push(xml);
		}
		
		public function getItemCount():uint{
			return number;
		}
	}
}