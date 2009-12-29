package PhysicsLab
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
		
		private var active:Boolean;
		private var usePoly:Boolean;
		private var run:Boolean;
		private var addJoint:Boolean;

		private var previewImg:Shape;
		private var box:FlxSprite;
		private var drawingBox:Boolean;
		private var line:Shape;
		private var drawingLine:Boolean;
		private var startPoint:Point;
		
		private var snapToGrid:Boolean;
		
		private var startImg:FlxSprite;
		private var endImg:FlxSprite;
		
		private var statusPanel:FlxLayer;
		private var grid:FlxSprite;
		private var toolPanel:FlxLayer;
		private var textField:FlxText;
		private var mode:uint;
		
		private const BLACK:Number = 0xFF000000;
		private const WHITE:Number = 0xFFFFFFFF;
		private const RED:Number = 0xFFFF0000;
		
		private const KILL:uint = 0;
		private const EDIT:uint = 1;
		private const DRAW:uint = 2;
		private const JOINT:uint = 3;
		private const BREAK:uint = 4;

		private const WIDTH:uint = 1280;
		private const HEIGHT:uint = 960;
		
		public function PhysLevelEditor() 
		{
			super();
			bgColor = 0xffeeeeff;
			the_world.SetGravity(new b2Vec2(0,0));
			
			debug = true;
			initBox2DDebugRendering();
			
			FlxG.showCursor(cursorSprite);
			
			_loaded = false;
			files = new Array();
			active = false;
			snapToGrid = true;
			drawingBox = false;
			drawingLine = false;
			usePoly = false;
			run = false;
			
			startImg = new FlxSprite(0,0,startSprite);
			endImg = new FlxSprite(0,0,endSprite);
			
			box = new FlxSprite(0,0);
			add(box);
			startPoint = new Point();
			
			line = new Shape();
			addChild(line);
			
			add(startImg);
			add(endImg);
			
			loadLevelConfig();
			addPlayer();
			loadAssetList("data/LevelEditor.txt");
			setInstructions();
			
			setHUD();
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
				debug_draw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_jointBit);
				the_world.SetDebugDraw(debug_draw);
			}
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
			FlxG.followBounds(0,0,WIDTH,HEIGHT);
		}
		
		private function setupGrid():void{
			var gridShape:Shape = new Shape();
			gridShape.x = 0;
			gridShape.y = 0;
			
			for(var x:Number = 0; x <= WIDTH; x += 4){
				gridShape.graphics.lineStyle(1,BLACK,x%16==0 ? .5 : .2);
				gridShape.graphics.moveTo(x,0);
				gridShape.graphics.lineTo(x,HEIGHT);
			}
			
			for(var y:Number = 0; y <= HEIGHT; y += 4){
				gridShape.graphics.lineStyle(1,BLACK,y%16==0 ? .5 : .2);
				gridShape.graphics.moveTo(0,y);
				gridShape.graphics.lineTo(WIDTH,y);
			}
			
			//You want this grid to scroll so don't set scroll factor
			grid = new FlxSprite(0,0);
			grid.createGraphic(WIDTH, HEIGHT,0xffffffff);
			//grid.scrollFactor.x = 0;
			//grid.scrollFactor.y = 0;
			
			//Cool, this is how you convert a sprite shape into a bitmap
			var bmd:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0x00FFFFFF );
            bmd.draw(gridShape);
            grid.pixels = bmd;
            
            add(grid);
		}
		
		private function setHUD():void{
			addChild(previewImg = new Shape());

			setupGrid();
				
			textField = new FlxText(0,0,640, "");
			textField.color = WHITE;
			textField.scrollFactor.x = 0;
			textField.scrollFactor.y = 0;
			
			//Setup the status panel
			statusPanel = new FlxLayer();
			var statusBackground:FlxSprite = new FlxSprite(0,0);
			statusBackground.createGraphic(640,12,BLACK);
			statusBackground.scrollFactor.x = 0;
			statusBackground.scrollFactor.y = 0;
			statusBackground.x = 0;
			statusBackground.y = 0;
			statusPanel.add(statusBackground);
			statusPanel.add(textField);
			add(statusPanel);
			
			
			var actions:Array = [onSetKill, onSetEdit, onSetCopy, onDrawBox, onAddJoint, onBreakJoint]
			toolPanel = new FlxLayer();
			//toolPanel.add(grid);
				
			var panelBackground:FlxSprite = new FlxSprite(0,0);
			panelBackground.createGraphic(50,220,0xff000000);
			panelBackground.scrollFactor.x = 0;
			panelBackground.scrollFactor.y = 0;
			panelBackground.x = 2;
			panelBackground.y = 25;
			toolPanel.add(panelBackground);
			toolPanel.add(addButton(5,30,"KILL",actions[0]));
			toolPanel.add(addButton(5,60,"EDIT",actions[1]));
			toolPanel.add(addButton(5,90,"COPY",actions[2]));
			toolPanel.add(addButton(5,120,"PHYS",actions[3]));
			toolPanel.add(addButton(5,150,"JOINT",actions[4]));
			toolPanel.add(addButton(5,180,"BREAK",actions[5]));
			
			//toolPanel.add(textField);
			add(toolPanel);
			
		}
		
		private function onSetKill():void{
			mode = KILL;
		}
		
		private function onSetEdit():void{
			mode = EDIT;
		}
		
		private function onSetCopy():void{
			copy(xmlMapLoader.getConfiguration());
		}
		
		private function onDrawBox():void{
			mode = DRAW;
		}
		
		private function onAddJoint():void{
			mode = JOINT;
		}
		
		private function onBreakJoint():void{
			mode = BREAK;
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
			FlxG.log("1 and 2 sets the graphics for start/end point");
			FlxG.log("WASD move player object simulate scrolling");
			FlxG.log("E toggles EDIT/KILL mode (mouse click to add new shape)");
			FlxG.log("I toggles ACTIVE/STATIC flag on body creation");
			FlxG.log("Z removes last ADD");
			FlxG.log("G toggles GRID");
			FlxG.log("H toggles HUD/STATUS panel");
			FlxG.log("T toggles TOOLBAR panel");
			FlxG.log("R toggles RUN");
			FlxG.log("N toggles FREE/SNAP to grid");
			FlxG.log("U toggles DEBUG PHYSICS bodies.  Let's you see if your shape has edge transparency issues");
			FlxG.log("B toggles POLY/BOX - NOTE: Everything renders based on poly now.  THERE IS NO BOX");
			FlxG.log("SHIFT CLICK will add/kill the selected shape at mouse coordinates");
			FlxG.log("COPY BUTTON to copy the new config settings to clipboard");
			FlxG.log("KILL BUTTON to remove objects from game");
			FlxG.log("EDIT BUTTON to add objects from game");
			FlxG.log("PHYS BUTTON to draw a pointless box...");
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
			
			if(FlxG.keys.justPressed("T")){
				toolPanel.visible = !toolPanel.visible;
			}
			
			if(FlxG.keys.justPressed("H")){
				statusPanel.visible = !statusPanel.visible;
			}
			
			if(FlxG.keys.justPressed("G")){
				grid.visible = !grid.visible;
			}
			
			if(FlxG.keys.justPressed("N")){
				snapToGrid = !snapToGrid;
			}
			
			if(FlxG.keys.justPressed("B")){
				usePoly = !usePoly;
			}
			
			if(FlxG.keys.justPressed("U")){
				debug_sprite.visible = !debug_sprite.visible;
			}
			
			if(FlxG.keys.justPressed("R")){
				run = !run;
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
			
			//For the physics....
			debug_sprite.x = FlxG.scroll.x;
			debug_sprite.y = FlxG.scroll.y;
			
			
			handlePreview();
			handleMode();
			handleMouse();
			
		}
		
        override public function render():void{
        	super.render();
        	/*
        	if(toolPanel && toolPanel.visible){
        		toolPanel.render();
        	}
        	if(statusPanel && statusPanel.visible){
        		statusPanel.render();
        	}*/
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
				
			var actions:Array = ["KILL", "EDIT", "DRAW", "JOINT"];
			var action:String = actions[mode];
			var inact:String = active ? "ACTIVE" : "STATIC";
			var snap:String = snapToGrid ? "SNAP" : "FREE";
			var poly:String = usePoly ? "POLY" : "BOX";
			
			var running:String = run ? "RUN" : "STOP";
			var mouseCoord:String =  "(" + FlxG.mouse.x + "," + FlxG.mouse.y +")";
			var status:Array = [action, inact, snap, poly, running, "FILE: " + files[index], mouseCoord, xmlMapLoader.getItemCount()];
			textField.text = status.join(" | ");
		}
		
		private function handleMouse():void{
			var point:Point = new Point();
			point.x = FlxG.mouse.x;
			point.y = FlxG.mouse.y;
			
			previewImg.x = FlxG.mouse.x+FlxG.scroll.x;
			previewImg.y = FlxG.mouse.y+FlxG.scroll.y;
				
			if(snapToGrid){
				point.x -= point.x % 16;
				point.y -= point.y % 16;
				
				previewImg.x -= (FlxG.mouse.x % 16);
				previewImg.y -= (FlxG.mouse.y % 16);
			}
			
			previewImg.visible = mode == EDIT;
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
				else if(mode == DRAW){
					//Drawbox...
					startPoint.x = point.x;
					startPoint.y = point.y;
					
					drawingBox = true;
				}
				else if(mode == JOINT){
					xmlMapLoader.registerObjectAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true);
					
					//Drawbox...
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
			
			if(mode == JOINT && drawingLine){
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
			
			if(FlxG.mouse.justReleased()){
				if(mode == DRAW && drawingBox){
					drawingBox = false;
					
					//We can do things like, make a shape that fills... or try physics stuff...
				}
				
				if(mode == JOINT && drawingLine){
					line.visible = false;
					drawingLine = false;
					xmlMapLoader.registerObjectAtPoint(new Point(FlxG.mouse.x, FlxG.mouse.y),true);
					xmlMapLoader.addJoint();
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