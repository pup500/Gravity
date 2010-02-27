package PhysicsGame
{
	public class FilterData
	{
		//Filter data are categories used in fixtures to determine which category this shape
		//belongs to.  We have to specifically set the mask to ignore different types
		//which we don't want to generate events
		
		public static const NORMAL:uint = 0x0001;
		public static const PLAYER:uint = 0x0002;
		public static const ENEMY:uint =  0x0004;
		public static const SPECIAL:uint = 0x0008;
		
		public function FilterData()
		{
		}
	}
}