package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	
	import PhysicsEditor.IPanel;
	
	import common.Utilities;
	
	import org.overrides.ExSprite;
	
	public class RemoveAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/delete.png")] private var img:Class;
		
		public function RemoveAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		override public function onHandleBegin():void{
			var b2:b2Body = Utilities.GetBodyAtPoint(state.worldWrapper.the_world, args["start"], true);
			if(b2 && b2.GetUserData()){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.kill();
				}
			}
			//TODO:Do we worry about deleting joints that are only connected to the world?
		}

	}
}