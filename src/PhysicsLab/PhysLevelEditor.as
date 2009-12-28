﻿package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.LevelSelectMenu;
	
	import common.XMLMap;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
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
	public class PhysLevelEditor extends ExState
	{
		[Embed(source="../data/cursor.png")] private var cursorSprite:Class;
		
		[Embed(source="../data/start_point.png")] private var startSprite:Class;
		[Embed(source="../data/end_point.png")] private var endSprite:Class;
		
		private var xmlMapLoader:XMLMap;
		
		private var files:Array;
		private var _loaded:Boolean;
		private var index:int;
		private var lastIndex:int;
		
		private var handledMouse:Boolean;
		private var active:Boolean;

		private var statusText:TextField;
		private var previewImg:Shape;
		private var grid:Shape;
		private var snapToGrid:Boolean;
		
		private var startImg:FlxSprite;
		private var endImg:FlxSprite;
		
		
		private var hud:Sprite;
		private var toolPanel:FlxLayer;
		private var mode:uint;
		
		private const BLACK:Number = 0xFF000000;
		private const WHITE:Number = 0xFFFFFFFF;
		private const RED:Number = 0xFFFF0000;
		
		private const KILL:uint = 0;
		private const EDIT:uint = 1;
		private const VIEW:uint = 2;
		
		public function PhysLevelEditor() 
		{
			super();
			bgColor = 0xffeeeeff;;
			the_world.SetGravity(new b2Vec2(0,0));
			
			//debug = true;
			initBox2DDebugRendering();
			
			FlxG.showCursor(cursorSprite);
			
			_loaded = false;
			files = new Array();
			handledMouse = false;
			active = false;
			startImg = new FlxSprite(0,0,startSprite);
			endImg = new FlxSprite(0,0,endSprite);
			
			add(startImg);
			add(endImg);
			
			
			
			loadLevelConfig();
			addPlayer();
			loadAssetList("data/LevelEditor.txt");
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
			
			
			//This puts the layer to be rendered last...
			setHUD();
			
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
		
		private function setupGrid():void{
			snapToGrid = true;
			grid = new Shape();
			grid.x = 0;
			grid.y = 0;
			
			for(var x:Number = 0; x <= FlxG.width; x += 4){
				grid.graphics.lineStyle(1,BLACK,x%16==0 ? .5 : .2);
				grid.graphics.moveTo(x,0);
				grid.graphics.lineTo(x,FlxG.height);
			}
			
			for(var y:Number = 0; y <= FlxG.height; y += 4){
				grid.graphics.lineStyle(1,BLACK,y%16==0 ? .5 : .2);
				grid.graphics.moveTo(0,y);
				grid.graphics.lineTo(FlxG.width,y);
			}
		}
		
		private function setHUD():void{
			statusText = new TextField();
			statusText.x = 10;
			statusText.y = 0;
			
			addChild(previewImg = new Shape());
			
			setupGrid();
				
			hud = new Sprite();
			
			hud.addChild(statusText);
			hud.addChild(grid);
			addChild(hud);
			
			
			var actions:Array = [onSetKill, onSetEdit, onSetCopy]
			toolPanel = new FlxLayer();
			
			var panelBackground:FlxSprite = new FlxSprite(0,0);
			panelBackground.createGraphic(50,150,0xff000000);
			panelBackground.scrollFactor.x = 0;
			panelBackground.scrollFactor.y = 0;
			panelBackground.x = 2;
			panelBackground.y = 25;
			toolPanel.add(panelBackground);
			
			toolPanel.add(addButton(5,30,"KILL",actions[0]));
			toolPanel.add(addButton(5,60,"EDIT",actions[1]));
			toolPanel.add(addButton(5,90,"COPY",actions[2]));
			add(toolPanel);
			
		}
		
		private function onSetKill():void{
			mode = KILL;
			FlxG.mouse.reset();
		}
		
		private function onSetEdit():void{
			mode = EDIT;
			FlxG.mouse.reset();
		}
		
		private function onSetCopy():void{
			copy(xmlMapLoader.getConfiguration());
			FlxG.mouse.reset();
		}
		
		private function addButton(x:int, y:int, text:String, onClick:Function):ExButton
		{
			//Create the button, image and highlighted image
			var button:ExButton = new ExButton(x,y,onClick);
			var image:FlxSprite = (new FlxSprite()).createGraphic(40,20,0xff3a5c39);
			var imagehl:FlxSprite = (new FlxSprite()).createGraphic(40,20,0xff729954);
			
			button.loadGraphic(image, imagehl);
			
			//Create the text and highlighted text on the button
			var t1:FlxText = new FlxText(5,1,100,text);
			t1.color = 0x729954;
			var t2:FlxText = new FlxText(t1.x,t1.y,t1.width,t1.text);
			t2.color = 0xd8eba2;
			button.loadText(t1,t2);
			
			//Make this button a HUD Element
			button.scrollFactor.x = 0;
			button.scrollFactor.y = 0;
			
			return button;
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
			
			setPreviewImg(files[index]);
		}
		
		private function setInstructions():void{
			FlxG.log("[ and ] rotate among image files in the SpriteEditor.txt file");
			FlxG.log(", and . set the start and end points on a map");
			FlxG.log("WASD move player object simulate scrolling");
			FlxG.log("E toggles edit mode (mouse click to add new shape)");
			FlxG.log("I toggles active/inactive flag on body creation");
			FlxG.log("Z undo last edit");
			FlxG.log("G toggles grid");
			FlxG.log("H toggles HUD panel");
			FlxG.log("SHIFT CLICK will add/kill the selected shape at mouse coordinates");
			FlxG.log("Click on copy button to copy the new config settings to clipboard");
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
			
			if(FlxG.keys.justPressed("H")){
				toolPanel.visible = !toolPanel.visible;
			}
			
			if(FlxG.keys.justPressed("G")){
				grid.visible = !grid.visible;
			}
			
			if(FlxG.keys.justPressed("N")){
				snapToGrid = !snapToGrid;
			}
			
			handlePreview();
			handleMode();
			handleMouse();
		}
		
        override public function render():void{
        	super.render();
        	if(toolPanel && toolPanel.visible){
        		toolPanel.render();
        	}
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
		}
		
		private function handleMode():void{
			if(FlxG.keys.justReleased("E")){ 
				if(mode != EDIT){
					mode = EDIT;
				}
				else{
					mode = KILL;
				}
			}
				
			var actions:Array = ["KILL", "EDIT"];
			var action:String = actions[mode];
			var inact:String = active ? "ACTIVE" : "STATIC";
			var snap:String = snapToGrid ? "SNAP" : "FREE";
			var status:Array = [action, inact, snap, "FILE: " + files[index], FlxG.mouse.x, FlxG.mouse.y];
			setStatusText(status.join(" | "), BLACK);
		}
		
		private function handleMouse():void{
			var point:Point = new Point();
			point.x = FlxG.mouse.x;
			point.y = FlxG.mouse.y;
			
			previewImg.x = mouseX;
			previewImg.y = mouseY;
				
			if(snapToGrid){
				point.x -= point.x % 16;
				point.y -= point.y % 16;
				
				//Handles snapping to 16...
				previewImg.x -= (mouseX % 16);
				previewImg.y -= (mouseY % 16);
			}
			
			previewImg.visible = mode != KILL;
			previewImg.alpha = .5;
			
			if(FlxG.keys.SHIFT){
				previewImg.alpha = 1;
			}

			//Shift click to add and delete... This allows the user to press the tool buttons without messing up
			if(FlxG.mouse.justPressed() && FlxG.keys.pressed("SHIFT")){
				if(mode == EDIT){
					if(index == 0){
						onStart(point);
					}
					else if(index == 1){
						onEnd(point);
					}
					else{
						addObject(point);
					}
				}
				else if(mode == KILL){
					xmlMapLoader.removeObjectAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true);
				}
			}
		}
		
		private function addObject(point:Point):void{
			var shape:XML = new XML(<shape/>);
			shape.file = files[index];
			shape.type = active ? "active" : "static";
			shape.angle = 0;
			shape.x = point.x;
			shape.y = point.y;
			shape.contour = "";
			xmlMapLoader.addXMLObject(shape, true);
		}
		
		private function onStart(point:Point):void{
			startImg.x = point.x;
			startImg.y = point.y;
			xmlMapLoader.setStartPoint(new Point(point.x, point.y));
		}
		
		private function onEnd(point:Point):void{
			endImg.x = point.x;
			endImg.y = point.y;
			xmlMapLoader.setEndPoint(new Point(point.x, point.y));
		}
	}
}