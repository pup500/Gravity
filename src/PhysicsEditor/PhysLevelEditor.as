package PhysicsEditor
{	
	import Box2D.Common.Math.b2Vec2;
	
	import PhysicsEditor.Panels.ActionPanel;
	import PhysicsEditor.Panels.JointPanel;
	import PhysicsEditor.Panels.OptionPanel;
	import PhysicsEditor.Panels.TypePanel;
	
	import PhysicsGame.LevelSelectMenu;
	
	import common.XMLMap;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.overrides.ExState;
	
	/**
	 * This is the Level Editor.
	 * @author Minh
	 */
	public class PhysLevelEditor extends ExState
	{	
		[Embed(source="../data/editor/help.txt", mimeType="application/octet-stream")] public var helpFile:Class;
		
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		
		private var xmlMapLoader:XMLMap;
		
		private var args:Dictionary;
		
		private var actionPanel:ActionPanel;
		private var optionPanel:OptionPanel;
		private var typePanel:TypePanel;
		private var jointPanel:JointPanel;
		
		public function PhysLevelEditor() 
		{
			super();
			bgColor = 0xffeeeeff;
			the_world.SetGravity(new b2Vec2(0,0));
			
			debug = true;
			initBox2DDebugRendering();
			debug_sprite.visible = false;
			
			FlxG.showCursor(cursorSprite);
			
			args = new Dictionary();
			
			//This turns the event layer to visible
			ev.visible = true;
			
			addPlayer();
			
			actionPanel = new ActionPanel(5, 5);
			addChild(actionPanel.getSprite());
			
			optionPanel = new OptionPanel(590, 5);
			addChild(optionPanel.getSprite());
			
			typePanel = new TypePanel(55, 5, true);
			addChild(typePanel.getSprite());
			
			jointPanel = new JointPanel(190, 5, true);
			addChild(jointPanel.getSprite());

		}
		
		public function addPlayer():void{
			var body:Player = new Player(100, 100);
			body.createPhysBody(the_world);
			body.GetBody().SetSleepingAllowed(false);
			body.GetBody().SetFixedRotation(true);
			add(body);
			
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			FlxG.followBounds(0,0,1280,960);
		}
		
		override public function update():void{
			if(FlxG.keys.pressed("SHIFT") && FlxG.keys.justPressed("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			super.update();
			
			actionPanel.update();
			optionPanel.update();
			typePanel.update();
			jointPanel.update();
		}
	}
}