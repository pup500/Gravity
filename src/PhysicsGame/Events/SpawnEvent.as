package PhysicsGame.Events
{
	import org.flixel.FlxG;
	import org.overrides.ExState;
	import org.overrides.ExSprite;
	
	public class SpawnEvent extends EventBase
	{
		[Embed(source="../../data/editor/interface/pig-icon.png")] private  var eventImg:Class;
		
		public function SpawnEvent()
		{
			super();
		}
		
		override public function activate():void{
			
		}
		
		override public function update():void{
			trace("random:" + Math.random());
			/*
			var _state:ExState = FlxG.state as ExState;
			
			var b2:ExSprite = new ExSprite(100, 100, eventImg);
		    b2.name = "spawned";
		    
		    b2.initShapeFromSprite();
		    
		    b2.createPhysBody(_state.the_world);
		    
		    _state.addToLayer(b2, ExState.MG);
		    */
		}
	}
}