package PhysicsGame.Components
{
	import flash.utils.Dictionary;
	
	public class Components
	{
		public var _components:Array;
		
		public function Components()
		{
			_components = new Array();
		}

		public function registerComponent(component:IComponent):void{
			_components.push(component);
		}
		
		public function update():void{
			for each(var component:IComponent in _components){
				component.update();
			}
		}
		
		public function sendMessage(args:Object):void{
			for each(var component:IComponent in _components){
				//Just always return false so others can work....
				if(component.receive(args)){
					return;
				}
			}
		}

	}
}