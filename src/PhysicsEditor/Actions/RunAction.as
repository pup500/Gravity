package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import Box2D.Common.Math.b2Vec2;
	
	import flash.events.MouseEvent;
	
	public class RunAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/run.png")] private var img:Class;
		
		public function RunAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		//Don't run preclick to allow the other modes to continue working...
		override protected function onClick(event:MouseEvent):void{
			//onPreClick();
			active = !active;
		}
		
		override public function update():void{
			updateWorldObjects();
		}
		
		private function updateWorldObjects():void{
			var bb:b2Body;
			if(active){
				//state.the_world.SetGravity(new b2Vec2(0,10.0));
				
				for (bb = state.the_world.GetBodyList(); bb; bb = bb.GetNext()) {
					if(bb.GetType() == b2Body.b2_dynamicBody)
						bb.SetAwake(true);
				}
			}
			else{
				state.the_world.SetGravity(new b2Vec2(0,0));
				for (bb = state.the_world.GetBodyList(); bb; bb = bb.GetNext()) {
					if(bb.GetType() == b2Body.b2_dynamicBody)
						bb.SetAwake(false);
				}
			}
		}
	}
}