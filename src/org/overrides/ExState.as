package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import PhysicsGame.Wrappers.WorldWrapper;
	
	import common.XMLMap;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxCore;
	import org.flixel.FlxG;
	import org.flixel.FlxLayer;
	import org.flixel.FlxState;

	public class ExState extends FlxState
	{
		protected var debug:Boolean;
		public var debug_sprite:Sprite;
		
		protected var _bgLayer:FlxLayer;
		protected var _fgLayer:FlxLayer;
		protected var _evLayer:FlxLayer;
		
		protected var args:Dictionary;
		protected var xmlMapLoader:XMLMap;
		
		public static const BG:uint = 0;
		public static const MG:uint = 1;
		public static const FG:uint = 2;
		public static const EV:uint = 3;
		
		public static const PHYS_SCALE:Number = 30;
		
		public function ExState()
		{
			super();
			_bgLayer = new FlxLayer();
			_fgLayer = new FlxLayer();
			_evLayer = new FlxLayer();
			
			var gravity:b2Vec2 = new b2Vec2(0.0, 10);
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			var the_world:b2World;
			the_world = new b2World(gravity, doSleep);
			the_world.SetWarmStarting(true);
			WorldWrapper.the_world = the_world;
			
			debug = false;
			
			debug_sprite = new Sprite();
			
			ev.visible = false;
			
			args = new Dictionary();
			xmlMapLoader = new XMLMap(this);
		}
		
		//This function is used to signal that the state has finished loading
		public function init():void{
			
		}
		
		/*
		public function getController():b2Controller{
			return _worldWrapper.controller;
		}
		*/
		
		public function getArgs():Dictionary{
			return args;
		}
		
		public function getXMLLoader():XMLMap{
			return xmlMapLoader;
		}
		
		protected function initBox2DDebugRendering():void
		{
			if(debug){
				var debug_draw:b2DebugDraw = new b2DebugDraw();
				addChild(debug_sprite);
				debug_draw.SetSprite(debug_sprite);
				debug_draw.SetDrawScale(PHYS_SCALE);
				debug_draw.SetAlpha(1);
				debug_draw.SetLineThickness(2);
				debug_draw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_jointBit);
				WorldWrapper.setDebugDraw(debug_draw);
			}
		}
		
		override public function update():void
		{
			WorldWrapper.update();
			
			_bgLayer.update();
			super.update();
			_fgLayer.update();
			
			_evLayer.update();
			
			//For the physics....
			debug_sprite.x = FlxG.scroll.x;
			debug_sprite.y = FlxG.scroll.y;
			
			xmlMapLoader.update();
		}
		
		public function addToLayer(Core:FlxCore, layer:uint=0):FlxCore
		{
			switch(layer){
				case BG: return _bgLayer.add(Core);
				case MG: return _layer.add(Core);
				case FG: return _fgLayer.add(Core);
				case EV: return _evLayer.add(Core);
			}
			
			return null;
		}
		
		override public function render():void{
			if(_bgLayer.visible) _bgLayer.render();	
			if(_layer.visible) super.render();
			if(_fgLayer.visible) _fgLayer.render();
			if(_evLayer.visible) _evLayer.render();
			
			WorldWrapper.render();
		}
		
		/*
		public function get worldWrapper():WorldWrapper{
			return _worldWrapper;
		}
		*/
		
		public function get bg():FlxLayer{ return _bgLayer;}
		public function get mg():FlxLayer{ return _layer;}
		public function get fg():FlxLayer{ return _fgLayer;}	
		public function get ev():FlxLayer{ return _evLayer;}	
	}
}