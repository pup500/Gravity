package PhysicsGame.Events
{
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class SpawnEvent extends EventBase
	{
		[Embed(source="../../data/editor/interface/pig-icon.png")] private  var eventImg:Class;
		
		public function SpawnEvent()
		{
			super();
		}
		
		override public function startEvent():void{
			var xml:XML = new XML(<shape/>);
			xml.file = "data/end_point.png";
			xml.@x = Math.random()*640;
			xml.@y = Math.random()*480;
			xml.@layer = 1;
			xml.@bodyType = 2;
			xml.@shapeType = 1;
			xml.@angle = 0;
			
			var state:ExState = FlxG.state as ExState;
			
			var b2:ExSprite = new ExSprite();
		    b2.initFromXML(xml, state.the_world, state.getController());
		    
		    state.addToLayer(b2, xml.@layer);
		}
		
		override public function update():void{
			//trace("random:" + Math.random());
		}
	}
}