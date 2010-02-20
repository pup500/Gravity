package PhysicsGame.Components
{
	import Box2D.Common.Math.b2Vec2;
	
	import PhysicsGame.Player;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class InputComponent implements IComponent
	{
		protected var me:Player;
		
		//TODO:Change this into ExSprite
		public function InputComponent(obj:Player)
		{
			me = obj;
		}

		public function update():void
		{
			
			var _applyForce:b2Vec2 = new b2Vec2(0,0);
			
			////trace("vel.x " + final_body.GetLinearVelocity().x);
			//MOVEMENT
			//acceleration.x = 0;
			if(FlxG.keys.A)
			{
				me.facing = FlxSprite.LEFT;
				_applyForce.x = -75;//_canJump ? -7 : -2;  (this was originally -7 -MK)
				_applyForce.y = 0;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				//final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
				
				if(me.GetBody().GetLinearVelocity().x < -3.5) {
					
				}
				else
				
					me.GetBody().ApplyForce(_applyForce, me.GetBody().GetWorldCenter());
				//final_body.GetLinearVelocity().x = -30;
			}
			else if(FlxG.keys.D)
			{
				me.facing = FlxSprite.RIGHT;
				//final_body.GetLinearVelocity().x = 30;
				_applyForce.x = 75;//_canJump ? 7 : 2;    (this was originally 7  -MK)
				_applyForce.y = 0;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				//_applyForce.Multiply(final_body.GetMass());
				if(me.GetBody().GetLinearVelocity().x > 3.5) {
				}
				else
				//final_body.ApplyImpulse(_applyForce, final_body.GetWorldCenter());
					me.GetBody().ApplyForce(_applyForce, me.GetBody().GetWorldCenter());
			}

			////trace("can jump: " + _canJump);
			////trace("vel" + final_body.m_linearVelocity.y);
			////TODO only when collision from bottom
			if((FlxG.keys.SPACE || FlxG.keys.W) && me._canJump && !me._justJumped)//impactPoint.position.y > y + height - 1)///&& Math.abs(final_body.m_linearVelocity.y) < 0.1)
			{
				//Hack... attempt at jumping...
				//impactPoint.position.y = -100;
				me._canJump = false;
				me._justJumped = true;
				me._jumpTimer.start();
				
				//velocity.y = -_jumpPower;
				//final_body.SetLinearVelocity(new b2Vec2(0,-_jumpPower));
				_applyForce.x = 0;
				_applyForce.y = -5;
				//We multiply this here because it is later multiplied by inverse mass. - Minh
				_applyForce.Multiply(me.GetBody().GetMass());
				
				////trace("mass" + final_body.GetMass());
				
				//Apply a instantaneous upward force.
				me.GetBody().ApplyImpulse(_applyForce, me.GetBody().GetWorldCenter());
				//final_body.GetLinearVelocity().Set(_applyForce.x, _applyForce.y);
			}
		}
		
	}
}