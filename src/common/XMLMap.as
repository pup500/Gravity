package common
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.*;
	
	import PhysicsGame.*;
	
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
		private var offset:Point;
		
		private var expBodyCount:uint;
		private var _loaded:Boolean;
		private var savePoints:Boolean;
		private var bodiesLoaded:Boolean;
		
		public function XMLMap(state:ExState)
		{
			_state = state;	
			_start = new Point();
			_end = new Point();
			//offset = new Point();
			
			savePoints = false;
			
			_loaded = false;
			bodiesLoaded = true;
		}

		//Load the config file to set up world...
		public function loadConfigFile(file:String, setPoints:Boolean=true, p:b2Vec2=null):void{
			savePoints = setPoints;
			
			if(p){
				offset = new Point(p.x, p.y);
			}
			else{
				offset = null;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadXMLConfigComplete);
			//loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(file));
		}
		
		//Actual callback function for load finish
		private function onLoadXMLConfigComplete(event:Event):void{
			configXML = new XML(event.target.data);
			
			if(offset){
				addOffset();
			}
			
			//Save the start and end positions right away
			if(savePoints){
				_start.x = configXML.points.start.@x;
				_start.y = configXML.points.start.@y;
				_end.x = configXML.points.end.@x;
				_end.y = configXML.points.end.@y;
			
				_state.getArgs()["startPoint"] = new b2Vec2(_start.x, _start.y);
				_state.getArgs()["endPoint"] = new b2Vec2(_end.x, _end.y);
			}
			
			expBodyCount = getItemCount() + configXML.objects.shape.length();
			bodiesLoaded = false;
			
			for each(var shape:XML in configXML.objects.shape){
				 var b2:ExSprite = new ExSprite();
		    	b2.initFromXML(shape, _state.the_world, _state.getController());
		    	_state.addToLayer(b2, shape.layer);
			}
		}
		
		private function addOffset():void{
			//Should we figure out a better way for offset...
			var shape:XML = configXML.objects.shape[0];
			var min:Point = new Point(shape.@x, shape.@y);
			var max:Point = new Point(shape.@x, shape.@y);
			
			for each(shape in configXML.objects.shape){
				if(int(shape.@x) < min.x) min.x = int(shape.@x);
				if(int(shape.@y) < min.y) min.y = int(shape.@y);
				if(int(shape.@x) > max.x) max.x = int(shape.@x);
				if(int(shape.@y) > max.y) max.y = int(shape.@y);
			}
			
			//Offset is to make the midpoint of the whole object at the mouse coordinate
			offset.x = offset.x - (min.x + max.x)/2;
			offset.y = offset.y - (min.y + max.y)/2;
			
			//Or we can make offset at the top-left corner...
			//offset.x = point.x - min.x;
			//offset.y = point.y - min.y;
			
			
			for each(shape in configXML.objects.shape){
				shape.@x = int(shape.@x) + offset.x;
		    	shape.@y = int(shape.@y) + offset.y;
			}
			
			for each(var joint:XML in configXML.objects.joint){
				joint.body1.@x = int(joint.body1.@x) + offset.x;
		    	joint.body1.@y = int(joint.body1.@y) + offset.y;
		    	joint.body2.@x = int(joint.body2.@x) + offset.x;
		    	joint.body2.@y = int(joint.body2.@y) + offset.y;
		    	
		    	//Don't offset axis, that's a normalized vector...
		    	//joint.axis.@x = int(joint.axis.@x) + offset.x;
		    	//joint.axis.@y = int(joint.axis.@y) + offset.y;
		    	joint.anchor.@x = int(joint.anchor.@x) + offset.x;
		    	joint.anchor.@y = int(joint.anchor.@y) + offset.y;
			}
			
			for each(var eventXML:XML in configXML.objects.event){
				eventXML.@x = int(eventXML.@x) + offset.x;
		    	eventXML.@y = int(eventXML.@y) + offset.y;
		    	
		    	if(eventXML.target.@x.length() > 0 && eventXML.target.@y.length() > 0){
		    		eventXML.target.@x = int(eventXML.target.@x) + offset.x;
		    		eventXML.target.@y = int(eventXML.target.@y) + offset.y;
		    	}
			}
		}
		
		public function update():void{
			if(!bodiesLoaded){
				trace("count" + expBodyCount + " getitemcount" + getItemCount());
				
				if (expBodyCount == getItemCount()) {
					bodiesLoaded = true;
					addAllEvents();
					addAllJoints();
					
					if(!_loaded && savePoints){
						_loaded = true;
						_state.init();
					}
				}
			}
		}
		
		/*
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
		*/
		
		//Create new configuration file
		/*
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
		}*/
		
		/*
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
		*/
		
		
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