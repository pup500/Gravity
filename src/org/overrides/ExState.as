package org.overrides
{
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;

	public class ExState extends FlxState
	{
		public var the_world:b2World;

		public function ExState()
		{
			super();
			
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(0.0, 0.0);
			environment.upperBound.Set(1000, 1000);//320.0, 240.0);
			var gravity:b2Vec2=new b2Vec2(0.0,50.0);
			
			the_world = new b2World(environment, gravity, true);
		}
		
		override public function update():void
		{
			//the_world.Step(FlxG.elapsed, 10);
			the_world.Step(1/30, 10);
			_layer.update();
		}
	}
}