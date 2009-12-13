/**
 * @author Mint
 * @author Pup
 */
package com.adamatomic.Mode {
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxG;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import flash.events.*;
	import flash.utils.Timer;
	
	public class GravityObj extends FlxBlock{
		private var _g:Number;
		private var _gDefault:Number;
		private var _hasG:Boolean;
		private var _mass:int;
		private var _radius:int;
		private var _coolDown:Timer;
		private var _localPix:BitmapData;
		private var _filter:ColorMatrixFilter;
		static private var maxMass:Number = 10000; //arbitrary, but corresponds to gravity assigned in NewPlayState.bulletHitBlocks
		static private var lessGravTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, -1, 0, 0, 0);
		static private var origin:Point = new Point();
			
		public function GravityObj(X:int,Y:int,Width:uint,Height:uint,TileGraphic:Class,Empties:uint=0) {
			super(X, Y, Width, Height, TileGraphic, Empties);
			_filter = new ColorMatrixFilter();
			_localPix = _pixels.clone();
			_mass = 0;
			_coolDown = new Timer(50,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
		}
		
		public function getMass():int{
			return _mass;
		}
		
		public function affectGravity($amount:Number):void {
		    trace("affectGravity, rects.length: ", _rects.length);	
			_g += $amount;
			_mass += $amount;
			applyVisual();
			//trace(_g);
			FlxG.log("Gravity: "+_g);
			_coolDown.start();
		}
		
		private function applyVisual():void {
			var mat:Array = _filter.matrix;
			mat[4] = (_mass / maxMass) * 256; //red offset
			_filter.matrix = mat;
			for(var i:uint = 0; i < _rects.length; i++)
			{
				if (_rects[i] != null) {
					_localPix.applyFilter(_pixels, _rects[i], origin, _filter);
				}
			}
		}
		
		override public function render():void
		{
			super.render();
			getScreenXY(_p);
			var opx:int = _p.x;
			for(var i:uint = 0; i < _rects.length; i++)
			{
				if(_rects[i] != null) FlxG.buffer.copyPixels(_localPix,_rects[i],_p,null,null,true);
				_p.x += _tileSize;
				if(_p.x >= opx + width)
				{
					_p.x = opx;
					_p.y += _tileSize;
				}
			}
		}
		
		private function stopTimer($e:Event):void{
			_g = _gDefault;
			
			_mass -= 200;
			if (_mass < 0) {
				_mass = 0;
			}
			else {
				_coolDown.reset();
				_coolDown.start();
			}
			applyVisual();
			FlxG.log("Gravity End : "+_g);
		}
		
		
		//Probably don't need these because we aren't going to use collide on them...
		//Actually player will...
		override public function hitWall():Boolean { return true; }
		override public function hitFloor():Boolean { return true; }
		override public function hitCeiling():Boolean { return true; }
	}

}