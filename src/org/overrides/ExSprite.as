package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	
	import PhysicsGame.Components.Components;
	import PhysicsGame.Components.IComponent;
	import PhysicsGame.Components.PhysicsComponent;
	import PhysicsGame.Wrappers.WorldWrapper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.flixel.*;
	use namespace b2internal;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class ExSprite extends FlxSprite
	{
		public var name:String;
		public var imageResource:String;
		public var layer:uint;
		
		protected var components:Components;
		
		protected var physicsComponent:PhysicsComponent;
		
		protected var loaded:Boolean;
		
		public var damage:int;
		
		public function ExSprite(x:int=0, y:int=0, sprite:Class=null){
			//TODO:Note that x and y needs to be offsetted by half width and height to match physics...
			super(x, y, sprite);
			
			components = new Components();
			
			var state:ExState = FlxG.state as ExState;
			physicsComponent = new PhysicsComponent(this);
			
			damage = 0;
			
			loaded = false;
		}
		
		//We can remove all joints explicitly
		public function destroyAllJoints():void{
			WorldWrapper.destroyAllJoints(GetBody());
		}
		
		public function setJointMotorSpeed(speed:Number):void{
			physicsComponent.setJointMotorSpeed(speed);
		}
		
		/*
		public function updateJoints():void{
			var joint:b2Joint;
			var joints:b2JointEdge = final_body.GetJointList();
			while(joints){
				switch(joints.joint.GetType()){
					//TODO:SEE IF THIS MAKES SENSE, can we put this anywhere else....
					case Utilities.e_prismaticJoint:
						var jointRev:b2PrismaticJoint = joints.joint as b2PrismaticJoint;
						////trace("limit:" + jointRev.GetLowerLimit() + ", " + jointRev.GetUpperLimit() + " : " + jointRev.GetJointTranslation());
						if(Math.abs(jointRev.GetJointTranslation() - jointRev.GetLowerLimit()) < .1){
							jointRev.SetMotorSpeed(Math.abs(jointRev.GetMotorSpeed()));
							////trace("speed:" + jointRev.GetMotorSpeed());
						}
						else if(Math.abs(jointRev.GetJointTranslation() - jointRev.GetUpperLimit()) < .1){
							////trace("speed:" + jointRev.GetMotorSpeed());
							jointRev.SetMotorSpeed(-Math.abs(jointRev.GetMotorSpeed()));
						}
						break;
				};
				
				joints = joints.next;
			}
		}
		*/
		
		public function registerComponent(component:IComponent):void{
			components.registerComponent(component);
		}
		
		override public function update():void
		{
			super.update();
			
			//TODO:Put physics component into the components array
			physicsComponent.update();
			
			//Update all registered components
			components.update();
			
			//updateJoints();
		}
		
		override public function kill():void
		{
			physicsComponent.destroyPhysBody();
			super.kill();
		}
		
		override public function render():void
		{
			if(!visible)
				return;
			getScreenXY(_p);
			
			//Simple render
			if((angle == 0) && (scale.x == 1) && (scale.y == 1) && (blend == null))
			{
				FlxG.buffer.copyPixels(_framePixels,_r,_p,null,null,true);
				return;
			}
			
			//Advanced render
			_mtx.identity();
			_mtx.translate(-origin.x,-origin.y);
			_mtx.scale(scale.x,scale.y);
			if(angle != 0) _mtx.rotate(angle);
			_mtx.translate(_p.x+origin.x,_p.y+origin.y);
			FlxG.buffer.draw(_framePixels,_mtx,null,blend,null,antialiasing);
		}
		
		override public function hurt(Damage:Number):void{
		
		}
		
		public function GetBody():b2Body{
			return physicsComponent.final_body;
		}

		public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void {
			hurt(oFixture.GetBody().GetUserData().damage);
		}
		
		public function removeImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			
		}
		
		
		public var cacheRTF:b2Fixture;
		public var cacheRTLambda:Number;
		public var cacheP1:b2Vec2;
		public var cacheP2:b2Vec2;
		
		//TODO:Refactor this
		//This function caches a ray trace so we can see what's ahead of us
		//And use the results in the other functions for detection
		public function rayTrace():void{
			var dir:int = facing == RIGHT ? 1 : -1;
			
			//TODO:Make it not so arbitrary
			cacheP1 = GetBody().GetWorldPoint(new b2Vec2((width/2 -2)/ExState.PHYS_SCALE * dir,(height/4) / ExState.PHYS_SCALE));
			cacheP2 = GetBody().GetWorldPoint(new b2Vec2((width)/ExState.PHYS_SCALE * dir, (height/2+2)/ ExState.PHYS_SCALE));
				
			var state:ExState = FlxG.state as ExState;
			
			cacheRTF = null;
			cacheRTLambda = 1;
			
			function castFunction(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number
			{
				if(fraction < cacheRTLambda && !fixture.IsSensor()){
					cacheRTF = fixture;
					cacheRTLambda = fraction;
					return fraction;
				}
				
				return 1;
			}
			
			WorldWrapper.rayCast(castFunction, cacheP1, cacheP2);
		}
		
		public function drawGroundRayTrace():void{
			rayTrace();
			
			var myShape:Shape = new Shape();
			
			getScreenXY(_p);
			
			myShape.graphics.lineStyle(2,0x0,1);
			
			var p1:b2Vec2 = cacheP1.Copy();
			var p2:b2Vec2 = cacheP2.Copy();
			
			p1.Multiply(ExState.PHYS_SCALE);
			p2.Multiply(ExState.PHYS_SCALE);
			
			myShape.graphics.moveTo(p1.x + FlxG.scroll.x, p1.y  + FlxG.scroll.y);
			myShape.graphics.lineTo((p2.x * cacheRTLambda + (1 - cacheRTLambda) * p1.x)  + FlxG.scroll.x, 
									(p2.y * cacheRTLambda + (1 - cacheRTLambda) * p1.y)  + FlxG.scroll.y);
			
			FlxG.buffer.draw(myShape);
		}
		
		//As long as there's something ahead of me
		public function isAnythingForward():Boolean{
			return cacheRTF ? true : false;
		}
		
		//There is ground ahead of me if there is something ahead at my feet
		public function isGroundForward():Boolean{
			trace("cache lambda" + cacheRTLambda);
			return cacheRTF && cacheRTLambda > .7;
		}
		
		//I am blocked forward if there is something in my way that's in front of me
		public function isBlockedForward():Boolean{
			return cacheRTF && cacheRTLambda < .7;
		}
		
		//NOTE: Always change getXML first, then save all the levels into new files and then
		//Change the init function to match getXML
		public function getXML():XML
		{			
			var xml:XML = new XML(<shape/>);
			xml.file =  imageResource;
			xml.@layer = layer;
			xml.@bodyType = GetBody().GetType();
			xml.@shapeType = GetBody().GetFixtureList().GetType();
			xml.@angle = angle;
			xml.@friction = GetBody().GetFixtureList().GetFriction();
			xml.@density = GetBody().GetFixtureList().GetDensity();
			xml.@restitution = GetBody().GetFixtureList().GetRestitution();
			xml.@damage = damage;
			xml.@name = name;
			
			//XML representation is in screen coordinates, so scale up physics
			xml.@x = GetBody().GetPosition().x * ExState.PHYS_SCALE;
			xml.@y = GetBody().GetPosition().y * ExState.PHYS_SCALE;
					
			return xml;
		}
		
		//Initialize the ExSprite from the xml data structure
		public function initFromXML(xml:XML):void{
			//If there's no image file information, just load the file normally
			if(xml.file.length() == 0){
				onInitXMLComplete(xml);
				return;
			}
			
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
    			function(e:Event):void{
    				onInitXMLComplete(xml, e)
    			});
    		
    		loader.load(new URLRequest(xml.file));
		}
		
		protected function onInitXMLComplete(xml:XML, event:Event=null):void{
			//Load the bitmap data
			if(event){
				var loadinfo:LoaderInfo = LoaderInfo(event.target);
				var bitmapData:BitmapData = Bitmap(loadinfo.content).bitmapData;
		 		pixels = bitmapData;
			}
			
			//Assume we have pixel data already....
			imageResource = xml.file;
			layer = xml.@layer;
			
			var body:b2Body = physicsComponent.createBodyFromXML(xml);
			physicsComponent.createFixtureFromXML(xml);
			
			damage = xml.@damage.length() > 0 ? xml.@damage : 0;
			name = xml.@name;
			
			reset(xml.@x, xml.@y);
			
			update();
		}
		
		public function SetBodyType(type:uint):void{
			GetBody().SetType(type);
		}
		
		public function SetShapeType(type:uint, density:Number=1.0):void{
			//initShape(type);
			//GetBody().DestroyFixture(fixture);
			//GetBody().CreateFixture2(shape, density);
			//fixture = final_body.GetFixtureList();
		}
	}
}