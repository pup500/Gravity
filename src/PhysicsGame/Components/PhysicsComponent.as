package PhysicsGame.Components
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	use namespace b2internal;
	
	public class PhysicsComponent implements IComponent
	{
		protected var me:ExSprite;
		
		//protected var shape:b2Shape;
		//protected var bodyDef:b2BodyDef;
		public var final_body:b2Body; //The physical representation in the Body2D b2World.
		
		protected var state:ExState;
		protected var world:b2World;
		protected var controller:b2Controller;
		
		protected var filterData:uint;
		
		//TODO:Refactor to ExSprite
		public function PhysicsComponent(obj:ExSprite, filter:uint)
		{
			me = obj;
			filterData = filter;
			
			//TODO:Decouple this
			state = FlxG.state as ExState;
			world = state.the_world;
			controller = state.getController();
		}
		
		public function isLoaded():Boolean{
			return final_body != null;
		}
		
		public function createBodyFromXML(xml:XML):b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = xml.@bodyType;
			bodyDef.angle = xml.@angle;
			bodyDef.bullet = xml.@bullet;
			bodyDef.position.Set(xml.@x/ExState.PHYS_SCALE, xml.@y/ExState.PHYS_SCALE);
			bodyDef.fixedRotation = false; //xml.@fixedRotation;
			return addBody(bodyDef);
		}
		
		public function addBody(bodyDef:b2BodyDef):b2Body{
			if(final_body){
				world.DestroyBody(final_body);
				final_body = null;
			}
			
			final_body = world.CreateBody(bodyDef);
			final_body.SetUserData(me);
			return final_body;
		}
		
		public function createShape(type:uint):b2Shape{
			switch(type){
				case b2Shape.e_circleShape:
					return createCircleShape();
					break;
				case b2Shape.e_polygonShape:
					//initShape();
					return createShapeFromSprite();
					break;
				case b2Shape.e_edgeShape:
					//initShape();
					//We don't have edgeshapes yet.....
					return null;//createShapeFromSprite();
					break;
				default:
					return null;
			}
		}
		
		//TODO:Remove sensor field...
		public function createFixtureFromXML(xml:XML, sensor:Boolean=false):b2Fixture{
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = createShape(xml.@shapeType);
			fixtureDef.friction = xml.@friction;
			fixtureDef.density = xml.@density;
			fixtureDef.restitution = xml.@restitution;
			fixtureDef.isSensor = sensor;//xml.@sensor;
			return addFixture(fixtureDef);
		}
		
		public function addFixture(fd:b2FixtureDef):b2Fixture{
			return final_body.CreateFixture(fd);
		}
		
///////////////////////////


		public function initStaticBody():b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(me.x/ExState.PHYS_SCALE, me.y/ExState.PHYS_SCALE);
			bodyDef.fixedRotation = false;
			return addBody(bodyDef);
		}

		//These are helpers for player and enemy classes
		public function initBody():b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(me.x/ExState.PHYS_SCALE, me.y/ExState.PHYS_SCALE);
			bodyDef.fixedRotation = false;
			return addBody(bodyDef);
		}
		
		
		
		public function addShape(s:b2Shape, f:Number, d:Number, sensor:Boolean=false):b2Fixture{
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = s;
			fixture.friction = f;
			fixture.density = d;
			fixture.isSensor = sensor;
			fixture.filter.categoryBits = filterData;
			return final_body.CreateFixture(fixture);			
		}
		
		public function addHead(f:Number=0, d:Number=1):b2Fixture{
			var s:b2CircleShape = new b2CircleShape((me.width/2)/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, -(me.height/4) / ExState.PHYS_SCALE));
			
			return addShape(s, f, d);
		}
		
		public function addTorso(f:Number=0, d:Number=1):b2Fixture{
			var s:b2PolygonShape = new b2PolygonShape();
			s.SetAsOrientedBox(me.width/2/ExState.PHYS_SCALE, (me.height/2)/2/ExState.PHYS_SCALE,
				new b2Vec2(0, 0/ExState.PHYS_SCALE));
			
			return addShape(s, f, d);
		}
		
		public function addSensor(f:Number=0, d:Number=1):b2Fixture{
			var s:b2CircleShape = new b2CircleShape(me.width/2/ExState.PHYS_SCALE);
			s.SetLocalPosition(new b2Vec2(0, ((me.height)/4)/ExState.PHYS_SCALE));
			
			return addShape(s, f, d);
		}
		
//////////////////////////
		
		//@desc Create a polygon shape definition based on bitmap. If this doesn't work, it will call initShape()
		protected function createShapeFromSprite():b2Shape{
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
					for(i = 0; i < me.pixels.width; i++){
						pixelValue = me.pixels.getPixel32(i,round);
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
							for(j = me.pixels.width-1; j > i; j--){
								pixelValue = me.pixels.getPixel32(j,round);
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
					for(j = 0; j < me.pixels.height; j++){
						pixelValue = me.pixels.getPixel32(me.pixels.width-1-round,j);
						alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + (pixels.width-1-round) + ", " + j + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new b2Vec2(me.pixels.width-1-round,j);
							if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								points.push(newPoint);
								oldPoint.x = newPoint.x;
								oldPoint.y = newPoint.y;
							}
							right = true;
							
							//look for last one on same line...
							for(i = me.pixels.height-1; i > j; i--){
								pixelValue = me.pixels.getPixel32(me.pixels.width-1-round,i);
								alphaValue = pixelValue >> 24 & 0xFF;
								//trace("x,y: " + (pixels.width-1-round) + ", " + i + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new b2Vec2(me.pixels.width-1-round,i);
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
					for(i = me.pixels.width - 1; i >= 0; i--){
						pixelValue = me.pixels.getPixel32(i,me.pixels.height-1-round);
						alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + i + ", " + (pixels.height-1-round) + " =" + alphaValue);
						if(alphaValue != 0){
							newPoint = new b2Vec2(i,me.pixels.height-1-round);
							if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								points.push(newPoint);
								oldPoint.x = newPoint.x;
								oldPoint.y = newPoint.y;
							}
							bottom = true;
							
							//look for last one on same line...
							for(j = 0; j < i; j++){
								pixelValue = me.pixels.getPixel32(j,me.pixels.height-1-round);
								alphaValue = pixelValue >> 24 & 0xFF;
								//trace("x,y: " + j + ", " + (pixels.height-1-round) + " =" + alphaValue);
								if(alphaValue != 0){
									newPoint = new b2Vec2(j,me.pixels.height-1-round);
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
					for(j = me.pixels.height - 1; j >= 0; j--){
						pixelValue = me.pixels.getPixel32(round,j);
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
								pixelValue = me.pixels.getPixel32(round,i);
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
						points[k].x -= me.pixels.width/2;
						points[k].y -= me.pixels.height/2;
					}
					
					for(k = 0; k < points.length; k++){
						points[k].x /= ExState.PHYS_SCALE;
						points[k].y /= ExState.PHYS_SCALE;
					}
					
					shapeDef.SetAsArray(points, points.length);
					
					return shapeDef;
				}
				else{
					round++;
				}
			}
			
			return createBoxShape();
		}
		
		//Init box shape from frame dimensions
		protected function createBoxShape():b2Shape {
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox((me.width/2) / ExState.PHYS_SCALE, (me.height/2)/ExState.PHYS_SCALE);
			return shapeDef;
		}
		
		//@desc Create a circle shape definition from the sprite's width.
		protected function createCircleShape():b2Shape{
			return new b2CircleShape((me.width/2)/ExState.PHYS_SCALE);
		}

		public function update():void
		{
			if(!isLoaded())
				return;
			//TODO:Figure out when exsprite should be loaded
			//if(!final_body)
			//	return;
			
			updateAngle();
			updatePosition();
		}
		
		public function updateAngle():void{
			me.angle = me.GetBody().GetAngle();
		}
		
		public function updatePosition():void{
			var posVec:b2Vec2 = final_body.GetPosition();
			//Use width and height because sprite may be animated so each frame doesn't take up full bitmap
			me.x = Math.round((posVec.x * ExState.PHYS_SCALE) - (me.width/2));
			me.y = Math.round((posVec.y * ExState.PHYS_SCALE) - (me.height/2));
		}
	}
}