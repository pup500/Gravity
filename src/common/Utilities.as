package common
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import PhysicsGame.EventObject;
	
	import flash.geom.Point;
	
	import org.overrides.ExSprite;
	
	public class Utilities
	{
		public static const e_unknownJoint:int = 0;
		public static const e_revoluteJoint:int = 1;
		public static const e_prismaticJoint:int = 2;
		public static const e_distanceJoint:int = 3;
		public static const e_pulleyJoint:int = 4;
		public static const e_mouseJoint:int = 5;
		public static const e_gearJoint:int = 6;
		public static const e_lineJoint:int = 7;
		
		public function Utilities()
		{
		}
		
		public static function GetBodyAtMouse(the_world:b2World, point:Point, includeStatic:Boolean=false):b2Body {
			var mousePVec:b2Vec2 = new b2Vec2();
			mousePVec.Set(point.x, point.y);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(point.x - 0.001, point.y - 0.001);
			aabb.upperBound.Set(point.x + 0.001, point.y + 0.001);
			var k_maxCount:int=10;
			var shapes:Array = new Array();
			var count:int=the_world.Query(aabb,shapes,k_maxCount);
			var body:b2Body=null;
			for (var i:int = 0; i < count; ++i) {
				if (shapes[i].GetBody().IsStatic()==false||includeStatic) {
					var tShape:b2Shape=shapes[i] as b2Shape;
					var inside:Boolean=tShape.TestPoint(tShape.GetBody().GetXForm(),mousePVec);
					if (inside) {
						body=tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
		
		public static function CreateXMLRepresentation(the_world:b2World):XML {
			var config:XML = new XML(<config/>);
			var objects:XML = new XML(<objects/>);
			
			var isStatic:Boolean;
			var position:b2Vec2 = new b2Vec2();
			var file:String = new String();
			var angle:Number = 0;
			var item:XML;
			var bSprite:ExSprite;
			var bEvent:EventObject;
			for (var bb:b2Body = the_world.GetBodyList(); bb; bb = bb.GetNext()) {
				
				bSprite = bb.GetUserData();
				
				if(!bSprite) continue;
				
				if(bSprite.name == "Player") continue;
				
				bb.PutToSleep();
				
				if(bSprite is EventObject){
					bEvent = bSprite as EventObject;
					
					position.x = bb.GetPosition().x;
					position.y = bb.GetPosition().y;
					
					item = new XML(<event/>);
					item.type = bEvent._type;
					item.x = position.x;
					item.y = position.y;
					
					if(bEvent.getTarget()){
						var t:ExSprite = bEvent.getTarget();
						item.target.x = t.final_body.GetWorldCenter().x;
						item.target.y = t.final_body.GetWorldCenter().y;
					}
				}
				else{
					isStatic = bb.IsStatic();
					position.x = bb.GetPosition().x;
					position.y = bb.GetPosition().y;
					
					//Need to figure out how to get file...
					file = bSprite.imageResource;
					angle = bb.GetAngle();
					
					item = new XML(<shape/>);
					item.file = file;
					item.layer = bSprite.layer;
					item.isStatic = isStatic;
					item.polyshape = bSprite.shape is b2PolygonDef;
					item.angle = angle;
					item.x = position.x;
					item.y = position.y;
				}
				
				objects.appendChild(item);
			}
			
			var joint:XML;
			for (var j:b2Joint=the_world.GetJointList(); j; j=j.GetNext()) {
				var type:uint;
				
				type = j.GetType();
				switch(type){
				case e_distanceJoint:
					joint = createDistanceJointXML(j as b2DistanceJoint);
					break;
				case e_prismaticJoint:
					joint = createPrismaticJointXML(j as b2PrismaticJoint);
					break;
				case e_revoluteJoint:
					joint = createRevoluteJointXML(j as b2RevoluteJoint);
					break;
				}
				
				objects.appendChild(joint);
			}
			
			config.appendChild(objects);
			
			return config;
		}
		
		private static function createDistanceJointXML(j:b2DistanceJoint):XML{
			var point1:b2Vec2 = new b2Vec2();
			var point2:b2Vec2 = new b2Vec2();
			
			point1.x = j.GetAnchor1().x;
			point1.y = j.GetAnchor1().y;
			point2.x = j.GetAnchor2().x;
			point2.y = j.GetAnchor2().y;
			
			var joint:XML = new XML(<joint/>);
			joint.type = e_distanceJoint;
			joint.body1.x = point1.x;
			joint.body1.y = point1.y;
			joint.body2.x = point2.x;
			joint.body2.y = point2.y;
			
			return joint;
		}
		
		private static function createPrismaticJointXML(j:b2PrismaticJoint):XML{
			var point1:b2Vec2 = new b2Vec2();
			var point2:b2Vec2 = new b2Vec2();
			var anchor:b2Vec2 = new b2Vec2();
			var axis:b2Vec2 = new b2Vec2();
			
			var b1:b2Body = j.GetBody1();
			var b2:b2Body = j.GetBody2();
			
			point1.x = b1.GetPosition().x;
			point1.y = b1.GetPosition().y;
			point2.x = b2.GetPosition().x;
			point2.y = b2.GetPosition().y;
			
			anchor.x = j.GetAnchor1().x;
			anchor.y = j.GetAnchor1().y;
			
			//TODO:JointXML should really find a way to get at the axis...
			axis.x = j.GetUserData().x;
			axis.y = j.GetUserData().y;
			
			var joint:XML = new XML(<joint/>);
			joint.type = e_prismaticJoint;
			joint.body1.x = point1.x;
			joint.body1.y = point1.y;
			joint.body2.x = point2.x;
			joint.body2.y = point2.y;
			joint.anchor.x = anchor.x;
			joint.anchor.y = anchor.y;
			joint.axis.x = axis.x;
			joint.axis.y = axis.y;
			
			return joint;
		}
		
		private static function createRevoluteJointXML(j:b2RevoluteJoint):XML{
			var point1:b2Vec2 = new b2Vec2();
			var point2:b2Vec2 = new b2Vec2();
			var anchor:b2Vec2 = new b2Vec2();
			
			var b1:b2Body = j.GetBody1();
			var b2:b2Body = j.GetBody2();
			
			point1.x = b1.GetPosition().x;
			point1.y = b1.GetPosition().y;
			point2.x = b2.GetPosition().x;
			point2.y = b2.GetPosition().y;
			
			anchor.x = j.GetAnchor1().x;
			anchor.y = j.GetAnchor1().y;
			
			var joint:XML = new XML(<joint/>);
			joint.type = e_revoluteJoint;
			joint.body1.x = point1.x;
			joint.body1.y = point1.y;
			joint.body2.x = point2.x;
			joint.body2.y = point2.y;
			joint.anchor.x = anchor.x;
			joint.anchor.y = anchor.y;
			
			return joint;
		}
		
		/*
		public static function addJoint(the_world:b2World, body1:b2Body, body2:b2Body):void{
			var joint:b2DistanceJointDef = new b2DistanceJointDef();
			var body1:b2Body = _bodies[0] as b2Body;
			var body2:b2Body = _bodies[1] as b2Body;
			
			if(body1 && body2){
				joint.Initialize(body1, body2, body1.GetWorldCenter(), body2.GetWorldCenter());
				joint.collideConnected = true;
				_state.the_world.CreateJoint(joint);
				
				_bodies = new Array();
			}
		}*/


	}
}