package PhysicsEditor.Fields
{
	import flash.display.Sprite;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	
	public class Fields
	{
		protected var fields:Array;
		
		public function Fields(state:ExState)
		{
			//This is how you create new panels
			fields = [
				new AngleField(),
				new FrictionField(),
				new BounceField(),
				new DensityField(),
				new DamageField(),
				new SpeedField(),
				new TorqueField()
			];
			
			for(var i:uint=0; i < fields.length; i++){
				var sprite:Sprite = fields[i].getSprite() as Sprite;
				sprite.x = 545;//i*90 + 140;
				sprite.y = i*20 + 300;//440;
				//sprite.x = i*90 + 140;
				//sprite.y = 440;
				
				state.addChild(sprite);
			}
		}
		
		public function update():void{
			for each(var field:FieldBase in fields){
				//Toggle visibility of control panels when SHIFT key is held
				field.getSprite().visible = !FlxG.keys.SHIFT;
				field.update();
			}
		}

	}
}