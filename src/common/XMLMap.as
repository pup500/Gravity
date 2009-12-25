package common
{
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
		private var _config:Array;
		private var _state:ExState;
		
		private var _start:Point;
		private var _end:Point;
		
		public function XMLMap(state:ExState)
		{
			_state = state;	
			_config = new Array();
			_start = new Point();
			_end = new Point();
		}

		//Load the config file to set up world...
		public function loadConfigFile(file:String):void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadXMLConfigComplete);
			loader.load(new URLRequest(file));
		}
		
		//Actual callback function for load finish
		private function onLoadXMLConfigComplete(event:Event):void{
			var xml:XML = new XML(event.target.data);
			
			for each(var shape:XML in xml.objects.shape){
				addXMLObject(shape);
			}
			
			_start.x = xml.points.start.x;
			_start.y = xml.points.start.y;
			_end.x = xml.points.end.x;
			_end.y = xml.points.end.y;
			
			_state.init();
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
		    	shape.x = int(shape.x) + bitmapData.width/2;
		    	shape.y = int(shape.y) + bitmapData.height/2;
		    }
		    
		    var b2:ExSprite = new ExSprite(shape.x, shape.y);
		    b2.pixels = bitmapData;
		    b2.initShape();
			b2.createPhysBody(_state.the_world);
			if(shape.type == "static"){
				b2.final_body.SetStatic();
			}
			if(shape.angle != 0){
				b2.body.angle = shape.angle;
			}
			
			_state.add(b2);
			
    		_config.push(shape);
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
	}
}