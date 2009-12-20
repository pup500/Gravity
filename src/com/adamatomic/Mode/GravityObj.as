package com.adamatomic.Mode 
{
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.Mode.MassedFlxSprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Steve Shipman
	 */
	public class GravityObj extends MassedFlxSprite implements IEventDispatcher
	{
		[Embed(source = '../../../data/GravSink.png')]
		private var ImgGravSink:Class;
		
		private var _coolDown:Timer;
		private var _dispatcher:EventDispatcher;
		private var initialMass:Number = 5000;
		
		public function GravityObj(X:int = 0,Y:int = 0) 
		{
			super(ImgGravSink, X, Y);
			_mass = initialMass;
			
			_dispatcher = new EventDispatcher(this);
			_coolDown = new Timer(50,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
		}
		
		/**
		 * called when re-added from active pool
		 */
		public function reset():void {
			exists = true;
			alpha = 1;
			_mass = initialMass;
			_coolDown.reset();
			_coolDown.start();
		}
		
		private function stopTimer($e:TimerEvent):void{
			_mass -= 100;
			if (_mass < 0) {
				_mass = 0;
				kill();
			}
			else {
				alpha = _mass / initialMass;
				
				//scale.x = (_mass / initialMass) * 20;
				//scale.y = (_mass / initialMass) * 20;
				
				_coolDown.reset();
				_coolDown.start();
			}
		}
		
		override public function kill():void {
			super.kill();
			dispatchEvent(new Event("die"));
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
				
		
	}

}