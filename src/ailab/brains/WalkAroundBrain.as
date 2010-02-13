package ailab.brains
{
	import ailab.*;
	import ailab.actions.*;
	import ailab.conditions.*;
	import ailab.decorators.*;
	import ailab.groups.*;

	public class WalkAroundBrain extends TaskTree
	{
		public function WalkAroundBrain()
		{
			super();
			
			composite(new SelectorTask())
				.composite(new SequenceTask())
					.add(new PlayAnimWalk())
					.add(new WalkUntilNoPlatformTask())
				.end()
				.composite(new SequenceTask())
					.add(new StopTask())
					.add(new TurnTask())
				.end()
			.end()
			;
		}
	}
}