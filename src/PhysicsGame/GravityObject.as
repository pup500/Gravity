package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;

	
	/**
	 * ...
	 * @author Norman
	 */
	public class GravityObject extends ExSprite
	{
		[Embed(source="../data/GravSink.png")] private var GravSink:Class;
		
		//protected var _world:b2World;
		public var mass:Number;
		private var initialMass:Number = 4;//5000;//50000;
		
		public var antiGravity:Boolean;
		
		private var _coolDown:Timer;
		private var _startLosingMass:Boolean;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function GravityObject(world:b2World)
		{
			super();
			loadGraphic(GravSink, true);
			//shape.friction = 1;
			//shape.density = 0;
			fixtureDef.density = 0;
			fixtureDef.friction = 1;
			fixtureDef.isSensor = true;
			bodyDef.type = b2Body.b2_staticBody;
			
			initShape();
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			fixtureDef.filter.groupIndex = -2;
			
			name = "GravityObject";
			
			_world = world; //For use when we shoot.
			
			antiGravity = false;
			
			offset.x = 1;
			offset.y = 1;
			exists = false;
			
			_startLosingMass = false;
			
			
			//TODO:
			_startLosingMass = true;
			
			
			
			addAnimation("idle",[0, 1, 2, 3], 12);
			
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
				//trace("gravityX: " + x + ", " + y);
				trace("gravitymass:" + final_body.GetMass());
				
				if(_startLosingMass){
					mass -= 4 * FlxG.elapsed;
					if(mass < 0){
						dead = true;
					}
					alpha = mass/ initialMass;
				}
			}
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			destroyPhysBody();
			
			bodyDef.position.Set(X/ExState.PHYS_SCALE, Y/ExState.PHYS_SCALE);
			//trace("grav body def: " + X/ExState.PHYS_SCALE + ", " + Y/ExState.PHYS_SCALE);
			createPhysBody(_world);
			
			mass=initialMass;
			
			play("idle");
			_coolDown.reset();
			_coolDown.start();
			
			super.reset(X,Y);
			//trace("grav shoot : " + x + ", " + y);
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
		
		public function GetGravityForce(physBody:b2Body):b2Vec2
		{
			var gMass:Number = this.mass;// Hack - use object's mass not physics mass because density = 0//this.final_body.m_mass;
			var gPoint:Point = new Point(this.final_body.GetPosition().x, this.final_body.GetPosition().y);
			var physBodyPoint:Point = new Point(physBody.GetPosition().x, physBody.GetPosition().y);
			var dist:Point = gPoint.subtract(physBodyPoint);
			var distSq:Number = dist.x * dist.x + dist.y * dist.y;
			
			//For performance reasons....  assume force is 0 when distance is pretty far
			if(distSq > 40000 ) return new b2Vec2();
			
			//This is a physics hack to stop adding gravity to objects when they are too close
			//they aren't pulling anymore because of normal force
			//if(distanceSq < 100) continue;
			
			var distance:Number = Math.sqrt(distSq);
			var massProduct:Number = physBody.GetMass() * gMass;
			
			var G:Number = 1; //gravitation constant
			
			var force:Number = G*(massProduct/distSq);
			
			trace("force: " + force);
			
			if(force > 100) force = 100;
			if(force < 0) force = 100;
			
			//TODO:Force is powerful now....
			//force = 1;
			
			//trace(distance);
			//trace("mass: " + physBody.GetMass());
			//trace("dist:" + distance + " force:" + force + " forx:" + force * (dist.x/distance) + " fory:" + force * (dist.y/distance));
			
			var impulse:b2Vec2 = new b2Vec2(force * (dist.x/distance), force * (dist.y/distance));
			//impulse.Multiply(physBody.GetMass());
			
			//trace("impulsex: " + impulse.x + ", " + impulse.y);
			//trace("impulsex: " + impulse.x /physBody.GetMass() + ", " + impulse.y/physBody.GetMass());
			if(!antiGravity)
				return impulse;
			else
				return impulse.GetNegative(); 
		}
	}

}