package PhysicsEditor.Types
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.b2internal;
	
	import PhysicsEditor.IPanel;
	use namespace b2internal;
	
	public class PolyShapeType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/shape_poly.png")] private var img:Class;
		
		public function PolyShapeType(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			
			if(active){
				state.getArgs()["shapeType"] = b2Shape.e_polygonShape;
			}
		}
	}
}