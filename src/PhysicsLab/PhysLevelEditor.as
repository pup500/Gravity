﻿package PhysicsLab
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import PhysicsGame.LevelSelectMenu;
	
	import common.Utilities;
	import common.XMLMap;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
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
		[Embed(source="../data/editor/interface/dino.mp3")] private var dinoSound:Class;
		
		[Embed(source="../data/start_point.png")] private var startSprite:Class;
		[Embed(source="../data/end_point.png")] private var endSprite:Class;
		
		[Embed(source="../data/editor/interface/connect-icon.png")] private var joinImg:Class;
		[Embed(source="../data/editor/interface/disconnect-icon.png")] private var breakImg:Class;
		[Embed(source="../data/editor/interface/delete.png")] private var killImg:Class;
		[Embed(source="../data/editor/interface/add.png")] private var editImg:Class;
		[Embed(source="../data/editor/interface/save.png")] private var copyImg:Class;
		[Embed(source="../data/editor/interface/grid.jpg")] private var gridImg:Class;
		[Embed(source="../data/editor/interface/elephant-icon.png")] private var activeImg:Class;
		[Embed(source="../data/editor/interface/snap.jpg")] private var snapImg:Class;
		[Embed(source="../data/editor/interface/frog-icon.png")] private var physicsImg:Class;
		[Embed(source="../data/editor/interface/mammoth-icon.png")] private var playImg:Class;
		[Embed(source="../data/editor/interface/help.png")] private var helpImg:Class;
		[Embed(source="../data/editor/interface/change.png")] private var changeImg:Class;
		
		private var xmlMapLoader:XMLMap;
		
		private var files:Array;
		private var index:int;
		private var lastIndex:int;
		private var layer:uint;
		
		
		private var mode:uint;
		private var active:Boolean;
		private var usePoly:Boolean;
		private var run:Boolean;
		private var addJoint:Boolean;

		private var jointType:uint;
		private var jointsImage:Shape;
		private var assetImage:Shape;
		private var drawingBox:Boolean;
		private var line:Shape;
		private var drawingLine:Boolean;
		private var startPoint:Point;
		
		private var grid:Shape;
		private var snapToGrid:Boolean;
		
		private var startImg:FlxSprite;
		private var endImg:FlxSprite;
		
		private var helpText:TextField;
		private var statusText:TextField;
		private var modeText:TextField;
		
		private var textValue:String;
		
		private var actionsPanel:Sprite;
		private var joinButton:Sprite;
		private var breakButton:Sprite;
		private var killButton:Sprite;
		private var editButton:Sprite;
		private var copyButton:Sprite;
		private var playButton:Sprite;
		private var changeButton:Sprite;
			
		private var optionsPanel:Sprite;
		private var gridButton:Sprite;
		private var snapButton:Sprite;
		private var activeButton:Sprite;
		private var debugButton:Sprite;
		private var helpButton:Sprite;
		
		private const BLACK:Number = 0xFF000000;
		private const WHITE:Number = 0xFFFFFFFF;
		private const RED:Number = 0xFFFF0000;
		
		private const KILL:uint = 0;
		private const EDIT:uint = 1;
		private const JOIN:uint = 2;
		private const BREAK:uint = 3;
		private const CHANGE:uint = 4;

		private const WIDTH:uint = 1280;
		private const HEIGHT:uint = 960;
		
		public function PhysLevelEditor() 
		{
			super();
			bgColor = 0xffeeeeff;
			the_world.SetGravity(new b2Vec2(0,0));
			
			debug = true;
			initBox2DDebugRendering();
			debug_sprite.visible = false;
			
			FlxG.showCursor(cursorSprite);
			
			files = new Array();
			active = false;
			snapToGrid = true;
			drawingBox = false;
			drawingLine = false;
			usePoly = false;
			run = false;
			jointType = Utilities.e_distanceJoint;
			
			startImg = new FlxSprite(0,0,startSprite);
			endImg = new FlxSprite(0,0,endSprite);
			
			//box = new FlxSprite(0,0);
			//add(box);
			startPoint = new Point();
			layer = 0;
			
			line = new Shape();
			addChild(line);
			
			add(startImg);
			add(endImg);
			
			jointsImage = new Shape();
			addChild(jointsImage);
			
			loadLevelConfig();
			addPlayer();
			loadAssetList("data/LevelEditor.txt");
			
			createHUD();
			
			//IDEA:
			//Layers are going to be the specification in exsprite, add that when we add an object
			//Sprites are sensors with no interactions
			//Sensor objects are sensors with script xml file...
		}
		
		override protected function initBox2DDebugRendering():void
		{
			if(debug){
				var debug_draw:b2DebugDraw = new b2DebugDraw();
				debug_sprite = new Sprite();
				addChild(debug_sprite);
				debug_draw.SetSprite(debug_sprite);
				debug_draw.SetDrawScale(1);
				debug_draw.SetAlpha(1);
				debug_draw.SetLineThickness(2);
				debug_draw.SetFlags(uint(-1));//b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_obbBit);
				the_world.SetDebugDraw(debug_draw);
			}
		}
		
		private function loadLevelConfig():void{
			var file:String = FlxG.levels[FlxG.level];
			xmlMapLoader = new XMLMap(this);
			xmlMapLoader.loadConfigFile(file);
		}
		
		override public function init():void{
			super.init();
			
			startImg.x = xmlMapLoader.getStartPoint().x;
			startImg.y = xmlMapLoader.getStartPoint().y;
			
			endImg.x = xmlMapLoader.getEndPoint().x;
			endImg.y = xmlMapLoader.getEndPoint().y;
			
			//Set all objects initially to sleep
			updateWorldObjects();
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
			FlxG.followBounds(0,0,WIDTH,HEIGHT);
		}
		
		private function createGrid():void{
			grid = new Shape();
			grid.x = 0;
			grid.y = 0;
			
			for(var x:Number = 0; x <= WIDTH; x += 4){
				grid.graphics.lineStyle(1,BLACK,x%16==0 ? .5 : .2);
				grid.graphics.moveTo(x,0);
				grid.graphics.lineTo(x,HEIGHT);
			}
			
			for(var y:Number = 0; y <= HEIGHT; y += 4){
				grid.graphics.lineStyle(1,BLACK,y%16==0 ? .5 : .2);
				grid.graphics.moveTo(0,y);
				grid.graphics.lineTo(WIDTH,y);
			}
			
			addChild(grid);
		}
		
		private function createImageButton(Graphic:Class, x:uint=0, y:uint=0, panel:Sprite=null, label:String=null, onClick:Function=null):Sprite{
			var bitmap:Bitmap = new Graphic;
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginBitmapFill(bitmap.bitmapData,null,false);
			sprite.graphics.drawRect(0,0,bitmap.bitmapData.width,bitmap.bitmapData.height);
			sprite.graphics.endFill();
			sprite.x = x;
			sprite.y = y;
			
			if(label){
				var tf:TextField = new TextField();
				tf.selectable = false;
				tf.text = label;
				tf.x = bitmap.bitmapData.width;
				tf.y = 10;
				
				sprite.addChild(tf);
			}
			
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			
			if(panel)
				panel.addChild(sprite);
			
			return sprite;
		}
		
		private function onPhysicsClick(event:MouseEvent):void{
			debug_sprite.visible = !debug_sprite.visible;
		}
		
		private function onActiveClick(event:MouseEvent):void{
			active = !active;
		}
		
		private function onSnapClick(event:MouseEvent):void{
			snapToGrid = !snapToGrid;
		}
		
		private function onGridClick(event:MouseEvent):void{
			grid.visible = !grid.visible;
		}
		
		private function onJoinClick(event:MouseEvent):void{
			mode = JOIN;
		}
		
		private function onBreakClick(event:MouseEvent):void{
			mode = BREAK;
		}
		
		private function onKillClick(event:MouseEvent):void{
			mode = KILL;
		}
		
		private function onPlayClick(event:MouseEvent):void{
			run = !run;
		}
		
		private function onEditClick(event:MouseEvent):void{
			mode = EDIT;
		}
		
		private function onChangeClick(event:MouseEvent):void{
			mode = CHANGE;
		}
		
		private function onCopyClick(event:MouseEvent):void{
			copy(xmlMapLoader.createNewConfiguration());
			FlxG.play(dinoSound);
		}
		
		private function onHelpClick(event:MouseEvent):void{
			helpText.visible = !helpText.visible;
		}
		
		private function createActionsPanel():void{
			actionsPanel = new Sprite();
			actionsPanel.x = 5;
			actionsPanel.y = 30;
			actionsPanel.graphics.beginFill(0x888888,1);
			actionsPanel.graphics.lineStyle(2,0x000000,1);
			actionsPanel.graphics.drawRoundRect(0,0,85,250,10,10);//drawRect(5,185,80,240);
			actionsPanel.graphics.endFill();
			
			changeButton = createImageButton(changeImg, 5, 10, actionsPanel, "Change", onChangeClick);
			editButton = createImageButton(editImg, 5, 50, actionsPanel, "Add", onEditClick);
			killButton = createImageButton(killImg, 5, 90, actionsPanel, "Remove", onKillClick);
			joinButton = createImageButton(joinImg, 5, 130, actionsPanel, "Join", onJoinClick);
			breakButton = createImageButton(breakImg, 5, 170, actionsPanel, "Break", onBreakClick);
			playButton = createImageButton(playImg, 5, 210, actionsPanel, "Run", onPlayClick);
			
			copyButton = createImageButton(copyImg, 5, 400, actionsPanel, null, onCopyClick);
			helpButton = createImageButton(helpImg, 590, 400, actionsPanel, null, onHelpClick);
			
			addChild(actionsPanel);
			
			statusText = new TextField;
			statusText.background = true;
			statusText.border = true;
			statusText.selectable = false;
			statusText.x = 100;
			statusText.y = 418;
			statusText.height = 16;
			statusText.width = 489;
			actionsPanel.addChild(statusText);
		}
		
		private function createOptionsPanel():void{
			optionsPanel = new Sprite();
			optionsPanel.x = 550;
			optionsPanel.y = 30;
			optionsPanel.graphics.beginFill(0x888888,1);
			optionsPanel.graphics.lineStyle(2,0x000000,1);
			optionsPanel.graphics.drawRoundRect(0,0,85,180,10,10);//drawRect(5,25,80,140);
			optionsPanel.graphics.endFill();
			
			debugButton = createImageButton(physicsImg, 5, 10, optionsPanel, "Debug", onPhysicsClick);
			activeButton = createImageButton(activeImg, 5, 50, optionsPanel, "Active", onActiveClick);
			snapButton = createImageButton(snapImg, 5, 90, optionsPanel, "Snap", onSnapClick);
			gridButton = createImageButton(gridImg, 5, 130, optionsPanel, "Grid", onGridClick);
			
			addChild(optionsPanel);
		}
		
		private function createHUD():void{
			
			createGrid();
			
			createOptionsPanel();
			createActionsPanel();
			
			//Add preview shape
			addChild(assetImage = new Shape());

			//Add help instructions
			setInstructions();
			
			modeText = new TextField;
			modeText.background = true;
			modeText.border = true;
			modeText.selectable = false;
			modeText.x = 5;
			modeText.y = 5;
			modeText.height = 16;
			modeText.width = 630;
			addChild(modeText);

			//textField.type = TextFieldType.INPUT;
            //textField.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
		}
		
		private function setInstructions():void{
			helpText = new TextField();
			helpText.selectable = false;
			helpText.width = 448;
            helpText.height = 400;
            helpText.x = (640-helpText.width)/2;
			helpText.y = (480-helpText.height)/2;
            helpText.background = true;
            helpText.border = true;
            helpText.text = "";
            helpText.appendText("Movement:\n");
            helpText.appendText(" WASD - moves player object to simulate scrolling\n");
            helpText.appendText("\n");
            helpText.appendText("Keyboard Shortcuts:\n");
            helpText.appendText(" [ and ] - shifts through image assets\n");
            helpText.appendText(" E - toggles ADD/REMOVE mode\n");
            helpText.appendText(" 1 and 2 - sets the START/END point for ADD mode\n");
			helpText.appendText(" I - toggles ACTIVE/STATIC flag when ADDING objects\n");
			helpText.appendText(" G - toggles GRID\n");
			helpText.appendText(" N - toggles FREE/SNAP to grid\n");
			helpText.appendText(" H - toggles HUD/STATUS panel\n");
			helpText.appendText("\n");
			helpText.appendText(" J - sets the JOIN mode.  SHIFT DRAG on static to active, active to active object\n");
			helpText.appendText(" T - Distance joints require two bodies.\n");
			helpText.appendText(" R - Revolute joints can be SHIFT DRAG in one body, so it connects to world.\n");
			helpText.appendText(" Y - Prismatic joints axis is the midpoint of the mouse distance.\n");
			helpText.appendText("\n");
			helpText.appendText(" SHIFT - hides TOOLBAR panel\n");
			helpText.appendText(" U - toggles DEBUG PHYSICS bodies for joints and bounding box issues\n");
			helpText.appendText(" F1 - toggles simulation.\n");
			helpText.appendText(" SHIFT CLICK - ADD/REMOVE the selected image asset at MOUSE coordinates\n");
			helpText.appendText("\n");
			helpText.appendText("Buttons:\n");
			helpText.appendText(" CHANGE BUTTON - sets the ACTIVE/STATIC flag of created objects with SHIFT CLICK\n");
			helpText.appendText(" ADD BUTTON - sets the ADD mode.  SHIFT CLICK to add objects\n");
			helpText.appendText(" REMOVE BUTTON - sets the REMOVE mode.  SHIFT CLICK to remove objects\n");
			helpText.appendText(" JOIN BUTTON - sets the JOIN mode.  SHIFT CLICK on one body and drag to another\n");
			helpText.appendText(" BREAK BUTTON - sets the BREAK mode.  SHIFT CLICK on a body to remove all joints\n");
			helpText.appendText(" COPY BUTTON - copies level settings.  You paste from clipboard to new file\n");
			helpText.appendText(" RUN BUTTON - toggles simulation.\n");
			helpText.appendText("\n");
			helpText.appendText("QUIT:\n");
			helpText.appendText(" SHIFT ESC - QUIT to the level select menu\n");
			helpText.visible = false;
            //helpText.addEventListener(MouseEvent.MOUSE_DOWN, onTextClick);
            
            addChild(helpText);
		}
		
		private function onTextClick(event:MouseEvent):void{
			helpText.visible = false;
		}
		
		public function textInputHandler(event:TextEvent):void
        {
           textValue = event.text;
           
           //Reset the keyboard to not pick up the key presses
           FlxG.keys.reset();
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
		
		private function setPreviewImg(imgFile:String):void{
			trace(imgFile);
			trace(imgFile.lastIndexOf(".xml"));
			if(imgFile.lastIndexOf(".xml") >= 0){
				//var bitmapData:BitmapData = (new boxImg).bitmapData;
			 	assetImage.graphics.clear();
			 	//assetImage.graphics.beginBitmapFill(bitmapData);
			 	//assetImage.graphics.drawRect(0,0,bitmapData.width,bitmapData.height);
			 	//assetImage.graphics.endFill();
				return;
			}
			
			var loader:Loader = new Loader();
    		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSetPreviewComplete);
    		loader.load(new URLRequest(imgFile));
		}
		
		private function onSetPreviewComplete(event:Event):void{
			 var bitmapData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			 assetImage.graphics.clear();
			 assetImage.graphics.beginBitmapFill(bitmapData);
			 assetImage.graphics.drawRect(0,0,bitmapData.width,bitmapData.height);
			 assetImage.graphics.endFill();
		}
		
		private function copy(text:String):void{
            System.setClipboard(text);
        }

		override public function update():void
		{
			if(!_loaded){
				return;
			}
			
			//Put objects to sleep before it can do it's update if we aren't in run mode...
			updateWorldObjects();
			
			super.update();
			
			//Grid
			grid.x = FlxG.scroll.x;
			grid.y = FlxG.scroll.y;
			
			handleKeyboard();
			handlePreview();
			handleMode();
			handleMouse();
			
			/*
			//Commented out because some joints do not use the anchors the way regular distance joints do...
			//If we want to add joints drawing...
			if(jointsImage.visible){
				jointsImage.graphics.clear();
				jointsImage.x = FlxG.scroll.x;
				jointsImage.y = FlxG.scroll.y;
				jointsImage.graphics.lineStyle(2, 0x00FF00,1);
				
				for (var j:b2Joint=the_world.GetJointList(); j; j=j.GetNext()) {
					jointsImage.graphics.moveTo(j.GetAnchor1().x,j.GetAnchor1().y);
					jointsImage.graphics.lineTo(j.GetAnchor2().x,j.GetAnchor2().y);
				}
			}	
			*/
		}
		
		private function handleKeyboard():void{
			if(FlxG.keys.pressed("SHIFT") && FlxG.keys.justPressed("ESC")) {
				FlxG.switchState(LevelSelectMenu);
			}
			
			if(FlxG.keys.justPressed("E")){ 
				mode = mode != EDIT ? EDIT : KILL;
			}
			
			if(FlxG.keys.justPressed("J")){
				mode = mode != JOIN ? JOIN : BREAK;
			}
			
			if(FlxG.keys.justPressed("I")){
				active = !active;
			}
			
			actionsPanel.visible = !FlxG.keys.SHIFT;
			optionsPanel.visible = !FlxG.keys.SHIFT;
			
			if(FlxG.keys.justPressed("H")){
				modeText.visible = !modeText.visible;
			}
			
			if(FlxG.keys.justPressed("G")){
				grid.visible = !grid.visible;
			}
			
			if(FlxG.keys.justPressed("N")){
				snapToGrid = !snapToGrid;
			}
			
			if(FlxG.keys.justPressed("U")){
				debug_sprite.visible = !debug_sprite.visible;
			}
			
			if(FlxG.keys.justPressed("R")){
				jointType = Utilities.e_revoluteJoint;
			}
			if(FlxG.keys.justPressed("T")){
				jointType = Utilities.e_distanceJoint;
			}
			if(FlxG.keys.justPressed("Y")){
				jointType = Utilities.e_prismaticJoint;
			}
			
			if(FlxG.keys.justPressed("F1")){
				run = !run;
			}
		}
		
		private function handlePreview():void{
			lastIndex = index;
			if(FlxG.keys.justPressed("LBRACKET")) {
				index--;
			}
			if(FlxG.keys.justPressed("RBRACKET")){
				index++;
			}
			
			if(FlxG.keys.justPressed("ONE")){
				index = 0;
			}
				
			if(FlxG.keys.justPressed("TWO")){
				index = 1;
			}
			
			
			if(index >= files.length) 
				index = files.length - 1;
			if(index < 0) 
				index = 0;
			
			if(lastIndex != index)
				setPreviewImg(files[index]);
				
			
			if(FlxG.keys.justPressed("Z")){
				layer = 0;
			}
			
			if(FlxG.keys.justPressed("X")){
				layer = 1;
			}
		}
		
		private function handleMode():void{
			debugButton.alpha = debug_sprite.visible ? 1 : .5;
			activeButton.alpha = active ? 1 : .5;
			snapButton.alpha = snapToGrid ? 1 : .5;
			gridButton.alpha = grid.visible ? 1 : .5;
			joinButton.alpha = mode == JOIN ? 1 : .5;
			breakButton.alpha = mode == BREAK ? 1 : .5;
			killButton.alpha = mode == KILL ? 1 : .5;
			playButton.alpha = run ? 1 : .5;
			editButton.alpha = mode == EDIT ? 1 : .5;
			helpButton.alpha = helpText.visible ? 1 : .5;
			changeButton.alpha = mode == CHANGE ? 1 : .5;
			
			jointsImage.visible = (mode == JOIN || mode == BREAK);
			
			var actions:Array = ["REMOVE", "ADD", "JOIN", "BREAK", "CHANGE"];
			var action:String = actions[mode];
			var mouseCoord:String =  "(" + FlxG.mouse.x + ", " + FlxG.mouse.y +")";
			var itemCount:String = "# Items: " + xmlMapLoader.getItemCount();
			
			//From Utilities
			var jointTypes:Array = ["UNKNOWN", "REVOLUTE", "PRISMATIC", "DISTANCE", "PULLEY", "MOUSE", "GEAR", "LINE"];
			
			var layerTypes:Array = ["BACKGROUND", "FOREGROUND"];
			
			var status:Array = [
				itemCount,
				action,
				active ? "ACTIVE" : "STATIC",
				snapToGrid ? "SNAP" : "FREE",
				"JOINT: " + jointTypes[jointType],
				"LAYER: " + layerTypes[layer],
				mouseCoord];
			
			modeText.text = status.join(" | ");
			statusText.text = "FILE: " + files[index];
		}
		
		private function handleMouse():void{
			var point:Point = new Point();
			point.x = FlxG.mouse.x;
			point.y = FlxG.mouse.y;
			
			assetImage.x = FlxG.mouse.x+FlxG.scroll.x;
			assetImage.y = FlxG.mouse.y+FlxG.scroll.y;
				
			if(snapToGrid){
				point.x -= point.x % 16;
				point.y -= point.y % 16;
				
				assetImage.x -= (FlxG.mouse.x % 16);
				assetImage.y -= (FlxG.mouse.y % 16);
			}
			
			assetImage.visible = mode == EDIT;
			assetImage.alpha = active ? .8 : .3;
			
			if(FlxG.keys.SHIFT){
				assetImage.alpha = 1;
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
				else if(mode == CHANGE){
					var type:String = active ? "active" : "static";
					xmlMapLoader.setObjectTypeAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true, type);
				}
				/*
				else if(mode == DRAW){
					//Drawbox...
					startPoint.x = point.x;
					startPoint.y = point.y;
					
					drawingBox = true;
				}
				*/
				else if(mode == JOIN){
					xmlMapLoader.registerObjectAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true);
					
					//Draw with snapping.....
					//startPoint.x = point.x;
					//startPoint.y = point.y;
					
					//I don't like snap
					startPoint.x = FlxG.mouse.x;
					startPoint.y = FlxG.mouse.y;
					drawingLine = true;
				}
				else if(mode == BREAK){
					xmlMapLoader.removeJointAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true);
				}
			}
			
			if(mode == JOIN && drawingLine){
				line.graphics.clear();
				line.graphics.lineStyle(1,0xFF0000,1);
				line.graphics.moveTo(startPoint.x,startPoint.y);
				line.graphics.lineTo(FlxG.mouse.x, FlxG.mouse.y);//point.x, point.y);
				line.visible = true;
			}
			
			//Allows for the scrolling to work...
			line.x = FlxG.scroll.x;
			line.y = FlxG.scroll.y;
				
			
			//I am starting to hate using FlixelSprites.....
			/*
			if(mode == DRAW && drawingBox){
				var width:int = point.x - startPoint.x;
				var height:int = point.y - startPoint.y;
				
				box.x = startPoint.x;
				box.y = startPoint.y;
				if(width < 0){
					box.x = point.x;
					width = -width;
				}
				if(height < 0){
					box.y = point.y;
					height = -height;
				}
				
				box.createGraphic(width, height, 0xff000000);	
			}
			*/
			
			if(FlxG.mouse.justReleased()){
				/*if(mode == DRAW && drawingBox){
					drawingBox = false;
					
					//We can do things like, make a shape that fills... or try physics stuff...
				}*/
				
				if(mode == JOIN && drawingLine){
					line.visible = false;
					drawingLine = false;
					xmlMapLoader.registerObjectAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true);
					
					xmlMapLoader.addJoint(jointType);
				}
			}
		}
		
		private function updateWorldObjects():void{
			var bb:b2Body;
			if(run){
				the_world.SetGravity(new b2Vec2(0,80));
				
				for (bb = the_world.GetBodyList(); bb; bb = bb.GetNext()) {
					bb.WakeUp();
				}
			}
			else{
				the_world.SetGravity(new b2Vec2(0,0));
				for (bb = the_world.GetBodyList(); bb; bb = bb.GetNext()) {
					if(bb.GetUserData() && bb.GetUserData().name == "Player")
						continue;
					 bb.PutToSleep();
				}
			}
		}
		
		private function addObject(point:Point):void{
			
			var file:String = files[index] as String;
			
			if(file.lastIndexOf(".xml") >= 0){
				xmlMapLoader.addObjectsInXMLFile(file, point);
			}
			else{
				var shape:XML = new XML(<shape/>);
				shape.file = files[index];
				shape.isStatic = !active;
				shape.angle = 0;
				shape.x = point.x;
				shape.y = point.y;
				shape.contour = "";
				xmlMapLoader.addXMLObject(shape, true);
			}
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