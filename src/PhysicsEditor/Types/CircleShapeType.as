package PhysicsEditor.Types
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.b2internal;
	use namespace b2internal;
	
	public class CircleShapeType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/stop-icon.png")] private var img:Class;
		
		public function CircleShapeType(preClick:Function)
		{
			super(img, preClick);
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			
			if(active){
				state.getArgs()["shapeType"] = b2Shape.e_circleShape;
			}
		}
	}
}