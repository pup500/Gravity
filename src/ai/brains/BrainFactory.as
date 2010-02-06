package ai.brains
{
	import ai.*;
	import ai.actions.*;
	import ai.conditions.*;
	import ai.decorators.*;

	public class BrainFactory
	{
		public function BrainFactory()
		{
		}
		
		public static function createDefaultBrain():TaskTree{
			return new TaskTree()
				.composite(new SequenceTask())
					.add(new Not(new CanWalkForward()))
					.add(new StopTask())
					.add(new PlayAnimIdle())
					.add(new TurnTask())
				.end()
				.composite(new SequenceTask())
					.add(new CanWalkForward())
					.add(new WalkTask())
					.add(new PlayAnimWalk())
				.end()
			;
		}
		
	public static function createWalkingBrain():TaskTree{
			return new TaskTree()
				.composite(new SelectorTask())
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
				.end()
			;
		}

		
	}
}