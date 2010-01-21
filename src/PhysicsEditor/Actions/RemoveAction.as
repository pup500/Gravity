package PhysicsEditor.Actions
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import common.Utilities;
	
	import org.overrides.ExSprite;
	
	public class RemoveAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/delete.png")] private var img:Class;
		
		public function RemoveAction(preClick:Function)
		{
			super(img, preClick);
		}
		
		override public function onHandleBegin():void{
			var b2:b2Body = Utilities.GetBodyAtPoint(state.the_world, args["start"], true);
			if(b2 && b2.GetUserData()){
				var bSprite:ExSprite = b2.GetUserData() as ExSprite;
				if(bSprite){
					bSprite.kill();
				}
			}
		}

	}
}