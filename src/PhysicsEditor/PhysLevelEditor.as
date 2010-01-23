package PhysicsEditor
{	
	import Box2D.Common.Math.b2Vec2;
	
	import PhysicsEditor.Panels.Panels;
	
	import PhysicsGame.LevelSelectMenu;
	
	import common.XMLMap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
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
		
		private var xmlMapLoader:XMLMap;
		
		private var panels:Panels;
		
		private var files:Array;
		private var fileIndex:uint;
		private var statusText:TextField;
		
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
			
			files = new Array();
			loadAssetList("data/editor/LevelEditor.txt");
			
			addPlayer();
			
			panels = new Panels(this);
			
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
			statusText.x = 5;
			statusText.y = 460;
			statusText.height = 16;
			statusText.width = 630;
			addChild(statusText);
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
			
			//True only after the config file has been loaded
			if(!_loaded) 
				return;
			
			if(FlxG.keys.justPressed("LBRACKET")) {
				fileIndex--;
			}
			if(FlxG.keys.justPressed("RBRACKET")){
				fileIndex++;
			}
			
			if(fileIndex >= files.length) 
				fileIndex = files.length - 1;
			if(fileIndex < 0) 
				fileIndex = 0;
			
			args["file"] = files[fileIndex];
			statusText.text = args["file"];
			
			panels.update();
		}
	}
}