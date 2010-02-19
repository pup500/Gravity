package ai.brains
{
	import ai.*;
	import ai.conditions.*;
	import ai.decorators.*;
	import ai.actions.*;

	public class JumpAroundBrain extends TaskTree
	{
		public function JumpAroundBrain()
		{
			super();
			
			composite(new SelectorTask())
				.composite(new SequenceTask())
					.add(new Not(new IsMoving()))
					.composite(new RandomTask())
						.add(new JumpTask())
						.add(new TurnTask())
						.add(new Task())
					.end()
					.add(new WalkTask())
				.end()
			.end()
			.composite(new SequenceTask())
				.add(new IsFalling())
				.add(new CanJump())
				.composite(new RandomTask())
					.add(new JumpTask())
					.add(new TurnTask())
				.end()
			.end()
			.composite(new SequenceTask())
				.add(new WalkTask())
				.add(new CanJump())
				.add(new Not(new IsFalling()))
				.add(new PlayAnimWalk())
			.end();
		}
	}
}