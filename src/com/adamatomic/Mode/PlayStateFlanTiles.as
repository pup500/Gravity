package com.adamatomic.Mode
{
	import com.adamatomic.flixel.*;

	public class PlayStateFlanTiles extends FlxState
	{
		[Embed(source="../../../data/mode.mp3")] private var SndMode:Class;
		
		//PUT THE FOLLOWING INSIDE YOUR DERIVED FlxState CLASS (i.e. under 'class MyState { ...')
		private var _map:MapBase;

		//major game objects
		//private var _tilemap:FlxTilemap;
		private var _bullets:FlxArray;
		private var _player:Player;
		private var _gravityObjs:FlxArray;
		
		function PlayStateFlanTiles():void
		{
			super();
			
			//Load the Flan Map.
			_map = new MapSmallOnePlatform();
			
			//Add the background (a bit hacky but works)
			//var bgColorSprite:FlxSprite = new FlxSprite(null, 0, 0, false, false, FlxG.width, FlxG.height, _map.bgColor);
			//bgColorSprite.scrollFactor.x = 0;
			//bgColorSprite.scrollFactor.y = 0;
			//FlxG.state.add(bgColorSprite);

			//Add the layers to current the FlxState
			FlxG.state.add(_map.layerBackground);
			_map.addSpritesToLayerBackground(onAddSpriteCallback);
			FlxG.state.add(_map.layerMain);
			_map.addSpritesToLayerMain(onAddSpriteCallback);
			FlxG.state.add(_map.layerForeground);
			_map.addSpritesToLayerForeground(onAddSpriteCallback);

			FlxG.followBounds(_map.boundsMinX, _map.boundsMinY, _map.boundsMaxX, _map.boundsMaxY);

			//create player and bullets
			_bullets = new FlxArray();
			//_player = new Player(_tilemap.width/2-4,_tilemap.height/2-4,_bullets);
			_player = new Player(100,_map.layerMain.height/2-4,_bullets);
			
			//Add instantiated elements to rendering loop.
			//add background before anything else so it doesn't overlap anything.
			this.add(_map.layerBackground);
			
			_player.addAnimationCallback(AnimationCallbackTest);
			for(var i:uint = 0; i < 8; i++)
				_bullets.add(this.add(new Bullet()));
				
			//add player and set up camera
			this.add(_player);
			FlxG.follow(_player,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,640,640);
			
			//for(var j:uint = 0; j < 8; j++){
				// _gravityObjs.add(this.add(new GravityObj())); // I had to comment this line because of a "BitmapData" error.
			//}
			
			//_gravityObjs = new FlxArray();
			
			//for(var i2:uint = 0; i2 < 10; i2++){
			//	_gravityObjs.add(this.add(new GravityObj(Math.random()*500,Math.random()*150,10,10,ImgTech)));
			//}
			//_gravityObjs.add(this.add(new GravityObj(20,40,10,10,ImgTech)));
			//_gravityObjs.add(this.add(new GravityObj(80,80,10,10,ImgTech)));
			//_gravityObjs.add(this.add(new GravityObj(100,20,10,10,ImgTech)));

			this.add(_map.layerMain);
			this.add(_map.layerForeground);
			
			//turn on music and fade in
			//FlxG.setMusic(SndMode);
			FlxG.flash(0xff131c1b);
		}

		override public function update():void
		{
			super.update();
			//FlxG.collideArray2(_tilemap,_bullets);
			
			FlxG.collideArray2(_map.layerMain,_bullets);
			_map.layerMain.collide(_player);
			
			//FlxG.collideArrays(_gravityObjs,_bullets);
			//FlxG.collideArray(_gravityObjs,_player);
			
			updateGravity();
			
			//FlxG.overlapArrays(_bullets,_gravityObjs,bulletHitObj);
			
		}
		
		//Added for Flan Map loading. Not sure what it does.
		protected function onAddSpriteCallback(obj:FlxSprite):void
		{
			/*
			*/
		}
		
		//TODO: Encapsulate gravity logic so it is independant of PlayState
		private function updateGravity():void{
			_player.acceleration.x = 0;
			_player.acceleration.y = 100;
			for each(var gravObj:GravityObj in _gravityObjs)
			{
				if(gravObj.getMass() == 0) continue;
				
				var xDistance:Number = gravObj.x - _player.x;
				var yDistance:Number = gravObj.y - _player.y;
				var xDistanceSq:Number = xDistance * xDistance;
				var yDistanceSq:Number = yDistance * yDistance;
				var distanceSq:Number = xDistanceSq + yDistanceSq;
				
				if(distanceSq > 10000) continue;
				
				var distance:Number = Math.sqrt(xDistanceSq + yDistanceSq);
				var massProduct:Number = 100 * gravObj.getMass();	//_player.mass * gravObj.mass;
				
				var G:Number = 1; //gravitation constant
				
				var force:Number = G*(massProduct / distanceSq);
				
				_player.acceleration.x += force * (xDistance/distance);//xDistance >= 0 ? xForce :-xForce;
				_player.acceleration.y += force * (yDistance/distance);//yDistance >= 0 ? yForce :-yForce;
				
				FlxG.log("xDist:" + xDistance + " yDist:"+yDistance);
				FlxG.log("xDistSq:" + xDistanceSq + " yDistSq:"+yDistanceSq);
				FlxG.log("massProduct:" + massProduct);
				FlxG.log("distance:" + distance);
				//FlxG.log("force:" + force);
				//FlxG.log("xForce:" + xForce + " yForce:" + yForce);
			}
		}
		
		private function bulletHitObj(Bullet:FlxSprite,Obj:GravityObj):void
		{
			FlxG.log("BULLET HIT NAME: ");
			Bullet.hurt(0);
			Obj.affectGravity(100);
		}
		
		private function AnimationCallbackTest(Name:String, Frame:uint, FrameIndex:uint):void
		{
			FlxG.log("ANIMATION NAME: "+Name+", FRAME: "+Frame+", FRAME INDEX: "+FrameIndex);
		}
	}
}
