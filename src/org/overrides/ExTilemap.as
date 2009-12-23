package org.overrides
{
	import flash.geom.Rectangle;
	
	import org.flixel.FlxTilemap;

	public class ExTilemap extends FlxTilemap
	{
		public var _sprites:Array;
		
		public function ExTilemap()
		{
			super();
			
			_sprites = new Array();
		}
		
		//@desc		Load the tilemap with string data and a tile graphic
		//@param	MapData			A string of comma and line-return delineated indices indicating what order the tiles should go in
		//@param	TileGraphic		All the tiles you want to use, arranged in a strip corresponding to the numbers in MapData
		//@param	TileSize		The width and height of your tiles (e.g. 8) - defaults to height of the tile graphic
		//@return	A pointer this instance of FlxTilemap, for chaining as usual :)
		override public function loadMap(MapData:String, TileGraphic:Class, TileSize:uint=0):FlxTilemap
		{
			super.loadMap(MapData, TileGraphic, TileSize);
			
			//heightInTiles = widthInTiles = 20;
			
			for(var row:uint = 0; row < heightInTiles; row++){
				for(var col:uint = 0; col < widthInTiles; col++){
					var i:uint = row * widthInTiles + col;
					if(_rects[i]){
					//	var rect:Rectangle = _rects[i] as Rectangle;
						var rect:Rectangle = new Rectangle(0,0,8,8);
					
						var body:ExSprite = new ExSprite(col * _tileSize, row * _tileSize);
						body.width = _tileSize;
						body.height = _tileSize;
						
						trace("x,y:" +col * _tileSize + ", " + row * _tileSize);
						body.body.position.x += body.width/2;
						body.body.position.y += body.height/2;
						
						//trace("x: " + rect.x + " y: " + rect.y + "height:" + rect.height + "wi:" + rect.width);
						//trace("body" + body);
						body.initShape();
						body.shape.density = 0; //0 density makes object stationary.
						//body._shape.SetAsBox(_tileSize, _tileSize);
						_sprites.push(body);
					}
				}
				
			}
			
			return this;
		}
		
		override public function render():void{
			super.render();
			//return;
		}
	}
}