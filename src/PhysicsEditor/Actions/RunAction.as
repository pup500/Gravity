package PhysicsEditor.Actions
{
	import Box2D.Dynamics.b2Body;
	
	import PhysicsEditor.IPanel;
	
	import PhysicsGame.Wrappers.WorldWrapper;
	
	import flash.events.MouseEvent;
	
	public class RunAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/run.png")] private var img:Class;
		
		public function RunAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
			this.active = false;
		}
		
		//Override onClick to not deactivate other actions in the panel...
		override protected function onClick(event:MouseEvent):void{
			active = !active;
		}
		
		override public function update():void{
			super.update();
			updateWorldObjects();
		}
		
		private function updateWorldObjects():void{
			WorldWrapper.setAllAwake(active);
		}
	}
}