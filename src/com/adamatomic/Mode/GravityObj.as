/**
 * @author Mint
 * @author Pup
 */
package com.adamatomic.Mode {
	import com.adamatomic.flixel.FlxSprite;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class GravityObj extends FlxSprite{
		private var _g:Number;
		private var _gDefault:Number;
		private var _hasG:Boolean;
		private var _mass:int;
		private var _radius:int;
		private var _coolDown:Timer;
			
		public function GravityObj() {
			_coolDown = new Timer(3000,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
		}
		
		public function afffectGravity($amount:Number):void{
			_g += $amount;
			trace(_g);
			_coolDown.start();
		}
		
		private function stopTimer($e:Event):void{
			_g = _gDefault;
		}
	}

}