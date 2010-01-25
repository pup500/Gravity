package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.Joints.b2JointEdge;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.flixel.*;
	use namespace b2internal;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ExSprite extends FlxSprite
	{
		public var name:String;
		public var imageResource:String;
		public var layer:uint;
		
		//Box2D
		protected var shape:b2Shape;
		protected var bodyDef:b2BodyDef;
		protected var fixtureDef:b2FixtureDef;
		protected var final_body:b2Body; //The physical representation in the Body2D b2World.
		protected var fixture:b2Fixture;
		
		protected var impactPoint:b2Contact;
		
		//We need the world to destroy the physical objects
		protected var _world:b2World;
		protected var _controller:b2Controller;
		
		protected var loaded:Boolean;
		
		public function ExSprite(x:int=0, y:int=0, sprite:Class=null){
			//TODO:Note that x and y needs to be offsetted by half width and height to match physics...
			super(x, y, sprite);
			
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(x/ExState.PHYS_SCALE, y/ExState.PHYS_SCALE);
			
			fixtureDef = new b2FixtureDef();
			fixtureDef.friction = 1;
			
			impactPoint = new b2Contact();
			
			loaded = false;
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
			
			while(round < 5){
				if(!top){
					//Go from top left to top right
					for(i = 0; i < pixels.width; i++){
						pixelValue = pixels.getPixel32(i,round);
						alphaValue = pixelValue >> 24 & 0xFF;
						trace("x,y: " + i + ", " + round + " =" + alphaValue);
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
								trace("x,y: " + j + ", " + round + " =" + alphaValue);
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
						trace("x,y: " + (pixels.width-1-round) + ", " + j + " =" + alphaValue);
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
								trace("x,y: " + (pixels.width-1-round) + ", " + i + " =" + alphaValue);
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
						trace("x,y: " + i + ", " + (pixels.height-1-round) + " =" + alphaValue);
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
								trace("x,y: " + j + ", " + (pixels.height-1-round) + " =" + alphaValue);
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
						trace("x,y: " + round + ", " + j + " =" + alphaValue);
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
								trace("x,y: " + round + ", " + i + " =" + alphaValue);
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
						
						trace("finalk:" + k + " Xy:" + points[k].x + "," + points[k].y);
					}
					trace("X,y:" + x + ", " + y + " bw: " + _bw + " bh: " + _bh);
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
		
		//@desc Create a rectangle shape definition from the sprite dimensions.
		//We're calling this outside the constructor because we need Flixel to define its sprite dimensions first in loadGraphic().
		protected function initBoxShape():void {
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox((_bw/2) / ExState.PHYS_SCALE, (_bh/2)/ExState.PHYS_SCALE);
			shape = shapeDef;
		}
		
		//@desc Create a circle shape definition from the sprite's width.
		protected function initCircleShape():void
		{
			shape = new b2CircleShape((_bw/2)/ExState.PHYS_SCALE);
		}
		
		public function initShape(type:uint):void{
			switch(type){
				case b2Shape.e_circleShape:
					initCircleShape();
					break;
				case b2Shape.e_polygonShape:
					//initShape();
					initShapeFromSprite();
					break;
				case b2Shape.e_edgeShape:
					//initShape();
					//We don't have edgeshapes yet.....
					initShapeFromSprite();
					break;
			}
		}
		
		//@desc Create the physical representation in the Box2D World using the shape definition from initShape methods.
		//@param	world The Box2D b2World for this object to exist in.
		public function createPhysBody(world:b2World, controller:b2Controller=null):void{
			fixtureDef.shape = shape
			fixtureDef.density = 1.0;
			
			// Override the default friction.
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.1;
			
			final_body = world.CreateBody(bodyDef);
			fixture = final_body.CreateFixture(fixtureDef);
			
			//Save the world
			_world = world;
			_controller = controller;
			
			final_body.SetUserData(this);
			
			if(controller){
				controller.AddBody(final_body);
			}
			
			loaded = true;
		}
		
		//TODO override FlxCore.destroy() instead of using this as the public function.
		public function destroyPhysBody():void
		{
			if(exists){
				exists = false;
				//We might not need to save shape as destroy body should work already...
				//final_body.DestroyShape(final_shape);
				//destroyAllJoints();
				
				if(_controller){
					_controller.RemoveBody(final_body);
				}
				
				_world.DestroyBody(final_body);
				
				final_body = null;
				fixture = null;
			}
		}
		
		//We can remove all joints explicitly
		public function destroyAllJoints():void{
			var joints:b2JointEdge;
			while(joints = final_body.GetJointList()){
				_world.DestroyJoint(joints.joint);
			}
		}
		
		/*
		public function updateJoints():void{
			var joint:b2Joint;
			var joints:b2JointEdge = final_body.GetJointList();
			while(joints){
				switch(joints.joint.GetType()){
					//TODO:SEE IF THIS MAKES SENSE, can we put this anywhere else....
					case Utilities.e_prismaticJoint:
						var jointRev:b2PrismaticJoint = joints.joint as b2PrismaticJoint;
						//trace("limit:" + jointRev.GetLowerLimit() + ", " + jointRev.GetUpperLimit() + " : " + jointRev.GetJointTranslation());
						if(Math.abs(jointRev.GetJointTranslation() - jointRev.GetLowerLimit()) < .1){
							jointRev.SetMotorSpeed(Math.abs(jointRev.GetMotorSpeed()));
							//trace("speed:" + jointRev.GetMotorSpeed());
						}
						else if(Math.abs(jointRev.GetJointTranslation() - jointRev.GetUpperLimit()) < .1){
							//trace("speed:" + jointRev.GetMotorSpeed());
							jointRev.SetMotorSpeed(-Math.abs(jointRev.GetMotorSpeed()));
						}
						break;
				};
				
				joints = joints.next;
			}
		}
		*/
		
		override public function update():void
		{
			if(!loaded) return;
			
			super.update();
			
			updatePosition();
			
			angle = final_body.GetAngle();
			
			//updateJoints();
		}
		
		public function updatePosition():void{
			var posVec:b2Vec2 = final_body.GetPosition();
			
			//trace("name:" + name + " posxy:" + posVec.x + "," + posVec.y + " scaledxy: " + (posVec.x * ExState.PHYS_SCALE) + "," + (posVec.y * ExState.PHYS_SCALE));
			//trace("width:" + width + "," + height);
			
			//Use width and height because sprite may be animated so each frame doesn't take up full bitmap
			x = (posVec.x * ExState.PHYS_SCALE) - (width/2);//_bw/2;
			y = (posVec.y * ExState.PHYS_SCALE) - (height/2); //* ExState.PHYS_SCALE;//_bh/2;
		}
		
		override public function kill():void
		{
			destroyPhysBody();
			super.kill();
		}
		
		override public function render():void
		{
			if(!visible)
				return;
			getScreenXY(_p);
			
			//Simple render
			if((angle == 0) && (scale.x == 1) && (scale.y == 1) && (blend == null))
			{
				FlxG.buffer.copyPixels(_framePixels,_r,_p,null,null,true);
				return;
			}
			
			//Advanced render
			_mtx.identity();
			_mtx.translate(-origin.x,-origin.y);
			_mtx.scale(scale.x,scale.y);
			if(angle != 0) _mtx.rotate(angle);
			_mtx.translate(_p.x+origin.x,_p.y+origin.y);
			FlxG.buffer.draw(_framePixels,_mtx,null,blend,null,antialiasing);
		}
		
		override public function hurt(Damage:Number):void{
		
		}
		
		public function GetBody():b2Body{
			return final_body;
		}
		
		public function GetShape():b2Shape{
			return shape;
		}
		
		//See Minh:
		//Box2D reuses the reference to point, so we can't simply copy the reference.
		// Since there are no copy constructors, we'll have to manually copy a few
		//	properties here. Shape 1 and 2, and other such object references will be missing.
		public function setImpactPoint(point:b2Contact):void {
			//impactPoint.friction = point.friction;
			//impactPoint.id = point.id;
			//impactPoint.normal = point.normal;
			//impactPoint.position = point.position.Copy();
			
			//impactPoint
			
			//trace("impact: points" + point.GetManifold().m_pointCount);
			//trace("impact: points" + point.GetManifold().m_localPoint.x * ExState.PHYS_SCALE + ","
			// + point.GetManifold().m_localPoint.y * ExState.PHYS_SCALE);
		}
		
		public function removeImpactPoint(point:b2Contact):void{
			//impactPoint.friction = point.friction;
			//impactPoint.id = point.id;
			//impactPoint.normal = point.normal;
			//impactPoint.position = point.position.Copy();
		}
		
		//NOTE: Always change getXML first, then save all the levels into new files and then
		//Change the init function to match getXML
		public function getXML():XML
		{			
			var xml:XML = new XML(<shape/>);
			xml.file =  imageResource;
			xml.@layer = layer;
			xml.@bodyType = fixture.GetBody().GetType();
			xml.@shapeType = fixture.GetType();
			xml.@angle = angle;
			
			//XML representation is in screen coordinates, so scale up physics
			xml.@x = final_body.GetPosition().x * ExState.PHYS_SCALE;
			xml.@y = final_body.GetPosition().y * ExState.PHYS_SCALE;
					
			return xml;
		}
		
		//Initialize the ExSprite from the xml data structure
		public function initFromXML(xml:XML, world:b2World, controller:b2Controller=null):void{
			//If there's no image file information, just load the file normally
			if(xml.file.length() == 0){
				onInitXMLComplete(xml, world, controller);
				return;
			}
			
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
    			function(e:Event):void{
    				onInitXMLComplete(xml, world, controller, e)
    			});
    		
    		loader.load(new URLRequest(xml.file));
		}
		
		protected function onInitXMLComplete(xml:XML, world:b2World=null, controller:b2Controller=null, event:Event=null):void{
			//Load the bitmap data
			if(event){
				var loadinfo:LoaderInfo = LoaderInfo(event.target);
				var bitmapData:BitmapData = Bitmap(loadinfo.content).bitmapData;
		 		pixels = bitmapData;
			}
			
			//Assume we have pixel data already....
			imageResource = xml.file;
			layer = xml.@layer;
			
			bodyDef.type = xml.@bodyType;
			
			initShape(xml.@shapeType);
			
			bodyDef.angle = xml.@angle;
			bodyDef.position.Set(xml.@x/ExState.PHYS_SCALE, xml.@y/ExState.PHYS_SCALE);
			
			//TODO:Do we need to correct for x and y...?
			createPhysBody(world, controller);
			
			reset(xml.@x, xml.@y);
		}
		
		public function SetBodyType(type:uint):void{
			final_body.SetType(type);
		}
		
		public function SetShapeType(type:uint):void{
			initShape(type);
			final_body.DestroyFixture(fixture);
			final_body.CreateFixture2(shape, 1.0);
			fixture = final_body.GetFixtureList();
		}
		
		
	}
}