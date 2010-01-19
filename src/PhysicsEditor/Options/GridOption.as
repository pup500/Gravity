package PhysicsEditor.Options
{
	import flash.display.Shape;
	
	public class GridOption extends OptionBase
	{
		[Embed(source="../../data/editor/interface/grid.jpg")] private var img:Class;
				
		private var grid:Shape;
		
		private const WIDTH:uint = 1280;
		private const HEIGHT:uint = 960;
		
		public function GridOption()
		{
			super(img);
			initGrid();
		}
		
		private function initGrid():void{
			grid = new Shape();
			grid.x = 0;
			grid.y = 0;
			
			for(var x:Number = 0; x <= WIDTH; x += 4){
				grid.graphics.lineStyle(1,0x0,x%16==0 ? .5 : .2);
				grid.graphics.moveTo(x,0);
				grid.graphics.lineTo(x,HEIGHT);
			}
			
			for(var y:Number = 0; y <= HEIGHT; y += 4){
				grid.graphics.lineStyle(1,0x0,y%16==0 ? .5 : .2);
				grid.graphics.moveTo(0,y);
				grid.graphics.lineTo(WIDTH,y);
			}
			
			state.addChildAt(grid, 0);
		}
		
		override public function update():void{
			super.update();
			grid.visible = active;
		}
		
	}
}