package PhysicsEditor.Actions
{
	import PhysicsEditor.IPanel;
	
	import PhysicsGame.EventObject;
	
	import org.overrides.ExState;
	
	public class EventAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add_event.png")] private var img:Class;
		
		public function EventAction(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		override public function onHandleBegin():void{
			//TODO:Fix this up....
			var xml:XML = new XML(<event/>);
			xml.x = args["start"].x;
			xml.y = args["start"].y;
			xml.type = 1;//2;
			
			var b2:EventObject = new EventObject();
			b2.initFromXML(xml, state.the_world);
			state.addToLayer(b2, ExState.EV);
		}
	}
}