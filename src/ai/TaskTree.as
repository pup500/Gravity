package ai
{
	import ai.blackboard.BlackBoard;
	
	public class TaskTree
	{
		protected var root:Task;
		private var head:Task;
		
		private var composites:Array;
		
		private var bb:BlackBoard;
		
		public function TaskTree()
		{
			root = new ParallelTask();
			head = root;
			
			bb = new BlackBoard();
			
			composites = new Array();
			composites.push(root);
		}
		
		public function update():void{
			root.run(bb);
		}
		
		public function get blackboard():BlackBoard{
			return bb;
		}
		
		public function composite(task:Task):TaskTree{
			composites.push(task);
			head.addSubtask(task);
			head = task;
			return this;
		}
		
		public function add(task:Task):TaskTree{
			if(!head)
				return null;
				
			head.addSubtask(task);
			return this;
		}
		
		//PRE: composite is called before hand
		public function end():TaskTree{
			if(composites.length == 1)
				return null;
			
			composites.pop();
			head = composites[composites.length - 1];
			return this;
		}
	}
}