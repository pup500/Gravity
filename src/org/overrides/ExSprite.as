package org.overrides
{
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ExSprite extends FlxSprite
	{
		public var _body:b2BodyDef;
		public var _shape:b2PolygonDef;
		public var final_body:b2Body;
		
		public function ExSprite(x:int=0, y:int=0, sprite:Class=null)
		{
			super(x, y, sprite);
			
			_body = new b2BodyDef();
			_body.position.Set(x, y);
			
			_shape = new b2PolygonDef();
			
		}
		
		public function initShape():void {
			_shape.SetAsBox(width/2, height/2); 
			_shape.friction = 0.3;
			_shape.density = 1;
		}
		
		public function createPhysBody(world:b2World):void
		{
			final_body=world.CreateBody(_body);
			final_body.CreateShape(_shape);
			final_body.SetMassFromShapes();
		}
		
		override public function update():void
		{
			super.update();
			var posVec:b2Vec2 = final_body.GetPosition();
			x = posVec.x - _bw/2;
			y = posVec.y - _bh/2;
			
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
	}

}