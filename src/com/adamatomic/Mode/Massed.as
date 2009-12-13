package com.adamatomic.Mode 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Steve Shipman
	 * @url	http://cosmodro.me
	 */
	public interface Massed 
	{
		function getMass():Number;
		function get xpos():Number;
		function get ypos():Number;
		function get accel():Point;
	}
	
}