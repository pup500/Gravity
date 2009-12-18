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
		
		public function MassedFlxSprite(Graphic:Class=null,X:int=0,Y:int=0,Animated:Boolean=false,Reverse:Boolean=false,Width:uint=0,Height:uint=0,Color:uint=0) 
		{
			super(Graphic,X,Y,Animated,Reverse, Width, Height, Color);
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