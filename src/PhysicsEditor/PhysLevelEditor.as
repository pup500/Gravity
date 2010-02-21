package PhysicsEditor
{	
	import Box2D.Common.Math.b2Vec2;
	
	import PhysicsEditor.Fields.Fields;
	import PhysicsEditor.Panels.Panels;
	
	import PhysicsGame.ContactListener;
	import PhysicsGame.EventObject;
	import PhysicsGame.LevelSelectMenu;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
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
		
		private var panels:Panels;
		
		private var files:Array;
		private var fileIndex:int;
		private var statusText:TextField;
		
		private var eventType:int;
		
		private var fields:Fields;
		
		public function PhysLevelEditor() 
		{
			super();
			bgColor = 0xffeeeeff;
			the_world.SetGravity(new b2Vec2(0,10));
			
			debug = true;
			initBox2DDebugRendering();
			debug_sprite.visible = false;
			
			FlxG.showCursor(cursorSprite);
			
			//This turns the event layer to visible
			ev.visible = true;
			
			eventType = 0;
			
			files = new Array();
			loadAssetList("data/editor/LevelEditor.txt");
			
			addPlayer();
			
			panels = new Panels(this);
			fields = new Fields(this);
			
			xmlMapLoader.loadConfigFile(FlxG.levels[FlxG.level]);
			
			initContactListener();
		}
		
				
		private function initContactListener():void{
			the_world.SetContactListener(new ContactListener());
		}
		
		//Load the config file to set up world...
		public function loadAssetList(file:String):void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadAssetList);
			//loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(file));
		}
		
		//Actual callback function for load finish
		private function onLoadAssetList(event:Event):void{
			var s:String = event.target.data;
			files = s.split("\n");
			fileIndex = 0;
			_loaded = true;
			
			createStatusText();
		}
		
		private function createStatusText():void{
			statusText = new TextField;
			statusText.background = true;
			statusText.border = true;
			statusText.selectable = false;
			statusText.x = 5;//140;
			statusText.y = 460;
			statusText.height = 16;
			statusText.width = 630;//490;
			addChild(statusText);
		}
		
		public function addPlayer():void{
			var body:Player = new Player(100, 100);
			//body.createPhysBody(the_world);
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
			
			//True only after the config file has been loaded
			if(!_loaded) 
				return;
			
			if(FlxG.keys.justPressed("LBRACKET")) {
				fileIndex--;
			}
			if(FlxG.keys.justPressed("RBRACKET")){
				fileIndex++;
			}
			
			if(FlxG.keys.justPressed("O")) {
				eventType--;
			}
			if(FlxG.keys.justPressed("P")){
				eventType++;
			}
			
			if(fileIndex >= files.length) 
				fileIndex = files.length - 1;
			if(fileIndex < 0) 
				fileIndex = 0;
				
			if(eventType < 0)
				eventType = EventObject.EVENTS.length - 1;
			if(eventType >= EventObject.EVENTS.length)
				eventType = 0;
			
			args["file"] = files[fileIndex];
			args["event"] = eventType;
			statusText.text = args["file"] + " | " + EventObject.EVENTS[eventType].toString() + " | " + FlxG.mouse.x + ", " + FlxG.mouse.y;
			
			panels.update();
			fields.update();
		}
	}
}