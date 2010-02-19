package PhysicsGame.Events
{
	import PhysicsGame.Enemy;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	public class SpawnEvent extends EventBase
	{
		[Embed(source="../../data/editor/interface/pig-icon.png")] private  var eventImg:Class;
		
		public function SpawnEvent()
		{
			super();
		}
		
		override public function startEvent():void{
			
			/*
			var xml:XML = new XML(<shape/>);
			xml.file = "data/end_point.png";
			xml.@x = Math.random()*640;
			xml.@y = Math.random()*480;
			xml.@layer = 1;
			xml.@bodyType = 2;
			xml.@shapeType = 0;
			xml.@angle = 0;
			xml.@friction = .3;
			xml.@density = 1;
			xml.@restitution = .5;
			
			var state:ExState = FlxG.state as ExState;
			
			var b2:ExSprite = new ExSprite();
		    b2.initFromXML(xml, state.the_world, state.getController());
		    */
		    
		    var state:ExState = FlxG.state as ExState;
		    var body:Enemy = new Enemy(_args["x"], _args["y"]);
			body.createPhysBody(state.the_world, state.getController());
			body.GetBody().SetFixedRotation(true);
		    
		    state.addToLayer(body, 1);
		}
		
		override public function update():void{
			//trace("random:" + Math.random());
		}
	}
}