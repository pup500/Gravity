package PhysicsEditor.Actions
{
	import org.overrides.ExSprite;
	
	
	public class AddAction extends ActionBase
	{
		[Embed(source="../../data/editor/interface/add.png")] private var img:Class;
		
		public function AddAction(preClick:Function, postRelease:Function)
		{
			super(img, preClick, postRelease);
		}
		
		override public function handleBegin():void{
			if(!active) return;
			
			//Forget postRelease function, just do it here... we have state now
			//Change args here and it will be passed back to the postRelease function
			//args["mode"] = "add";
			
			super.handleBegin();
			
			//Should this be made as some ExSprite factory function in ExSprite?
			var xml:XML = new XML(<shape/>);
			xml.file = "data/end_point.png";
			xml.x = args["start"].x;
			xml.y = args["start"].y;
			xml.layer = 1;
			xml.bodyType = 2;
			xml.shapeType = 1;
			xml.angle = 0;
			
			var b2:ExSprite = new ExSprite();
		    b2.initFromXML(xml, state.the_world, state.getController());
		    
		    state.addToLayer(b2, xml.layer);
		}

	}
}