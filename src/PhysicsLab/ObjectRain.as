package PhysicsLab 
{
	import org.overrides.*;
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	//For box2d's debug rendering.
	import flash.display.Sprite;
	//Timer to rain physical objects every second.
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class ObjectRain extends ExState
	{
		[Embed(source="../data/spaceman.png")] private var playerSprite:Class;
		
		private var b2:ExSprite;
		private var time_count:Timer=new Timer(1000);
		
		public function ObjectRain() 
		{
			super();
			
			//--Box2D's Debug rendering--//
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			addChild(debug_sprite);
			debug_draw.m_sprite=debug_sprite;
			debug_draw.m_drawScale=1;
			debug_draw.m_fillAlpha=0.5;
			debug_draw.m_lineThickness=1;
			debug_draw.m_drawFlags=b2DebugDraw.e_shapeBit;
			the_world.SetDebugDraw(debug_draw);
			//-------------------------//
			
			//Platform for raining objects to interact with.
			b2 = new ExSprite(150, 150, playerSprite);
			b2._shape.density = 0; //0 density makes object stationary.
			b2._shape.SetAsBox(75, 10);
			b2.createPhysBody(the_world); //Add b2 as a physical body to Box2D's world.
			add(b2); //Add b2 as a sprite to Flixel's update loop.
			
			//Timer to rain physical objects every second.
			time_count.addEventListener(TimerEvent.TIMER, on_time);
			time_count.start();
		}
		
		public function on_time(e:Event):void {
			var body:ExSprite = new ExSprite(Math.random()*300+10, 0, playerSprite);
			body.createPhysBody(the_world);
			add(body);
		}
	}

}