package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.geom.Point;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ShapeDefiner
	{
		//create a polygon based on bitmap...
		public static function GetShapeDefFromSprite(x:int, y:int, width:int, height:int, pixels:BitmapData):b2PolygonDef
		{
			var shape:b2PolygonDef = new b2PolygonDef();
			var points:Array = new Array();
			var newPoint:Point = new Point();
			var oldPoint:Point = new Point(-1,-1);
			var i:int;
			var j:int;
			var pixelValue:uint;
			var alphaValue:uint;
			
			var left:Boolean = false;
			var right:Boolean = false;
			var bottom:Boolean = false;
			var top:Boolean = false;
			var round:uint = 0;
			
			while(round < 5){
				if(!top){
					//Go from top left to top right
					for(i = 0; i < pixels.width; i++){
						pixelValue = pixels.getPixel32(i,round);
						alphaValue = pixelValue >> 24 & 0xFF;
						trace("x,y: " + i + ", " + round + " =" + alphaValue);
						if(alphaValue != 0){
							//Found first
							newPoint = new Point(i,round);
							if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								points.push(newPoint);
								oldPoint.x = newPoint.x;
								oldPoint.y = newPoint.y;
							}
							top = true;
							
							//look for last one on same line...
							for(j = pixels.width-1; j > i; j--){
								pixelValue = pixels.getPixel32(j,round);
								alphaValue = pixelValue >> 24 & 0xFF;
								trace("x,y: " + j + ", " + round + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new Point(j, round);
									if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										points.push(newPoint);
										oldPoint.x = newPoint.x;
										oldPoint.y = newPoint.y;
									}
									break;
								}
							}
							break;
						}
					}
				}
				
				if(!right){
					//Go from top right to bottom right
					for(j = 0; j < pixels.height; j++){
						pixelValue = pixels.getPixel32(pixels.width-1-round,j);
						alphaValue = pixelValue >> 24 & 0xFF;
						trace("x,y: " + (pixels.width-1-round) + ", " + j + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new Point(pixels.width-1-round,j);
							if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								points.push(newPoint);
								oldPoint.x = newPoint.x;
								oldPoint.y = newPoint.y;
							}
							right = true;
							
							//look for last one on same line...
							for(i = pixels.height-1; i > j; i--){
								pixelValue = pixels.getPixel32(pixels.width-1-round,i);
								alphaValue = pixelValue >> 24 & 0xFF;
								trace("x,y: " + (pixels.width-1-round) + ", " + i + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new Point(pixels.width-1-round,i);
									if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										points.push(newPoint);
										oldPoint.x = newPoint.x;
										oldPoint.y = newPoint.y;
									}
									break;
								}
							}
							break;
						}
					}
				}
				
				if(!bottom){
					//Go from bottom right to bottom left
					for(i = pixels.width - 1; i >= 0; i--){
						pixelValue = pixels.getPixel32(i,pixels.height-1-round);
						alphaValue = pixelValue >> 24 & 0xFF;
						trace("x,y: " + i + ", " + (pixels.height-1-round) + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new Point(i,pixels.height-1-round);
							if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								points.push(newPoint);
								oldPoint.x = newPoint.x;
								oldPoint.y = newPoint.y;
							}
							bottom = true;
							
							//look for last one on same line...
							for(j = 0; j < i; j++){
								pixelValue = pixels.getPixel32(j,pixels.height-1-round);
								alphaValue = pixelValue >> 24 & 0xFF;
								trace("x,y: " + j + ", " + (pixels.height-1-round) + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new Point(j,pixels.height-1-round);
									if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										points.push(newPoint);
										oldPoint.x = newPoint.x;
										oldPoint.y = newPoint.y;
									}
									break;
								}
							}
							break;
						}
					}
				}
				
				if(!left){
					//Go from bottom left to top left
					for(j = pixels.height - 1; j >= 0; j--){
						pixelValue = pixels.getPixel32(round,j);
						alphaValue = pixelValue >> 24 & 0xFF;
						trace("x,y: " + round + ", " + j + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new Point(round,j);
							if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								points.push(newPoint);
								oldPoint.x = newPoint.x;
								oldPoint.y = newPoint.y;
							}
							left = true;
							
							//look for last one on same line...
							for(i = 0; i < j; i++){
								pixelValue = pixels.getPixel32(round,i);
								alphaValue = pixelValue >> 24 & 0xFF;
								trace("x,y: " + round + ", " + i + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new Point(round,i);
									if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										points.push(newPoint);
										oldPoint.x = newPoint.x;
										oldPoint.y = newPoint.y;
									}
									break;
								}
							}
							break;
						}
					}
				}
				
				if(points.length > 2){
					//remove last if duplicate...
					if(points[0].x == points[points.length-1].x &&
						points[0].y == points[points.length-1].y){
						points.pop();
					}
					
					shape.vertexCount = points.length;
					for(var k:uint = 0; k < points.length; k++){
						shape.vertices[k].Set(points[k].x - width/2, points[k].y - height/2);
						
						trace("finalk:" + k + " Xy:" + points[k].x + "," + points[k].y);
					}
					trace("X,y:" + x + ", " + y + " bw: " + width + " bh: " + height);
					shape.friction = .5;
					shape.density = 1;
					return shape;
				}
				else{
					round++;
				}
			}
			
			//We failed getting any good physics shape for it
			return null;
		}
		
		public static function GetPolygonDef(Width:int, Height:int):b2PolygonDef
		{
			var shapeDef:b2PolygonDef = new b2PolygonDef();
			shapeDef.SetAsBox(Width / 2, Height / 2);
			shapeDef.friction = .5;
			shapeDef.density = 1;
			return shapeDef;
		}
		
		public static function GetCircleDef(Radius:int):b2CircleDef
		{
			var shapeDef:b2CircleDef = new b2CircleDef();
			shapeDef.radius = Radius;
			shapeDef.friction = .5;
			shapeDef.density = 1;
			return shapeDef;
		}
	}
}