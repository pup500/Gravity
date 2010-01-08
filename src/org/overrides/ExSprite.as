package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	
	import PhysicsGame.ShapeDefiner;
	
	import common.Utilities;
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ExSprite extends FlxSprite
	{
		public var name:String;
		public var imageResource:String;
		public var layer:uint;
		
		public var body:b2BodyDef;
		//public var shape:b2PolygonDef;
		public var shape:b2ShapeDef;
		public var final_body:b2Body; //The physical representation in the Body2D b2World.
		//public var final_shape:b2Shape; //Needs to be defined in order to destroy the physical representation.
		public var impactPoint:b2ContactPoint;
		
		protected var _world:b2World;
		
		[Embed(source="../../data/editor/interface/pig-icon.png")] private  var eventImg:Class;
		
		public function ExSprite(x:int=0, y:int=0, sprite:Class=null, resource:String="")
		{
			super(x, y, eventImg);//sprite);
			name = "ExSprite";
			imageResource = resource;
			
			body = new b2BodyDef();
			body.position.Set(x, y);
			shape = new b2PolygonDef();
			
			impactPoint = new b2ContactPoint();
		}
		
		//Something to attempt, if we can create a polygon based on bitmap...
		
		public function initShapeFromSprite():void{
			//var points:Array = new Array();
			//var newPoint:Point = new Point();
			//var oldPoint:Point = new Point(-1,-1);
			//var i:int;
			//var j:int;
			//var pixelValue:uint;
			//var alphaValue:uint;
			//
			//var left:Boolean = false;
			//var right:Boolean = false;
			//var bottom:Boolean = false;
			//var top:Boolean = false;
			//var round:uint = 0;
			//
			//while(round < 5){
				//if(!top){
					//Go from top left to top right
					//for(i = 0; i < pixels.width; i++){
						//pixelValue = pixels.getPixel32(i,round);
						//alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + i + ", " + round + " =" + alphaValue);
						//if(alphaValue != 0){
							//Found first
							//newPoint = new Point(i,round);
							//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								//points.push(newPoint);
								//oldPoint.x = newPoint.x;
								//oldPoint.y = newPoint.y;
							//}
							//top = true;
							//
							//look for last one on same line...
							//for(j = pixels.width-1; j > i; j--){
								//pixelValue = pixels.getPixel32(j,round);
								//alphaValue = pixelValue >> 24 & 0xFF;
								//trace("x,y: " + j + ", " + round + " =" + alphaValue);
								//if(alphaValue != 0){
									//newPoint = new Point(j, round);
									//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										//points.push(newPoint);
										//oldPoint.x = newPoint.x;
										//oldPoint.y = newPoint.y;
									//}
									//break;
								//}
							//}
							//break;
						//}
					//}
				//}
				//
				//if(!right){
					//Go from top right to bottom right
					//for(j = 0; j < pixels.height; j++){
						//pixelValue = pixels.getPixel32(pixels.width-1-round,j);
						//alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + (pixels.width-1-round) + ", " + j + " =" + alphaValue);
						//if(alphaValue != 0){
							//newPoint = new Point(pixels.width-1-round,j);
							//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								//points.push(newPoint);
								//oldPoint.x = newPoint.x;
								//oldPoint.y = newPoint.y;
							//}
							//right = true;
							//
							//look for last one on same line...
							//for(i = pixels.height-1; i > j; i--){
								//pixelValue = pixels.getPixel32(pixels.width-1-round,i);
								//alphaValue = pixelValue >> 24 & 0xFF;
								//trace("x,y: " + (pixels.width-1-round) + ", " + i + " =" + alphaValue);
								//if(alphaValue != 0){
									//newPoint = new Point(pixels.width-1-round,i);
									//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										//points.push(newPoint);
										//oldPoint.x = newPoint.x;
										//oldPoint.y = newPoint.y;
									//}
									//break;
								//}
							//}
							//break;
						//}
					//}
				//}
				//
				//if(!bottom){
					//Go from bottom right to bottom left
					//for(i = pixels.width - 1; i >= 0; i--){
						//pixelValue = pixels.getPixel32(i,pixels.height-1-round);
						//alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + i + ", " + (pixels.height-1-round) + " =" + alphaValue);
						//if(alphaValue != 0){
							//newPoint = new Point(i,pixels.height-1-round);
							//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								//points.push(newPoint);
								//oldPoint.x = newPoint.x;
								//oldPoint.y = newPoint.y;
							//}
							//bottom = true;
							//
							//look for last one on same line...
							//for(j = 0; j < i; j++){
								//pixelValue = pixels.getPixel32(j,pixels.height-1-round);
								//alphaValue = pixelValue >> 24 & 0xFF;
								//trace("x,y: " + j + ", " + (pixels.height-1-round) + " =" + alphaValue);
								//if(alphaValue != 0){
									//newPoint = new Point(j,pixels.height-1-round);
									//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										//points.push(newPoint);
										//oldPoint.x = newPoint.x;
										//oldPoint.y = newPoint.y;
									//}
									//break;
								//}
							//}
							//break;
						//}
					//}
				//}
				//
				//if(!left){
					//Go from bottom left to top left
					//for(j = pixels.height - 1; j >= 0; j--){
						//pixelValue = pixels.getPixel32(round,j);
						//alphaValue = pixelValue >> 24 & 0xFF;
						//trace("x,y: " + round + ", " + j + " =" + alphaValue);
						//if(alphaValue != 0){
							//newPoint = new Point(round,j);
							//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
								//points.push(newPoint);
								//oldPoint.x = newPoint.x;
								//oldPoint.y = newPoint.y;
							//}
							//left = true;
							//
							//look for last one on same line...
							//for(i = 0; i < j; i++){
								//pixelValue = pixels.getPixel32(round,i);
								//alphaValue = pixelValue >> 24 & 0xFF;
								//trace("x,y: " + round + ", " + i + " =" + alphaValue);
								//if(alphaValue != 0){
									//newPoint = new Point(round,i);
									//if(oldPoint.x != newPoint.x || oldPoint.y != newPoint.y){
										//points.push(newPoint);
										//oldPoint.x = newPoint.x;
										//oldPoint.y = newPoint.y;
									//}
									//break;
								//}
							//}
							//break;
						//}
					//}
				//}
				//
				//if(points.length > 2){
					//remove last if duplicate...
					//if(points[0].x == points[points.length-1].x &&
						//points[0].y == points[points.length-1].y){
						//points.pop();
					//}
					//
					//shape.vertexCount = points.length;
					//for(var k:uint = 0; k < points.length; k++){
						//shape.vertices[k].Set(points[k].x - _bw/2, points[k].y - _bh/2);
						//
						//trace("finalk:" + k + " Xy:" + points[k].x + "," + points[k].y);
					//}
					//trace("X,y:" + x + ", " + y + " bw: " + _bw + " bh: " + _bh);
					//shape.friction = .5;
					//shape.density = 1;
					//return;
				//}
				//else{
					//round++;
				//}
			//}
			
			shape = ShapeDefiner.GetShapeDefFromSprite(x, y, _bw, _bh, pixels);
			if(!shape)//We failed getting any good physics shape for it, resort to box...
				initShape();
		}
		
		//We're calling this outside the constructor because we need Flixel to define its sprite dimensions first in loadGraphic().
		//TODO: Refactor. Can this go into the constructor somehow? Having to call it everytime you construct the an ExSprite sucks
		public function initShape():void {
			//shape.SetAsBox(_bw / 2, _bh / 2);
			//shape.friction = .5;
			//shape.density = 1;
			
			shape = ShapeDefiner.GetPolygonDef(_bw, _bh);
		}
		
		public function initCircleShape():void
		{
			shape = ShapeDefiner.GetCircleDef(_bw / 2);
		}
		
		//@desc Create the physical representation in the Box2D World.
		//@param	world The Box2D b2World for this object to exist in.
		public function createPhysBody(world:b2World):void
		{
			final_body=world.CreateBody(body);
			final_body.CreateShape(shape);
			final_body.SetMassFromShapes();
			_world = world;
			
			final_body.SetUserData(this);
		}
		
		//TODO override FlxCore.destroy() instead of using this as the public function.
		public function destroyPhysBody():void
		{
			if(exists){
				exists = false;
				//We might not need to save shape as destroy body should work already...
				//final_body.DestroyShape(final_shape);
				destroyAllJoints();
				_world.DestroyBody(final_body);
				//final_shape = null;
				final_body = null;
			}
		}
		
		public function destroyAllJoints():void{
			var joints:b2JointEdge;
			while(joints = final_body.GetJointList()){
				_world.DestroyJoint(joints.joint);
			}
		}
		
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
		
		override public function update():void
		{
			trace("update exsprite");
			super.update();
			var posVec:b2Vec2 = final_body.GetPosition();
			x = posVec.x - width/2;//_bw/2;
			y = posVec.y - height/2;//_bh/2;
			
			angle = final_body.GetAngle();
			
			updateJoints();
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
			
			trace("render exsprite");
			
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
		
		//See Minh:
		//Box2D reuses the reference to point, so we can't simply copy the reference.
		// Since there are no copy constructors, we'll have to manually copy a few
		//	properties here. Shape 1 and 2, and other such object references will be missing.
		public function setImpactPoint(point:b2ContactPoint):void{
			impactPoint.friction = point.friction;
			impactPoint.id = point.id;
			impactPoint.normal = point.normal;
			impactPoint.position = point.position.Copy();
		}
		
		public function removeImpactPoint(point:b2ContactPoint):void{
			impactPoint.friction = point.friction;
			impactPoint.id = point.id;
			impactPoint.normal = point.normal;
			impactPoint.position = point.position.Copy();
		}
	}
}