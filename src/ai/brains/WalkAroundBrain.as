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
			
			//We can do two things, allow can walk forward action to actually do ray trace each time it is called
			//Or have memory of it during normal update or render
			//The problem is that if we turn the enemy around, can walk might be changed, but changing it through
			//Other means seems like a hack
			//2) We can alter the behavior by having this section at the top, this would allow
			//The can walk logic be performed before this is ever called, solving problem and improving performance...
			
			composite(new SequenceTask())
				.add(new CanWalkForward())
				.add(new WalkTask())
				.add(new PlayAnimWalk())
			.end()
			.composite(new SequenceTask())
				.composite(new SelectorTask())
					.add(new Not(new CanWalkForward()))
					//.add(new Not(new IsMoving()))
				.end()
				.add(new StopTask())
				.add(new PlayAnimIdle())
				.add(new TurnTask())
			.end()
			
			/*.composite(new SequenceTask())
				.add(new Not(new IsMoving()))
				.add(new TurnTask())
			.end()*/
			;
		}
	}
}