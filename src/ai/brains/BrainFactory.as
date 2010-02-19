package ai.brains
{
	import ai.*;
	import ai.actions.*;
	import ai.conditions.*;
	import ai.decorators.*;

	public class BrainFactory
	{
		public static var BRAINS:Array = [
			WalkAroundBrain,
			JumpAroundBrain
			];
			
		public function BrainFactory()
		{
		}
		
		public static function createRandomBrain():TaskTree{
			var i:uint = Math.floor(Math.random()*BRAINS.length);
			return new BRAINS[i]();
		}
		
		public static function createBrain(i:uint=0):TaskTree{
			if(i < 0 || i >= BRAINS.length)
				return null;
			
			return new BRAINS[i]();
		}
		
		/*
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
			return new BRAINS[0]();
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
		
	*/
	}
}