package com.adamatomic.Mode
{
	import org.flixel.*;

	public class PlayStateTiles extends FlxState
	{
		[Embed(source="../../../data/mode.mp3")] private var SndMode:Class;
		[Embed(source="../../../data/gmap.txt",mimeType="application/octet-stream")] private var TxtMap:Class;
		[Embed(source="../../../data/map2.txt",mimeType="application/octet-stream")] private var TxtMap2:Class;
		[Embed(source="../../../data/tiles_all.png")] private var ImgTiles:Class;
		[Embed(source="../../../data/tech_tiles.png")] private var ImgTech:Class;
		
		private var _map:MapTest;
		
		//major game objects
		private var _tilemap:FlxTilemap;
		private var _bullets:FlxArray;
		private var _player:Player;
		private var _gravityObjs:FlxArray;
		
		function PlayStateTiles():void
		{
			super();
			
			//create tilemap
			//_tilemap = new FlxTilemap(new TxtMap,ImgTiles,3);
			//_tilemap = new FlxTilemap(new TxtMap2,ImgTiles,3); //This is an alternate tiny map
			_map = new MapTest;
			
			_map = new MapTest;
            this.add(_map.layerBackground);
            this.add(_map.layerMain);
            this.add(_map.layerForeground);
			
			//create player and bullets
			_bullets = new FlxArray();
			//_player = new Player(_tilemap.width/2-4,_tilemap.height/2-4,_bullets);
			_player = new Player(100,_tilemap.height/2-4,_bullets);
			
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
			
			_gravityObjs = new FlxArray();
			
			for(var i:uint = 0; i < 10; i++){
				_gravityObjs.add(this.add(new GravityObj(Math.random()*500,Math.random()*150,10,10,ImgTech)));
			}
			//_gravityObjs.add(this.add(new GravityObj(20,40,10,10,ImgTech)));
			//_gravityObjs.add(this.add(new GravityObj(80,80,10,10,ImgTech)));
			//_gravityObjs.add(this.add(new GravityObj(100,20,10,10,ImgTech)));
			
			//Uncomment these lines if you want to center TxtMap2
			//var fx:uint = _tilemap.width/2 - FlxG.width/2;
			//var fy:uint = _tilemap.height/2 - FlxG.height/2;
			//FlxG.followBounds(fx,fy,fx,fy);
			
			//add tilemap last so it is in front, looks neat
			//this.add(_tilemap);
			this.add(_map.layerBackground);
			this.add(_map.layerMain);
			this.add(_map.layerForeground);
			
			
			//turn on music and fade in
			FlxG.setMusic(SndMode);
			FlxG.flash(0xff131c1b);
		}

		override public function update():void
		{
			super.update();
			//FlxG.collideArray2(_tilemap,_bullets);
			FlxG.collideArray2(_tilemap,_bullets);
			_tilemap.collide(_player);
			
			//FlxG.collideArrays(_gravityObjs,_bullets);
			FlxG.collideArray(_gravityObjs,_player);
			
			updateGravity();
			
			FlxG.overlapArrays(_bullets,_gravityObjs,bulletHitObj);
			
		}
		
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
