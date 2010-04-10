package PhysicsGame 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.overrides.ExSprite;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	
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
		
		public function Crushable(x:int=0, y:int=0, sprite:Class=null)
		{
			super(x, y, sprite);
			crushed = false;
			beingCrushed = false;
			cleft = false;
			cright = false;
			
			_crushingGibs = new FlxEmitter(x, y, .4);
			_crushingGibs.createSprites(ImgGibs, 6);
			_gibs = new FlxEmitter(x, y,-.1);
			_gibs.createSprites(ImgSheepGibs, 4);
			FlxG.state.add(_gibs);
		}
		
		override public function update():void
		{
			super.update();
			
			if (cleft && cright)
			{
				crushed = true;
				//flicker(1);
				kill();
			}
			
			cleft = false;
			cright = false;
		}
		
		override public function kill():void
		{
			//var gibs:FlxEmitter = new FlxEmitter(x, y);
			//gibs.loadSprites([new FlxSprite(0,0,ImgGibs)]);
			//FlxG.state.add(gibs);
			
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