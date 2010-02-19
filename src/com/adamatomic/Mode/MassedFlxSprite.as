package com.adamatomic.Mode 
{
	import com.adamatomic.Mode.Massed;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Steve Shipman
	 */
	public class MassedFlxSprite extends FlxSprite implements Massed
	{
		protected var _mass:Number;
		
		public function MassedFlxSprite(X:int=0,Y:int=0,Graphic:Class=null) 
		{
			super(X, Y, Graphic);
			//super(Graphic,X,Y,Animated,Reverse, Width, Height, Color);
		}
		
		public function get xpos():Number {
			return x;
		}
		
		public function get ypos():Number {
			return y;
		}
		
		public function getMass():Number {
			return _mass;
		}
		
		public function get accel():Point {
			return acceleration;
		}
		
	}

}