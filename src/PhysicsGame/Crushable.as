package PhysicsGame 
{
	import flash.events.TimerEvent;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Crushable extends ExSprite
	{
		[Embed(source = "../data/gibs.png")] private var ImgGibs:Class;
		[Embed(source = "../data/sheepgibs.png")] private var ImgSheepGibs:Class;
		public var beingCrushed:Boolean;
		public var crushed:Boolean;
		public var cleft:Boolean;
		public var cright:Boolean;
		
		private var _crushingGibs:FlxEmitter;
		private var _gibs:FlxEmitter;
		
		private var _dyingTimer:Timer;
		
		public function Crushable(x:int=0, y:int=0, sprite:Class=null)
		{
			super(x, y, sprite);
			crushed = false;
			beingCrushed = false;
			cleft = false;
			cright = false;
			
			_crushingGibs = new FlxEmitter(0, 0, -1);
			_crushingGibs.createSprites(ImgGibs, 6);
			FlxG.state.add(_crushingGibs);
			
			_gibs = new FlxEmitter(0, 0,-.1);
			_gibs.createSprites(ImgSheepGibs, 4);
			FlxG.state.add(_gibs);
			
			_dyingTimer = new Timer(1000,1);
			_dyingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCrush);
		}
		
		override public function update():void
		{
			super.update();
			
			if (cleft && cright)
			{
				crushed = true;
				flicker(1);
				//kill();
				_dyingTimer.start();
			}
			
			cleft = false;
			cright = false;
			
			if (crushed)
			{
				_crushingGibs.reset(x + width / 2, y + height / 2);
			}
		}
		
		private function onCrush(event:TimerEvent):void
		{
			kill();
		}
		
		override public function kill():void
		{
			_crushingGibs.kill();
			
			super.kill();
			_gibs.reset(x + width / 2, y + height / 2);
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture,  oFixture:b2Fixture):void
		{
			super.setImpactPoint(point, myFixture, oFixture);
			
			//trace("localPlaneNormal x:" + point.GetManifold().m_localPlaneNormal.x);
			//trace("localPlaneNormal y:" + point.GetManifold().m_localPlaneNormal.y);
			
			if(!cright)
				cright = point.GetManifold().m_localPlaneNormal.x >= .7;
			if(!cleft)
				cleft = point.GetManifold().m_localPlaneNormal.x <= -.7;
		}
	}

}