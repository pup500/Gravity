package ailab.blackboard
{
	import flash.utils.Dictionary;
	
	public class BlackBoard
	{
		private var _args:Dictionary;
		
		public function BlackBoard()
		{
			_args = new Dictionary();
		}
		
		public function getObject(key:String, obj:Object=null):Object{
			if(_args[key])
				return _args[key];
			else
				return obj;
		}
		
		public function setObject(key:String, obj:Object=null):void{
			_args[key] = obj;
		}
	}
}