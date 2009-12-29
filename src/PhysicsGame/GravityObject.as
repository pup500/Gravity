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
	import flash.display.GradientType;
	
	import flash.geom.*
  	import flash.display.*

	
	/**
	 * ...
	 * @author Norman
	 */
	public class GravityObject extends ExSprite
	{
		[Embed(source="../data/GravSink.png")] private var GravSink:Class;
		
		//protected var _world:b2World;
		public var mass:Number;
		private var initialMass:Number = 5000;//50000;
		
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
			
			addAnimation("idle",[0, 1, 2, 3], 12);
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
		
		public function selfDestruct():void{
			dead = true;
			finished = true;
		}
		
		//Don't mess with hurt... this affects collision...
		override public function hurt(Damage:Number):void
		{
			//dead = true;
			//finished = true;
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
			if(!visible)
				return;
			getScreenXY(_p);

			var myShape:Shape = new Shape();
			myShape.graphics.beginFill(0x669933, alpha/2);//alpha/3+.1);
			
			//TODO:See if we can get radient to work.....
			/*
			var colors:Array = [0x00ff00, 0x000000];
			
			var alphas:Array = [1, .5]
			
			var ratios:Array = [127, 255];
			
			var matr:Matrix = new Matrix();
  			matr.createGradientBox(20, 20, 0, 0, 0);
  			var spreadMethod:String = SpreadMethod.PAD;
  			
			myShape.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matr, spreadMethod,"rgb",.75);
			//myShape.graphics.lineStyle(1,0x00ff00,alpha/3+.1);
			myShape.graphics.drawCircle(_p.x + width/2,_p.y + height/2, alpha*50);
			myShape.graphics.endFill();
			FlxG.buffer.draw(myShape);
			
			*/
			/*
			var fillType:String = GradientType.RADIAL;
			  var colors:Array = [0xFF0000, 0x0000FF];
			  var alphas:Array = [1, 1];
			  var ratios:Array = [0x00, 0xFF];
			  var matr:Matrix = new Matrix();
			  //matr.createGradientBox(20, 20, 0, 0, 0);
			  matr.createGradientBox(50,50,0);
			  var spreadMethod:String = SpreadMethod.PAD;
			  myShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			  
			  //myShape.graphics.drawRect(_p.x + width/2,_p.y + height/2, 100, 100);
			 */ 
			 
			  myShape.graphics.drawCircle(_p.x + width/2,_p.y + height/2, alpha*50);
			myShape.graphics.endFill();
			  FlxG.buffer.draw(myShape);
			
			super.render();
			
		}
	}

}