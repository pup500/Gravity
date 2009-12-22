package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	//For box2d's debug rendering.
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.overrides.*;
	import org.flixel.*;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class PhysState extends ExState
	{
		[Embed(source="../data/spaceman.png")] private var playerSprite:Class;
		
		private var _map:MapBase;
		
		private var b2:ExSprite;
		private var time_count:Timer=new Timer(1000);
		
		public function PhysState() 
		{
			super();
			
			_map = new MapOneGap();
			for(var i:uint = 0; i < _map.mainLayer._sprites.length; i++){
				b2 = _map.mainLayer._sprites[i] as ExSprite;
				b2.createPhysBody(the_world);
				
				//Don't add the sprite because it doesn't have any graphics...
				//It should be taken care of in the tile map...
				//add(b2);
			}
			
			
			//_map.mainLayer
			
			//--Box2D's Debug rendering--//
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			addChild(debug_sprite);
			debug_draw.m_sprite=debug_sprite;
			debug_draw.m_drawScale=1;
			debug_draw.m_fillAlpha=0.5;
			debug_draw.m_lineThickness=1;
			debug_draw.m_drawFlags=b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit;
			the_world.SetDebugDraw(debug_draw);
			//-------------------------//
			
			/*
			//Platform for raining objects to interact with.
			b2 = new ExSprite(150, 150, playerSprite);
			b2.initShape();
			b2._shape.density = 0; //0 density makes object stationary.
			b2._shape.SetAsBox(175, 10);
			b2.createPhysBody(the_world); //Add b2 as a physical body to Box2D's world.
			add(b2); //Add b2 as a sprite to Flixel's update loop.
			
			b2 = new ExSprite(300, 10, playerSprite);
			b2.initShape();
			b2._shape.density = 0; //0 density makes object stationary.
			b2._shape.SetAsBox(10, 100);
			b2.createPhysBody(the_world); //Add b2 as a physical body to Box2D's world.
			add(b2); //Add b2 as a sprite to Flixel's update loop.
			*/
			
			
			var body:Player = new Player(150, 100, playerSprite);
			body.createPhysBody(the_world);
			add(body);
			
			//This works, in debug mode it looks weird but that's because of layer offset...
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,640,640);
			
			//Timer to rain physical objects every second.
			time_count.addEventListener(TimerEvent.TIMER, on_time);
			time_count.start();
			
			//add(_map.mainLayer);
		}
		
		public function on_time(e:Event):void {
			var body:ExSprite = new ExSprite(Math.random()*300+10, 0, playerSprite);
			body.loadGraphic(playerSprite,true, true, 8);
			body.width = 8;
			body.height = 8;
			body.initShape();
			body.createPhysBody(the_world);
			add(body);
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}