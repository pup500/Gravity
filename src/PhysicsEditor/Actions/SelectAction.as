package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	
	import PhysicsEditor.IPanel;
	
	import common.Utilities;
	
	import org.overrides.ExSprite;
	
	public class SelectAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/change.png")] private var img:Class;
		
		public function SelectAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		override public function onHandleBegin():void{
			var b2:b2Body = Utilities.GetBodyAtPoint(state.the_world, args["start"], true);
			if(b2 && b2.GetUserData()){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					//bSprite.kill();
					//Just fill in args with things we pull from object
				}
			}
			
		}

	}
}