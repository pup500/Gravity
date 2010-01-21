package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	
	import common.Utilities;
	
	import org.overrides.ExSprite;
	
	public class BreakAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/disconnect-icon.png")] private var img:Class;
		
		public function BreakAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		override public function handleBegin():void{
			if(!active) return;
			
			//TODOLBOOOO I hate doing this... will make all of these callbacks 
			super.handleBegin();
			
			var b2:b2Body = Utilities.GetBodyAtPoint(state.the_world, args["start"], true);
			if(b2 && b2.GetUserData()){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.destroyAllJoints();
				}
			}
		}

	}
}