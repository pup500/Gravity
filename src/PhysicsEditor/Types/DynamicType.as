package PhysicsEditor.Types
{
	import Box2D.Dynamics.b2Body;
	
	public class DynamicType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/sheep-icon.png")] private var img:Class;
		
		public function DynamicType(preClick:Function)
		{
			super(img, preClick);
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			
			if(active){
				state.getArgs()["bodyType"] = b2Body.b2_dynamicBody;
			}
		}
	}
}