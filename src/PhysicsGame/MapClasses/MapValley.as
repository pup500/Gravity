package PhysicsGame.MapClasses 
{
		import org.flixel.*;
	import org.overrides.*;

	
	/**
	 * ...
	 * @author Norman
	 */
	public class MapValley extends MapBase
	{
		//Media content declarations
		[Embed(source="../../data/Maps/MapCSV_Valley_Background.txt", mimeType="application/octet-stream")] public var CSV_Background:Class;
		[Embed(source="../../data/tiles_all.png")] public var Img_Background:Class;
		[Embed(source="../../data/Maps/MapCSV_Valley_Main.txt", mimeType="application/octet-stream")] public var CSV_Main:Class;
		[Embed(source="../../data/tiles_all.png")] public var Img_Main:Class;
		[Embed(source="../../data/Maps/MapCSV_Valley_Foreground.txt", mimeType="application/octet-stream")] public var CSV_Foreground:Class;
		[Embed(source="../../data/tiles_all.png")] public var Img_Foreground:Class;

		public function MapValley() {

			_setCustomValues();

			bgColor = 0xff000000;

			layerBackground = new ExTilemap();
			layerBackground.loadMap(new CSV_Background, Img_Background);
			
			layerMain = new ExTilemap();
			layerMain.loadMap(new CSV_Main, Img_Main);
			
			layerForeground = new ExTilemap();
			layerMain.loadMap(new CSV_Foreground, Img_Foreground);

			allLayers = [ layerBackground, layerMain, layerForeground ];

			mainLayer = layerMain;

			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 160;
			boundsMaxY = 80;
			
			playerSpawn_x = 60;
			playerSpawn_y = 10;
		}

		override public function customFunction(param:* = null):* {

		}

		private function _setCustomValues():void {
		}
		
	}

}