package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	
	import PhysicsEditor.IPanel;
	
	import common.Utilities;
	
	import org.overrides.ExSprite;
	
	public class ChangeAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/change.png")] private var img:Class;
		
		public function ChangeAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		override public function onHandleEnd():void{
			var b2:b2Body = Utilities.GetBodyAtPoint(state.the_world, args["start"], true);
			if(b2 && b2.GetUserData()){
				var bSprite:ExSprite = b2.GetUserData();
				bSprite.SetBodyType(state.getArgs()["bodyType"]);
				bSprite.SetShapeType(state.getArgs()["shapeType"]);
				
				b2.SetAngle(state.getArgs()["angle"] * Math.PI/180);
				
				//var xml:XML = bSprite.getXML();
				//xml.layer = 1;
				//xml.bodyType = state.getArgs()["bodyType"];
				//xml.shapeType = state.getArgs()["shapeType"];
				//xml.angle = 0;
				
				//TODO:Need to handle different layers
				//TODO:Can we find a way to delete just the shape?
				//bSprite.destroyPhysBody();
				//bSprite.initFromXML(xml, state.the_world, state.getController());
				
				//This way is safe on joints
				//Change the body type
				//b2.SetType(state.getArgs()["bodyType"]);
				
				//Create a new shape fixture
				//var fixture:b2Fixture = b2.GetFixtureList();
				//b2.DestroyFixture(fixture);
				//bSprite.initShape(state.getArgs()["shapeType"]);
				//b2.CreateFixture2(bSprite.GetShape(), 1.0);
			}
		}

	}
}