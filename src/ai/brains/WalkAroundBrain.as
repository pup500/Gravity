package ai.brains
{
	import ai.*;
	import ai.conditions.*;
	import ai.decorators.*;
	import ai.actions.*;

	public class WalkAroundBrain extends TaskTree
	{
		public function WalkAroundBrain()
		{
			super();
			
			composite(new SequenceTask())
				.add(new Not(new CanWalkForward()))
				.add(new StopTask())
				.add(new PlayAnimIdle())
				.add(new TurnTask())
			.end()
			.composite(new SequenceTask())
				.add(new CanWalkForward())
				.add(new WalkTask())
				.add(new PlayAnimWalk())
			.end();
		}
	}
}