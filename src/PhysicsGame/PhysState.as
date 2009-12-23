package PhysicsGame
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * Rains physics objects onto a stationary object.
	 * @author Norman
	 */
	public class PhysState extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		[Embed(source = "../data/bot.png")] private var botSprite:Class;
		
		private var _map:MapBase;
		private var _bullets:Array;
		private var b2:ExSprite; //For creating environment physical objects.
		private var time_count:Timer=new Timer(1000);
		private var spawned:uint = 0;
		
		public function PhysState() 
		{
			super();
			
			var i:uint; //For the loops.
			
			_map = new MapOneGap();
			for(i= 0; i < _map.mainLayer._sprites.length; i++){
				b2 = _map.mainLayer._sprites[i] as ExSprite;
				b2.createPhysBody(the_world);
				
				//Don't add the sprite because it doesn't have any graphics...
				//It should be taken care of in the tile map...
				//add(b2);
			}
			add(_map.mainLayer);
			
			_bullets = new Array();
			var body:Player = new Player(150, 100, _bullets);
			body.createPhysBody(the_world);
			body.final_body.AllowSleeping(false);
			add(body);
			
			//Create bullets
			for(i= 0; i < 8; i++){
				_bullets.push(this.add(new Bullet(the_world)));
				//don't create physical body, wait till bullet is shot.
			}
			
			//Set camera to follow player movement.
			//This works, in debug mode it looks weird but that's because of layer offset...
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,640,640);
			
			FlxG.showCursor(cursorSprite);
			
			//--Debug stuff--//
			initBox2DDebugRendering();
			//createDebugPlatform();
			//Timer to rain physical objects every second.
			//time_count.addEventListener(TimerEvent.TIMER, on_time);
			//time_count.start();
		}
		
		public function on_time(e:Event):void {
			//Create an ExSprite somewhere above the screen so it falls downward.
			var body:ExSprite = new ExSprite(Math.random()*300+10, 0, botSprite);
			body.loadGraphic(botSprite,true, true); //Loading again to set animation.
			body.initShape();
			body.createPhysBody(the_world);
			add(body);
			
			spawned++;
			FlxG.log("item spawned" + spawned);
		}
		
		private function initBox2DDebugRendering():void
		{
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new flash.display.Sprite();
			addChild(debug_sprite);
			debug_draw.m_sprite=debug_sprite;
			debug_draw.m_drawScale=1;
			debug_draw.m_fillAlpha=0.5;
			debug_draw.m_lineThickness=1;
			debug_draw.m_drawFlags=b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit;
			the_world.SetDebugDraw(debug_draw);
		}
		
		private function createDebugPlatform():void
		{
			//Platform for raining objects to interact with.
			b2 = new ExSprite(150, 150, botSprite);
			b2.initShape();
			b2.shape.density = 0; //0 density makes object stationary.
			b2.shape.SetAsBox(175, 10);
			b2.createPhysBody(the_world); //Add b2 as a physical body to Box2D's world.
			add(b2); //Add b2 as a sprite to Flixel's update loop.
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}