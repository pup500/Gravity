package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	
	import org.flixel.FlxCore;
	import org.flixel.FlxG;
	import org.flixel.FlxLayer;
	import org.flixel.FlxState;

	public class ExState extends FlxState
	{
		public var the_world:b2World;
		protected var debug:Boolean;
		public var debug_sprite:Sprite;
		
		protected var _bgLayer:FlxLayer;
		protected var _fgLayer:FlxLayer;
		protected var _evLayer:FlxLayer;
		
		public var _loaded:Boolean;
		
		public static const BG:uint = 0;
		public static const MG:uint = 1;
		public static const FG:uint = 2;
		public static const EV:uint = 3;
		
		public function ExState()
		{
			super();
			_bgLayer = new FlxLayer();
			_fgLayer = new FlxLayer();
			_evLayer = new FlxLayer();
			
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(0.0, 0.0);
			environment.upperBound.Set(1280, 960);//320.0, 240.0);
			var gravity:b2Vec2=new b2Vec2(0.0,80.0);
			
			the_world = new b2World(environment, gravity, true);
			debug = false;
			
			_loaded = false;
			debug_sprite = new Sprite();
		}
		
		public function init():void{
			_loaded = true;
		}
		
		protected function initBox2DDebugRendering():void
		{
			if(debug){
				var debug_draw:b2DebugDraw = new b2DebugDraw();
				addChild(debug_sprite);
				debug_draw.SetSprite(debug_sprite);
				debug_draw.SetDrawScale(1);
				debug_draw.SetAlpha(1);
				debug_draw.SetLineThickness(2);
				debug_draw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_jointBit);
				the_world.SetDebugDraw(debug_draw);
			}
		}
		
		override public function update():void
		{
			//the_world.Step(FlxG.elapsed, 10);
			//the_world.Step(1/30, 10, 10);
			
			//This probably ensures constant physics regardless of framerate...
			the_world.Step(FlxG.elapsed, 10, 10);
			
			_bgLayer.update();
			super.update();
			_fgLayer.update();
			
			_evLayer.update();
			
			//For the physics....
			debug_sprite.x = FlxG.scroll.x;
			debug_sprite.y = FlxG.scroll.y;
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
		}
		
		protected function get bg():FlxLayer{ return _bgLayer;}
		protected function get mg():FlxLayer{ return _layer;}
		protected function get fg():FlxLayer{ return _fgLayer;}	
		protected function get ev():FlxLayer{ return _evLayer;}	
	}
}