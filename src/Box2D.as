package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Box2D extends Sprite {
		public var the_world:b2World;
		private var time_count:Timer=new Timer(1000);
		public function Box2D() {
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(-100.0, -100.0);
			environment.upperBound.Set(100.0, 100.0);
			var gravity:b2Vec2=new b2Vec2(0.0,10.0);
			
			the_world=new b2World(environment,gravity,true);
			
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			
			addChild(debug_sprite);
			debug_draw.m_sprite=debug_sprite;
			debug_draw.m_drawScale=30;
			debug_draw.m_fillAlpha=0.5;
			debug_draw.m_lineThickness=1;
			debug_draw.m_drawFlags=b2DebugDraw.e_shapeBit;
			the_world.SetDebugDraw(debug_draw);
			
			var final_body:b2Body;
			var the_body:b2BodyDef;
			var the_box:b2PolygonDef;
			the_body = new b2BodyDef();
			the_body.position.Set(8.5, 13);
			the_box = new b2PolygonDef();
			the_box.SetAsBox(8.5, 0.5);
			the_box.friction=0.3;
			the_box.density=0;
			
			final_body=the_world.CreateBody(the_body);
			final_body.CreateShape(the_box);
			final_body.SetMassFromShapes();
			
			addEventListener(Event.ENTER_FRAME, on_enter_frame);
			time_count.addEventListener(TimerEvent.TIMER, on_time);
			time_count.start();
 
		}
		
		public function on_time(e:Event):void {
			var final_body:b2Body;
			var the_body:b2BodyDef;
			var the_box:b2PolygonDef;
			the_body = new b2BodyDef();
			the_body.position.Set(Math.random()*10+2, 0);
			the_box = new b2PolygonDef();
			the_box.SetAsBox(Math.random()+0.1,Math.random()+0.1);
			the_box.friction=0.3;
			the_box.density=1;
			final_body=the_world.CreateBody(the_body);
			final_body.CreateShape(the_box);
			final_body.SetMassFromShapes();
		}
		
		public function on_enter_frame(e:Event):void {
			the_world.Step(1/30, 10);
		}
	}
}