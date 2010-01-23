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
		
		private var expBodyCount:uint;
		private var _loaded:Boolean;
		
		public function XMLMap(state:ExState)
		{
			_state = state;	
			_start = new Point();
			_end = new Point();
			
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
			
			/*
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
			*/
			
			for each(var shape:XML in configXML.objects.shape){
				 var b2:ExSprite = new ExSprite();
		    	b2.initFromXML(shape, _state.the_world, _state.getController());
		    	_state.addToLayer(b2, shape.layer);
			}
			
			//_state.init();
			
			//Joints will be added after all objects have been created...
		}
		
		public function update():void{
			if(_loaded)
				return;
				
			if (expBodyCount == getItemCount()) {
				addAllEvents();
				addAllJoints();
				_loaded = true;
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
		
		
		//public function setObjectTypeAtPoint(point:Point, includeStatic:Boolean=false, type:String="static"):void{
			/*
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
			*/
		//}
		
		/*
		public function removeObjectAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtPoint(_state.the_world, new b2Vec2(point.x, point.y), includeStatic);
			
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.kill();
				}
			}
		}
		
		public function removeJointAtPoint(point:Point, includeStatic:Boolean=false):void{
			var b2:b2Body = Utilities.GetBodyAtPoint(_state.the_world, new b2Vec2(point.x, point.y), includeStatic);
			
			if(b2){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.destroyAllJoints();
				}
			}
		}
		*/
		
		//Add all joints from configuration file, also pass configuration jointXML along
		private function addAllJoints():void{
			for each (var jointXML:XML in configXML.objects.joint){
				jointXML.loaded = "true";
				JointFactory.addJoint(_state.the_world, jointXML);
			}
		}
		
		public function addJoint(args:Dictionary):void{
			JointFactory.addJoint(_state.the_world, JointFactory.createJointXML(args));
		}
		
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
			
			var b2:EventObject = new EventObject();
			b2.initFromXML(event, _state.the_world);
			//b2.createPhysBody(_state.the_world);
		    
			_state.addToLayer(b2, ExState.EV);
		}
		
		public function addXMLSensor(sensorXML:XML, sprite:Class = null):void {
			//TODO:Fix sensor...
			var sensor:Sensor = new Sensor();
			//sensorXML.x, sensorXML.y, sensorXML.width, sensorXML.height);
			sensor.loadGraphic(sprite);
			sensor.initFromXML(sensorXML, _state.the_world);
			//sensor.createPhysBody(_state.the_world);
			_state.addToLayer(sensor, ExState.EV);
		}
		
		/*
		public function addEventTarget(args:Dictionary):void{
			var body1:b2Body = Utilities.GetBodyAtPoint(_state.the_world, args["start"], true);
			var body2:b2Body = Utilities.GetBodyAtPoint(_state.the_world, args["end"], true);
			
			if(body1){
				if(body1.GetUserData() && body1.GetUserData() is EventObject){
					//This only happens if we select an event and link it to the target
					var event:EventObject = body1.GetUserData() as EventObject;
					if(body2 && body2.GetUserData() && body2.GetUserData() is ExSprite){
						var target:ExSprite = body2.GetUserData() as ExSprite;
						event.setTarget(target);
					}
					else{
						event.setTarget(null);
					}
				}
			}
		}
		*/
		
		public function getItemCount():uint{
			return _state.the_world.GetBodyCount();
		}
	}
}