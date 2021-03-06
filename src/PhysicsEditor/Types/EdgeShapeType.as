package PhysicsEditor.Types
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.b2internal;
	
	import PhysicsEditor.IPanel;
	
	import flash.events.MouseEvent;
	use namespace b2internal;
	
	public class EdgeShapeType extends TypeBase
	{
		[Embed(source="../../data/editor/interface/shape_edge.png")] private var img:Class;
		
		public function EdgeShapeType(panel:IPanel, active:Boolean)
		{
			super(img, panel, active);
		}
		
		//Don't activate this object
		override protected function onClick(event:MouseEvent):void{
			return;
		}
		
		//See if we should move this into onClick
		override public function update():void{
			super.update();
			
			if(active){
				state.getArgs()["shapeType"] = b2Shape.e_edgeShape;
			}
		}
	}
}