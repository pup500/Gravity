package ailab.brains
{
	import ailab.*;
	import ailab.actions.*;
	import ailab.conditions.*;
	import ailab.decorators.*;
	import ailab.groups.*;

	public class JumpAroundBrain extends TaskTree
	{
		public function JumpAroundBrain()
		{
			super();
			
			composite(new SelectorTask())
				.composite(new SequenceTask())
					.add(new PlayAnimWalk())
					.add(new WalkTask())
				.end()
				.composite(new RandomTask())
					//This seems to work out well
					.composite(new SequenceTask())
						.add(new JumpTask())
						.add(new TimeOut(new MoveTask(), .5, TaskResult.SUCCEEDED))
					.end()
					.add(new TurnTask())
				.end()
			.end()
			;
		}
	}
}