package PhysicsLab 
{
	import org.overrides.ExSprite;
		import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Cannon extends ExSprite
	{
		[Embed(source = "../data/bot.png")] private var sprite:Class;
		
		private var _bullets:Array;
		private var _curBullet:uint;
		public function Cannon(x:int, y:int)
		{
			super(x, y);
			loadGraphic(sprite, true);
			_curBullet = 0;
		}
		
		override public function update():void
		{
			super.update();
			angle = -Math.atan2(x- FlxG.mouse.x , y-FlxG.mouse.y );//Math.atan((FlxG.mouse.y - y)/(FlxG.mouse.x - x));
			
			if (FlxG.mouse.justPressed())
			{
				shootBullet();
			}
		}
		
		public function SetBullets(bullets:Array):void{
			_bullets = bullets;
		}
		
		protected function shootBullet():void 
		{
			var angle:Point = new Point(FlxG.mouse.x - x, FlxG.mouse.y - y);
			var dist:Number = Math.sqrt(angle.x * angle.x + angle.y * angle.y);
				
			_bullets[_curBullet].shoot(x, y, 10 * angle.x / dist, 10 * angle.y / dist, false);
			if(++_curBullet >= _bullets.length)
				_curBullet = 0;
		}
	}

}