package PhysicsEditor.Actions
{
	import org.overrides.ExSprite;
	
	
	public class AddAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add.png")] private var img:Class;
		
		public function AddAction(preClick:Function)
		{
			super(img, preClick);
		}
		
		override public function onHandleBegin():void{
			//Should this be made as some ExSprite factory function in ExSprite?
			var xml:XML = new XML(<shape/>);
			xml.file = "data/end_point.png";
			xml.x = args["start"].x;
			xml.y = args["start"].y;
			xml.layer = 1;
			xml.bodyType = state.getArgs()["bodyType"];
			xml.shapeType = 1;
			xml.angle = 0;
			
			var b2:ExSprite = new ExSprite();
		    b2.initFromXML(xml, state.the_world, state.getController());
		    
		    state.addToLayer(b2, xml.layer);
		}

	}
}