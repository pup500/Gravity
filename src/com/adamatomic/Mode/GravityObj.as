/**
 * @author Mint
 */
package com.adamatomic.Mode {
	import com.adamatomic.flixel.FlxSprite;
	
	public class GravityObj extends FlxSprite{
		var grav:Number;
		var hasGrav:Boolean;
		var mass:int;
		var radius:int;
		var coolDown:Timer;
		var DEFAULT_GRAV:Number;
			
		public function GravityObj() {
			coolDown = new Timer(3000,1);
			coolDown.addEventListener(Timer.TIMER_COMPLETE, stopTimer);
		}
		
		public function afffectGravity(value:Number):void{
			grav += value;
			trace(grav);
			coolDown.start();
		}
		
		private function stopTimer(e:Event):void{
			grav = DEFAULT_GRAV;
		}
	}

}