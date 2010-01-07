package PhysicsLab 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Norman
	 */
	public class MouseDragSelectEventArgs
	{
		public var Start:Point;
		public var End:Point;
		public function MouseDragSelectEventArgs(start:Point, end:Point) 
		{
			Start = start;
			End = end;
		}	
	}

}