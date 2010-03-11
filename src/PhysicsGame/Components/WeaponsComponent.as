package PhysicsGame.Components
{
	import PhysicsGame.Bullet;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;
	
	public class WeaponsComponent implements IComponent
	{
		[Embed(source="../../data/asplode.mp3")] private var SndExplode:Class;
		
		protected var me:ExSprite;
		
		protected var _bullets:Array;
		protected var _antiGravity:Boolean;
		protected var _bulletVel:Number;
		protected var _canShoot:Boolean;
		protected var _coolDown:Timer;
		protected var _curBullet:uint;
		
		
		//TODO:Change this into ExSprite
		public function WeaponsComponent(obj:ExSprite, bullets:Array)
		{
			me = obj;
			
			_bullets = bullets;
			
			_antiGravity = false;
			_curBullet = 0;
			_bulletVel = 20;
			_canShoot = true;
			_coolDown = new Timer(500,1);
			_coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, stopTimer);
		}

		public function update():void
		{
			if (FlxG.keys.justPressed("F"))
			{
				FlxG.play(SndExplode);
				
				_antiGravity = !_antiGravity;
			}
			
			if (FlxG.keys.justPressed("Q"))
			{
				FlxG.play(SndExplode);
				
				for each(var bullet:Bullet in _bullets)
				{
					bullet.killGravityObject();
				}
			}
			
			if(FlxG.mouse.justPressed() && _canShoot){
				FlxG.log("mouse x: " + FlxG.mouse.x + " mouse y: " + FlxG.mouse.y);
				FlxG.log("player x: " + me.x + " player y: " + me.y);
				
				var angle:Point = new Point(FlxG.mouse.x - me.x, FlxG.mouse.y - me.y);
				var dist:Number = Math.sqrt(angle.x * angle.x + angle.y * angle.y);
				
				FlxG.log("angle.x: " + angle.x + " angle.y: " + angle.y);
				FlxG.log("dist" + dist);
				
				me.facing = angle.x > 0 ? FlxSprite.RIGHT : angle.x < 0 ? FlxSprite.LEFT : me.facing;
				
				var bX:Number = me.x + me.width/2;
				var bY:Number = me.y + me.height*.2;
				
				//Shoot it!!
				_bullets[_curBullet].shoot(bX,bY,_bulletVel * angle.x/dist, _bulletVel * angle.y/dist, _antiGravity);
				//Set the next bullet to be shot to the first in the array for recycling.
				if(++_curBullet >= _bullets.length)
					_curBullet = 0;
				
				//Maybe we should try to work with elapsed time instead of creating timer events...
				_canShoot = false;
				_coolDown.reset();
				_coolDown.start();
			}
		}
		
		private function stopTimer($e:TimerEvent):void{
			_canShoot = true;
		}
		
		public function receive(args:Object):Boolean{
			return false;
		}
	}
}