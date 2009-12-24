package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ExSprite extends FlxSprite
	{
		public var name:String;
		public var body:b2BodyDef;
		public var shape:b2PolygonDef;
		public var final_body:b2Body; //The physical representation in the Body2D b2World.
		public var final_shape:b2Shape; //Needs to be defined in order to destroy the physical representation.
		public var impactPoint:b2Vec2;
		
		protected var _world:b2World;
		
		public function ExSprite(x:int=0, y:int=0, sprite:Class=null)
		{
			super(x, y, sprite);
			name = "ExSprite";
			
			body = new b2BodyDef();
			body.position.Set(x, y);
			shape = new b2PolygonDef();
			
			impactPoint = new b2Vec2();
		}
		//We're calling this outside the constructor because we need Flixel to define its sprite dimensions first in loadGraphic().
		//TODO: Refactor. Can this go into the constructor somehow? Having to call it everytime you construct the an ExSprite sucks
		public function initShape():void {
			shape.SetAsBox(_bw/2, _bh/2); 
			shape.friction = 0.3;
			shape.density = 1;
		}
		
		//@desc Create the physical representation in the Box2D World.
		//@param	world The Box2D b2World for this object to exist in.
		public function createPhysBody(world:b2World):void
		{
			final_body=world.CreateBody(body);
			//final_shape = 
			final_body.CreateShape(shape);
			final_body.SetMassFromShapes();
			
			//shape.userData = this;
			//body.userData = this;
			final_body.SetUserData(this);
		}
		
		public function destroyPhysBody():void
		{
			if(exists){
				exists = false;
				//We might not need to save shape as destroy body should work already...
				//final_body.DestroyShape(final_shape);
				_world.DestroyBody(final_body);
				final_shape = null;
				final_body = null;
			}
		}
		
		override public function update():void
		{
			super.update();
			var posVec:b2Vec2 = final_body.GetPosition();
			x = posVec.x - width/2;//_bw/2;
			y = posVec.y - height/2;//_bh/2;
			
			angle = final_body.GetAngle();
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
		
		public function setImpactPoint(point:b2Vec2):void{
			impactPoint.x = point.x;
			impactPoint.y = point.y;
		}
	}
}