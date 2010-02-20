package PhysicsGame.Components
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class PhysicsComponent implements IComponent
	{
		protected var me:ExSprite;
		
		protected var shape:b2Shape;
		protected var bodyDef:b2BodyDef;
		protected var fixtureDef:b2FixtureDef;
		protected var final_body:b2Body; //The physical representation in the Body2D b2World.
		protected var fixture:b2Fixture;
		
		protected var state:ExState;
		protected var world:b2World;
		protected var controller:b2Controller;
		
		public function PhysicsComponent(obj:ExSprite)
		{
			me = obj;
			
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(me.x/ExState.PHYS_SCALE, me.y/ExState.PHYS_SCALE);
			bodyDef.fixedRotation = false;
			
			//TODO:Decouple this
			state = FlxG.state as ExState;
			world = state.the_world;
			controller = state.getController();
		}
		
		public function initBody():void{
			final_body = world.CreateBody(bodyDef);
			final_body.SetUserData(me);
		}
		
		public function addShape():void{
			fixture = final_body.CreateFixture(fixtureDef);
		}
		
		//@desc Create a polygon shape definition based on bitmap. If this doesn't work, it will call initShape()
		protected function initShapeFromSprite():void{
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			var points:Array = new Array();
			var newPoint:b2Vec2 = new b2Vec2();
			var oldPoint:b2Vec2 = new b2Vec2(-1,-1);
			var i:int;
			var j:int;
			var pixelValue:uint;
			var alphaValue:uint;
			
			var left:Boolean = false;
			var right:Boolean = false;
			var bottom:Boolean = false;
			var top:Boolean = false;
			var round:uint = 0;
			
			//TODO:This doesn't account for frame data so we can't use this for animated objects
			
			while(round < 5){
				if(!top){
					//Go from top left to top right
					for(i = 0; i < pixels.width; i++){
						pixelValue = pixels.getPixel32(i,round);
						alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + i + ", " + round + " =" + alphaValue);
						if(alphaValue != 0){
							//Found first
							newPoint = new b2Vec2(i,round);
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
								//trace("x,y: " + j + ", " + round + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new b2Vec2(j, round);
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
						//trace("x,y: " + (pixels.width-1-round) + ", " + j + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new b2Vec2(pixels.width-1-round,j);
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
								//trace("x,y: " + (pixels.width-1-round) + ", " + i + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new b2Vec2(pixels.width-1-round,i);
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
						//trace("x,y: " + i + ", " + (pixels.height-1-round) + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new b2Vec2(i,pixels.height-1-round);
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
								//trace("x,y: " + j + ", " + (pixels.height-1-round) + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new b2Vec2(j,pixels.height-1-round);
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
						//trace("x,y: " + round + ", " + j + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new b2Vec2(round,j);
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
								//trace("x,y: " + round + ", " + i + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new b2Vec2(round,i);
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
					
					//Add the offset for the point
					for(var k:uint = 0; k < points.length; k++){
						//TODO:Are we offsetting by _bw or width height, etc...
						//I'm thinking width and height...
						points[k].x -= _bw/2;
						points[k].y -= _bh/2;
					}
					
					for(k = 0; k < points.length; k++){
						points[k].x /= ExState.PHYS_SCALE;
						points[k].y /= ExState.PHYS_SCALE;
					}
					
					shapeDef.SetAsArray(points, points.length);
					
					/*
					shapeDef.vertexCount = points.length;
					for(var k:uint = 0; k < points.length; k++){
						shapeDef.vertices[k].Set(points[k].x - _bw/2, points[k].y - _bh/2);
						
						//trace("finalk:" + k + " Xy:" + points[k].x + "," + points[k].y);
					}
					//trace("X,y:" + x + ", " + y + " bw: " + _bw + " bh: " + _bh);
					*/
					
					shape = shapeDef;
					return;
				}
				else{
					round++;
				}
			}
			
			initBoxShape();
		}
		
		//Init box shape from frame dimensions
		protected function initBoxShape():void {
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox((me.width/2) / ExState.PHYS_SCALE, (me.height/2)/ExState.PHYS_SCALE);
			shape = shapeDef;
		}
		
		//@desc Create a circle shape definition from the sprite's width.
		protected function initCircleShape():void
		{
			shape = new b2CircleShape((me.width/2)/ExState.PHYS_SCALE);
		}

		public function update():void
		{
			updateAngle();
			updatePosition();
		}
		
		public function updateAngle():void{
			angle = final_body.GetAngle();
		}
		
		public function updatePosition():void{
			var posVec:b2Vec2 = final_body.GetPosition();
			//Use width and height because sprite may be animated so each frame doesn't take up full bitmap
			me.x = Math.round((posVec.x * ExState.PHYS_SCALE) - (width/2));
			me.y = Math.round((posVec.y * ExState.PHYS_SCALE) - (height/2));
		}
	}
}