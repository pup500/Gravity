/**
 * @author Mint
 * @author Pup
 */
package com.adamatomic.Mode {
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxG;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class GravityObj extends FlxBlock{
		private var _g:Number;
		private var _gDefault:Number;
		private var _hasG:Boolean;
		private var _mass:int;
		private var _radius:int;
		private var _coolDown:Timer;
			
		public function GravityObj(X:int,Y:int,Width:uint,Height:uint,TileGraphic:Class,Empties:uint=0) {
			super(X,Y,Width,Height,TileGraphic,Empties);
			_coolDown = new Timer(3000,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
		}
		
		public function affectGravity($amount:Number):void{
			_g += $amount;
			//trace(_g);
			FlxG.log("Gravity: "+_g);
			_coolDown.start();
		}
		
		private function stopTimer($e:Event):void{
			_g = _gDefault;
			FlxG.log("Gravity End : "+_g);
		}
		
		//Probably don't need these because we aren't going to use collide on them...
		//Actually player will...
		override public function hitWall():Boolean { return true; }
		override public function hitFloor():Boolean { return true; }
		override public function hitCeiling():Boolean { return true; }
	}

}