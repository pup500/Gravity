package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.LevelSelectMenu;
	
	import common.XMLMap;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * This is the Level Editor.
	 * @author Minh
	 */
	public class LevelEditor extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		//[Embed(source="LevelEditor.txt", mimeType="application/octet-stream")] public var configFile:Class;
		
		[Embed(source="../data/start_point.png")] private var startSprite:Class;
		[Embed(source="../data/end_point.png")] private var endSprite:Class;
		
		private var xmlMapLoader:XMLMap;
		
		private var files:Array;
		private var _loaded:Boolean;
		private var index:int;
		private var lastIndex:int;
		
		private var edit:Boolean;
		private var active:Boolean;

		private var text:FlxText;
		private var copyButton:SimpleButton;
		
		private var statusText:TextField;
		private var previewImg:Shape;
		private var startImg:FlxSprite;
		private var endImg:FlxSprite;
		
		private const BLACK:Number = 0xFF000000;
		private const WHITE:Number = 0xFFFFFFFF;
		private const RED:Number = 0xFFFF0000;
		
		public function LevelEditor() 
		{
			super();
			bgColor = 0xff000000;
			the_world.SetGravity(new b2Vec2(0,0));
			
			//debug = true;
			initBox2DDebugRendering();
			
			FlxG.showCursor(cursorSprite);
			
			_loaded = false;
			files = new Array();
			edit = false;
			active = false;
			startImg = new FlxSprite(0,0,startSprite);
			endImg = new FlxSprite(0,0,endSprite);
			
			add(startImg);
			add(endImg);
			
			loadLevelConfig();
			addPlayer();
			loadAssetList("data/LevelEditor.txt");
			setHUD();
			setInstructions();
		}
		
		private function loadLevelConfig():void{
			var file:String = FlxG.levels[FlxG.level];
			xmlMapLoader = new XMLMap(this);
			xmlMapLoader.loadConfigFile(file);
		}
		
		override public function init():void{
			startImg.x = xmlMapLoader.getStartPoint().x;
			startImg.y = xmlMapLoader.getStartPoint().y;
			
			endImg.x = xmlMapLoader.getEndPoint().x;
			endImg.y = xmlMapLoader.getEndPoint().y;
		}
		
		private function addPlayer():void{
			var body:Player = new Player(100, 20, null);
			
			body.createPhysBody(the_world);
			body.final_body.AllowSleeping(false);
			body.final_body.SetFixedRotation(true);
			add(body);
			
			//Set camera to follow player movement.
			//This works, in debug mode it looks weird but that's because of layer offset...
			FlxG.follow(body,2.5);
			FlxG.followAdjust(0.5,0.0);
			//FlxG.followBounds(0,0,640,640);
			FlxG.followBounds(0,0,1280,960);
		}
		
		private function setHUD():void{
			addChild(statusText = new TextField());
			addChild(previewImg = new Shape());
			
			statusText.x = 10;
			statusText.y = 0;
			
			//setPreviewImg(files[index]);
			
			addCopyButton();
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
			_loaded = true;
		}
		
		private function readImageList():void{
			lastIndex = index = 0;
			
			//var s:String = new configFile;
			//files = s.split("\n");
		}
		
		private function setInstructions():void{
			FlxG.log("[ and ] rotate among image files in the SpriteEditor.txt file");
			FlxG.log(", and . set the start and end points on a map");
			FlxG.log("WASD move player object simulate scrolling");
			FlxG.log("E toggles edit mode (mouse click to add new shape)");
			FlxG.log("I toggles active/inactive flag on body creation");
			FlxG.log("Z undo last edit");
			FlxG.log("Mouse clicks will add the selected shape at mouse coordinates");
			FlxG.log("Click on top-left corner box to copy the new config settings to clipboard");
		}
		
		private function addCopyButton():void {
			var rect:Rectangle = new Rectangle(0,0,9,9);
			var down:Sprite = new Sprite();
			down.graphics.lineStyle(1, 0x000000);
			down.graphics.beginFill(0xFFCC00);
			down.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			var up:Sprite = new Sprite();
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(0x0099FF);
			up.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			var over:Sprite = new Sprite();
			over.graphics.lineStyle(1, 0x000000);
			over.graphics.beginFill(0x9966FF);
			over.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			copyButton = new SimpleButton();
			
			copyButton.upState = up;
			copyButton.overState = over;
			copyButton.downState = down;
			copyButton.useHandCursor = true;
			copyButton.hitTestState = up;
			copyButton.x = 1;
			copyButton.y = 2;
			
			addChild(copyButton);
			  
			copyButton.addEventListener(MouseEvent.CLICK, onCopy);
		}

		private function setStatusText(text:String, color:Number=WHITE):void{
			statusText.text = text;
			statusText.width = text.length * 15;
			statusText.textColor = color;
		}
		
		private function setPreviewImg(imgFile:String):void{
			trace(imgFile);
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSetPreviewComplete);
    		loader.load(new URLRequest(imgFile));
		}
		
		private function onSetPreviewComplete(event:Event):void{
			 var bitmapData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			 previewImg.graphics.clear();
			 previewImg.graphics.beginBitmapFill(bitmapData);
			 previewImg.graphics.drawRect(0,0,bitmapData.width,bitmapData.height);
			 previewImg.graphics.endFill();
		}
		
		public function onCopy(e:Event):void{
			copy(xmlMapLoader.getConfiguration());
		}
		
		private function copy(text:String):void{
            System.setClipboard(text);
        }

		override public function update():void
		{
			super.update();
			
			if(!_loaded){
				return;
			}
			
			if(FlxG.keys.justReleased("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			if(FlxG.keys.justReleased("Z")) {
				xmlMapLoader.undo();
			}
			
			if(FlxG.keys.justReleased("I")){
				active = !active;
			}
			
			handlePreview();
			handleMode();
			handleMouse();
		}
		
		private function handlePreview():void{
			lastIndex = index;
			if(FlxG.keys.justReleased("LBRACKET")) {
				index--;
			}
			if(FlxG.keys.justReleased("RBRACKET")){
				index++;
			}
			
			if(FlxG.keys.justReleased("ONE")){
				index = 0;
			}
				
			if(FlxG.keys.justReleased("TWO")){
				index = 1;
			}
			
			
			if(index >= files.length) 
				index = files.length - 1;
			if(index < 0) 
				index = 0;
			
			if(lastIndex != index)
				setPreviewImg(files[index]);
			
			previewImg.x = mouseX;
			previewImg.y = mouseY;
			
			previewImg.alpha = edit ? .7 : .5;
		}
		
		private function handleMode():void{
			if(FlxG.keys.justReleased("E")) 
				edit = !edit;
				
			var action:String = edit ? "EDIT" : "VIEW";
			var inact:String = active ? "ACTIVE" : "STATIC";
			var status:Array = [action, inact, "FILE: " + files[index]];
			setStatusText(status.join(" | "), edit ? RED : WHITE);
		}
		
		private function handleMouse():void{
			if(FlxG.mouse.justPressed()){
				if(edit){
					if(index == 0){
						onStart();
					}
					else if(index == 1){
						onEnd();
					}
					else{
						addObject();
					}
				}
			}
		}
		
		private function addObject():void{
			var shape:XML = new XML(<shape/>);
			shape.file = files[index];
			shape.type = active ? "active" : "static";
			shape.angle = 0;
			shape.x = FlxG.mouse.x;
			shape.y = FlxG.mouse.y;
			shape.contour = "";
			xmlMapLoader.addXMLObject(shape, true);
		}
		
		private function onView():void{
			
		}
		
		private function onStart():void{
			startImg.x = FlxG.mouse.x;
			startImg.y = FlxG.mouse.y;
			xmlMapLoader.setStartPoint(new Point(FlxG.mouse.x, FlxG.mouse.y));
		}
		
		private function onEnd():void{
			endImg.x = FlxG.mouse.x;
			endImg.y = FlxG.mouse.y;
			xmlMapLoader.setEndPoint(new Point(FlxG.mouse.x, FlxG.mouse.y));
		}
		
	}
}