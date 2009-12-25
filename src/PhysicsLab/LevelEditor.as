package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.MapClasses.*;
	
	import common.XMLMap;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.overrides.*;
	
	/**
	 * This is the Level Editor.
	 * @author Minh
	 */
	public class LevelEditor extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		[Embed(source="LevelEditor.txt", mimeType="application/octet-stream")] public var configFile:Class;
		
		private var xmlMapLoader:XMLMap;
		
		private var files:Array;
		private var index:uint;
		private var lastIndex:uint;
		
		private var edit:Boolean;
		private var text:FlxText;
		private var copyButton:SimpleButton;
		
		private var statusText:TextField;
		private var previewImg:Shape;
		
		private const BLACK:Number = 0x0;
		private const WHITE:Number = 0xFFFFFF;
		private const RED:Number = 0xFF0000;
		
		public function LevelEditor() 
		{
			super();
			the_world.SetGravity(new b2Vec2(0,0));
			
			//debug = true;
			initBox2DDebugRendering();
			
			FlxG.showCursor(cursorSprite);
			
			edit = false;
			
			loadLevelConfig();
			addPlayer();
			readImageList();
			setHUD();
			setInstructions();
		}
		
		private function loadLevelConfig():void{
			xmlMapLoader = new XMLMap(this);
			xmlMapLoader.loadConfigFile("data/Maps/level1.xml");
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
			FlxG.followBounds(0,0,640,640);
		}
		
		private function setHUD():void{
			addChild(statusText = new TextField());
			addChild(previewImg = new Shape());
			
			statusText.x = 10;
			statusText.y = 0;
			setPreviewImg(files[index]);
			
			addCopyButton();
		}
		
		private function readImageList():void{
			lastIndex = index = 0;
			
			var s:String = new configFile;
			files = s.split("\n");
		}
		
		private function setInstructions():void{
			FlxG.log("[ and ] rotate among image files in the SpriteEditor.txt file");
			FlxG.log("WASD move player object simulate scrolling");
			FlxG.log("E toggles edit mode (mouse click to add new shape)");
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
			
			if(FlxG.keys.justReleased("E")) 
				edit = !edit;

			handlePreview();
			handleStatusText();
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
		
		private function handleStatusText():void{
			var mode:String = edit ? "EDITING MODE" : "VIEWING MODE";
			var status:Array = [mode, "FILE: " + files[index]];
			setStatusText(status.join(" | "), edit ? RED : WHITE);
		}
		
		private function handleMouse():void{
			if(edit && FlxG.mouse.justPressed()){
				var shape:XML = new XML(<shape/>);
				shape.file = files[index];
				shape.type = "static";
				shape.angle = 0;
				shape.x = FlxG.mouse.x;
				shape.y = FlxG.mouse.y;
				shape.contour = "";
				
				xmlMapLoader.addXMLObject(shape, true);
			}
		}
	}
}