package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class GravityObject extends ExSprite
	{
		[Embed(source="../data/GravSink.png")] private var GravSink:Class;
		
		//protected var _world:b2World;
		public var mass:Number;
		private var initialMass:Number = 50000;
		
		private var _coolDown:Timer;
		private var _startLosingMass:Boolean;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function GravityObject(world:b2World)
		{
			super();
			loadGraphic(GravSink, true);
			initShape();
			//shape.friction = 1;
			shape.density = 0;
			shape.isSensor = true;
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			shape.filter.groupIndex = -2;
			
			name = "GravityObject";
			
			_world = world; //For use when we shoot.
			
			offset.x = 1;
			offset.y = 1;
			exists = false;
			
			_startLosingMass = false;
			
			addAnimation("idle",[0], 50);
			//addAnimation("poof",[2, 3, 4], 50, false);
			
			_coolDown = new Timer(1000,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
		}
		
		private function onTimer(event:TimerEvent):void{
			_startLosingMass = true;
		}
		
		override public function update():void
		{
			if(dead && finished){
				destroyPhysBody();
			}
			else { 
				super.update();
				trace("X: " + x + ", " + y);
				
				if(_startLosingMass){
					mass -= 5000 * FlxG.elapsed;
					if(mass < 0){
						dead = true;
					}
					alpha = mass/ initialMass;
				}
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			destroyPhysBody();
			
			body.position.Set(X, Y);
			createPhysBody(_world);
			
			mass=initialMass;
			
			play("idle");
			_coolDown.reset();
			_coolDown.start();
			
			super.reset(X,Y);
		}
		
		override public function render():void
		{
			//Somehow super render doesn't line up...
			
			super.render();
			if(!visible)
				return;
			getScreenXY(_p);

			var myShape:Shape = new Shape();
			myShape.graphics.beginFill(_startLosingMass ? 0x00ff00 : 0x0000ff,alpha/3+.1);
			myShape.graphics.lineStyle(1,0x00ff00,alpha/3+.1);
			myShape.graphics.drawCircle(_p.x,_p.y, alpha*50);
			myShape.graphics.endFill();
			FlxG.buffer.draw(myShape);
		}
	}

}