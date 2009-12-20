package com.adamatomic.Mode
{
	import com.adamatomic.flixel.*;
	
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	
	public class GravSpawnFlanTilesState extends FlxState
	{
		[Embed(source="../../../data/mode.mp3")] private var SndMode:Class;
		[Embed(source="../../../data/cursor.png")] private var ImgCursor:Class;
		
		//PUT THE FOLLOWING INSIDE YOUR DERIVED FlxState CLASS (i.e. under 'class MyState { ...')
		private var _map:MapBase;

		//major game objects
		private var _blocks:FlxArray;
		private var _gravityGenerators:FlxArray;
		private var _affectedByGravity:FlxArray;
		private var _bullets:FlxArray;
		private var _player:Player;
		
		private var gravityPool:ObjectPool;
		
		//This requires every map object derived classes to be referenced in this class
		//like this:
		
		private var maponegap:MapOneGap;
		private var mapsmalloneplatform:MapSmallOnePlatform;
		private var mapvalley:MapValley;
		private var maptestlevel:MapTestLevel;
		
		private function getMapByLevel():MapBase{
			trace(FlxG.level);
			trace(FlxG.levels[FlxG.level]);
			var ClassReference:Class = getDefinitionByName(FlxG.levels[FlxG.level]) as Class;
			return new ClassReference() as MapBase;
			//new MapSmallOnePlatform();
		}
		
		function GravSpawnFlanTilesState():void
		{
			super();
			
			//Load the Flan Map.
			_map = getMapByLevel();

			//Add the layers to current the FlxState
			FlxG.state.add(_map.layerBackground);
			_map.addSpritesToLayerBackground(onAddSpriteCallback);
			FlxG.state.add(_map.layerMain);
			_map.addSpritesToLayerMain(onAddSpriteCallback);
			FlxG.state.add(_map.layerForeground);
			_map.addSpritesToLayerForeground(onAddSpriteCallback);

			FlxG.followBounds(_map.boundsMinX, _map.boundsMinY, _map.boundsMaxX, _map.boundsMaxY);

			//create basic objects
			_bullets = new FlxArray();
			_player = new Player(100,_map.layerMain.height/2-4,_bullets);
			_gravityGenerators = new FlxArray();
			_affectedByGravity = new FlxArray();
			_affectedByGravity.add(_player);
			
			gravityPool = new ObjectPool(GravityObj);
			
			//--Add instantiated elements to rendering loop.--//
			
			//add background before anything else so it doesn't overlap anything.
			this.add(_map.layerBackground);
			
			_player.addAnimationCallback(AnimationCallbackTest);
			for(var i:uint = 0; i < 8; i++)
				_bullets.add(this.add(new BotBullet()));
				
			//add player and set up camera
			this.add(_player);
			FlxG.follow(_player,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,640,640);

			this.add(_map.layerMain);
			this.add(_map.layerForeground);
			
			//turn on music and fade in
			//FlxG.setMusic(SndMode);
			FlxG.flash(0xff131c1b);
			
			FlxG.setCursor(ImgCursor);
		}

		override public function update():void
		{
			super.update();
			
			updateGravity();
			//FlxG.collideArray2(_tilemap,_bullets);
			FlxG.overlapArrays(_bullets, _gravityGenerators, bulletHitGravityObj);
			
			FlxG.collideArray2(_map.layerMain,_bullets);
			
			_map.layerMain.collide(_player);
			
			
			
			
			//FlxG.overlapArray(_bullets, _map.layerMain, bulletHitBlocks);
			
			//FlxG.collideArrays(_gravityObjs,_bullets);
			//FlxG.collideArray(_gravityObjs,_player);
			
			
			//FlxG.overlapArrays(_bullets,_gravityObjs,bulletHitObj);
			
		}
		
		//Added for Flan Map loading. Not sure what it does.
		protected function onAddSpriteCallback(obj:FlxSprite):void
		{
			/*
			*/
		}
		
		public function createGravityAtLocation(object:FlxSprite):void{
			var ggen:GravityObj = getGravityObj();
			ggen.x = object.x;
			ggen.y = object.y;
			add(ggen);
		}
		
		private function bulletHitGravityObj(Bullet:FlxSprite,gravityObj:FlxCore):void
		{
			Bullet.hurt(1);
			var ggen:GravityObj = gravityObj as GravityObj;
			ggen.reset();
		}
		
		private function bulletHitBlocks(Bullet:FlxSprite,Block:FlxCore):void
		{
			Bullet.hurt(0);
			
			createGravityAtLocation(Bullet);
		}
		
		private function getGravityObj():GravityObj {
			var die:String = "die";
			var ggen:GravityObj = gravityPool.getObject();
			if (!ggen.hasEventListener(die)) {
				ggen.addEventListener(die, removeGravityObj);
			}
			ggen.reset();
			_gravityGenerators.add(ggen);
			return ggen;
		}
		
		private function removeGravityObj(e:Event):void {
			var ggen:GravityObj = GravityObj(e.target);
			_gravityGenerators.remove(ggen, true);
			remove(ggen, true);
			gravityPool.returnObject(ggen);	
		}
		
		//TODO: Encapsulate gravity logic so it is independant of PlayState
		private function updateGravity():void{
			for each(var massedObj:Massed in _affectedByGravity){	
				massedObj.accel.x = 0;
				massedObj.accel.y = 200;
				
				for each(var gravObj:GravityObj in _gravityGenerators) {
					if(gravObj.getMass() == 0) continue;
					
					var xDistance:Number = gravObj.x - massedObj.xpos;
					var yDistance:Number = gravObj.y - massedObj.ypos;
					var xDistanceSq:Number = xDistance * xDistance;
					var yDistanceSq:Number = yDistance * yDistance;
					var distanceSq:Number = xDistanceSq + yDistanceSq;
					
					//For performance reasons....  assume force is 0 when distance is pretty far
					if(distanceSq > 100000 ) continue;
					
					//This is a physics hack to stop adding gravity to objects when they are too close
					//they aren't pulling anymore because of normal force
					if(distanceSq < 100) continue;
					
					var distance:Number = Math.sqrt(distanceSq);
					var massProduct:Number = massedObj.getMass() * gravObj.getMass();	//_player.mass * gravObj.mass;
					
					var G:Number = 1; //gravitation constant
					
					var force:Number = G*(massProduct / distanceSq);
					
					force = Math.log(force) * 50;
					
					massedObj.accel.x += force * (xDistance/distance);//xDistance >= 0 ? xForce :-xForce;
					massedObj.accel.y += force * (yDistance/distance);//yDistance >= 0 ? yForce :-yForce;
					
					//FlxG.log("xDist:" + xDistance + " yDist:"+yDistance);
					//FlxG.log("xDistSq:" + xDistanceSq + " yDistSq:"+yDistanceSq);
					//FlxG.log("massProduct:" + massProduct);
					//FlxG.log("distance:" + distance);
					FlxG.log("force:" + force);
					FlxG.log("xForce:" + force * (xDistance/distance) + " yForce:" + force * (yDistance/distance));
				}
				
				//Add friction?
				//if(massedOb.accel.y massedObj.accel.x = 0;
			}
		}
		
		private function bulletHitObj(Bullet:FlxSprite,Obj:GravityObj):void
		{
			FlxG.log("BULLET HIT NAME: ");
			Bullet.hurt(0);
			//Obj.affectGravity(100);
		}
		
		private function AnimationCallbackTest(Name:String, Frame:uint, FrameIndex:uint):void
		{
			FlxG.log("ANIMATION NAME: "+Name+", FRAME: "+Frame+", FRAME INDEX: "+FrameIndex);
		}
	}
}
