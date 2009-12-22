package PhysicsGame
{
	import org.overrides.ExTilemap;
	
	public class MapBase {
		//Layer name definitions
		public static const LAYER_BACKGROUND:uint = 0;
		public static const LAYER_MAIN:uint = 1;
		public static const LAYER_FOREGROUND:uint = 2;

		//Layer variable accessors
		public var layerBackground:ExTilemap;
		public var layerMain:ExTilemap;
		public var layerForeground:ExTilemap;

		//Map layers and principal layer (map) declarations
		public var allLayers:Array;

		public var mainLayer:ExTilemap;

		public var boundsMinX:int;
		public var boundsMinY:int;
		public var boundsMaxX:int;
		public var boundsMaxY:int;

		public var MapName:String;
		
		public function MapBase() {}

		public var bgColor:uint = 0xff000000;

		virtual public function addSpritesToLayerBackground(onAddCallback:Function = null):void { }
		virtual public function addSpritesToLayerMain(onAddCallback:Function = null):void { }
		virtual public function addSpritesToLayerForeground(onAddCallback:Function = null):void { }

		public var customValues:Object = new Object;		//Name-value map;
		virtual public function customFunction(param:* = null):* { }

	}
}