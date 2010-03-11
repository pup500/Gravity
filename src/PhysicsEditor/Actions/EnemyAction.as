package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import PhysicsGame.Enemy;
	import PhysicsGame.EventObject;
	
	import org.overrides.ExState;
	
	public class EnemyAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/gas-soldier-icon.png")] private var img:Class;
		
		public function EnemyAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		override public function onHandleBegin():void{
			//TODO:Fix this up....
			/*
			var xml:XML = new XML(<event/>);
			xml.@x = args["start_snap"].x;
			xml.@y = args["start_snap"].y;
			xml.@type = state.getArgs()["event"];
			*/
			
			var b2:Enemy = new Enemy(args["start_snap"].x, args["start_snap"].y);
			b2.GetBody().SetFixedRotation(true);
			
			//b2.initFromXML(xml);
			state.addToLayer(b2, ExState.EV);
		}
	}
}