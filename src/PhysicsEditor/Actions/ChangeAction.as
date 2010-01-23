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
				
				var xml:XML = bSprite.getXML();
				
				xml.layer = 1;
				xml.bodyType = state.getArgs()["bodyType"];
				xml.shapeType = state.getArgs()["shapeType"];
				xml.angle = 0;
				
				//Need to handle different layers
				//TODO:Can we find a way to delete just the shape?
				bSprite.destroyPhysBody();
			
				bSprite.initFromXML(xml, state.the_world, state.getController());
			}
		}

	}
}