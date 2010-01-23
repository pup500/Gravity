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
		private var initialMass:Number = 20;//5000;//50000;
		private var deltaMass:Number = 10;
		
		private var distf:Number = 20;
		private var minf:b2Vec2 = new b2Vec2(-distf,-distf);
		private var maxf:b2Vec2 = new b2Vec2(distf,distf)
		
		public var antiGravity:Boolean;
		
		private var _coolDown:Timer;
		private var _startLosingMass:Boolean;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function GravityObject(world:b2World)
		{
			super();
			loadGraphic(GravSink, true);
			
			bodyDef.type = b2Body.b2_staticBody;
			
			fixtureDef.density = 0;
			fixtureDef.friction = 1;
			fixtureDef.isSensor = true;
			fixtureDef.filter.groupIndex = -2;
			
			initShape();
			
			//Make this part of group -2, and do not collide with other in the same negative group...
			
			name = "GravityObject";
			
			_world = world; //For use when we shoot.
			
			antiGravity = false;
			
			offset.x = 1;
			offset.y = 1;
			exists = false;
			
			_startLosingMass = false;
			
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
				
				if(_startLosingMass){
					mass -= deltaMass * FlxG.elapsed;
					if(mass < 0){
						mass = 0;
						dead = true;
					}
					alpha = mass/ initialMass;
				}
			}
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			destroyPhysBody();
			
			var scaledX:Number = X / ExState.PHYS_SCALE;
			var scaledY:Number = Y / ExState.PHYS_SCALE;
			
			bodyDef.position.Set(scaledX, scaledY);
			//trace("grav body def: " + X/ExState.PHYS_SCALE + ", " + Y/ExState.PHYS_SCALE);
			createPhysBody(_world);
			
			mass=initialMass;
			
			play("idle");
			_coolDown.reset();
			_coolDown.start();
			
			//Set point in here b/c GravObj won't be moving. We'll use this when we calculate the gravity force.
			gPoint = new Point(scaledX, scaledY);
			
			super.reset(X,Y);
			//trace("grav shoot : " + x + ", " + y);
		}
		
		override public function render():void
		{
			if(!visible)
				return;
			getScreenXY(_p);

			var myShape:Shape = new Shape();
			myShape.graphics.beginFill(antiGravity ? 0x990000 : 0x669933, alpha/2);//alpha/3+.1);
			
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
		private var gPoint:Point //= new Point(this.final_body.GetPosition().x, this.final_body.GetPosition().y);
		private var G:Number = 1; //gravitation constant
		public function GetGravityForce(physBody:b2Body):b2Vec2
		{
			var gMass:Number = this.mass;// Hack - use object's mass not physics mass because density = 0//this.final_body.m_mass;
			//moved gPoint outside of this function and set it in shoot() for optimization.
			var physBodyPoint:Point = new Point(physBody.GetPosition().x, physBody.GetPosition().y);
			var dist:Point = gPoint.subtract(physBodyPoint);
			var distSq:Number = dist.x * dist.x + dist.y * dist.y;
			
			//For performance reasons....  assume force is 0 when distance is pretty far
			//if(distSq > 40000 ) return new b2Vec2();
			
			//This is a physics hack to stop adding gravity to objects when they are too close
			//they aren't pulling anymore because of normal force
			//if(distanceSq < 100) continue;
			if(distSq < Number.MIN_VALUE)
				return new b2Vec2();
			
			//var distance:Number = Math.sqrt(distSq);
			var massProduct:Number = physBody.GetMass() * gMass;
			
			//Moved G definition out of function.
			
			var force:Number = G*(massProduct/distSq);
			
			//See if this is ok....
			//force = Math.log(force + 1) * 5;
			
			trace("force: " + force);
			trace("distsq: " + distSq);
			
			if(force > 100) force = 100;
			var impulse:b2Vec2 = new b2Vec2(force * dist.x, force * dist.y);//(force * (dist.x/distance), force * (dist.y/distance));
			
			if(!antiGravity)
				return impulse;
			else
				return impulse.GetNegative(); 
		}
		
		//@desc This function for gravity is based purely on the mass of the two objects
		//The distance factor determines the linear interpolation of distance to the two centers
		//Basically, the resulting force is from [0, obj1.mass*obj2.mass]
		public function GetGravityTestA(physBody:b2Body):b2Vec2
		{
			var p1:b2Vec2 = null;
			var mass1:Number = 0;
			var p2:b2Vec2 = null;
			var dx:Number = 0;
			var dy:Number = 0;
			var r2:Number = 0;
			var f:b2Vec2 = null;
			
			p1 = final_body.GetWorldCenter();
			p2 = physBody.GetWorldCenter()
			dx = p1.x - p2.x;
			dy = p1.y - p2.y;
			r2 = dx*dx+dy*dy;
			if(r2<Number.MIN_VALUE)
				return new b2Vec2();
			
			//maxDist is in physics unit, so 1 = 30 pixels
			var maxDist:Number = 5;
			var maxDistSq:Number = maxDist * maxDist;
			if(r2 > maxDistSq)
				return new b2Vec2();	
				
			f = new b2Vec2(dx, dy);
			
			var directionlessForce:Number = (this.mass * physBody.GetMass()) * (1-(r2/maxDistSq));
			trace("r2: " + r2);
			
			//Separate the force into x, y direction components.
			f.Multiply(directionlessForce);
			
			if (antiGravity)
				return f.GetNegative();
			else
				return f;
		}
		
		//@desc Using B2D's b2GravityController function. Tweaked with log scaling to make the forces smoother.
		public function GetGravityB2(physBody:b2Body):b2Vec2
		{
			var p1:b2Vec2 = null;
			var mass1:Number = 0;
			var p2:b2Vec2 = null;
			var dx:Number = 0;
			var dy:Number = 0;
			var r2:Number = 0;
			var f:b2Vec2 = null;
			
			p1 = final_body.GetWorldCenter();
			p2 = physBody.GetWorldCenter()
			dx = p1.x - p2.x;
			dy = p1.y - p2.y;
			r2 = dx*dx+dy*dy;
			if(r2<Number.MIN_VALUE)
				return new b2Vec2();
			
			f = new b2Vec2(dx, dy);
			
			//We're going to take this force and get it's log to scale it down to make the push/pull smoother.
			var directionlessForce:Number = G / r2 * this.mass * physBody.GetMass();
			directionlessForce = Math.log(directionlessForce + 1) * 5;
			
			//Separate the force into x, y direction components.
			f.Multiply(directionlessForce);
			
			//FlxG.log("f.x: " + f.x);
			////Check if force is exceeding extremes.
			//if (f.x > 100) f.x = 100;
			//else if (  f.x < -100 ) f.x = -100;
			//if (f.y > 100) f.y = 100;
			//else if (f.y < -100) f.y = -100;
			
			//Attempting force limits to prevent slingshotting, but isn't working. -Norman
			//f = b2Math.ClampV(f, minf, maxf);
			
			if (antiGravity)
				return f.GetNegative();
			else
				return f;
		}
	}

}