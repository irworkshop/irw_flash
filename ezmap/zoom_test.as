﻿// Make a sprite moveable// Approach taken from here: http://mc-computing.com/Languages/ActionScript/Mouse_Drag.htmlpackage{	import flash.display.Sprite;	import flash.display.Graphics;		import flash.display.StageAlign;	import flash.display.StageScaleMode;		import flash.ui.Mouse;		import flash.events.*;		import fl.controls.Label;	import fl.controls.Slider;	import fl.events.SliderEvent;	import fl.controls.SliderDirection;		import org.fenton.tooltips.Rollover;	// dVyper's handy alert class	import com.dVyper.utils.Alert;		[SWF(width="550",height="400", frameRate="30", backgroundColor="0xFFFFFF")]		public class zoom_test extends Sprite{	// These must be the same as set above!	var stagewidth:int = 550;	var stageheight:int = 400;		var curzoomlevel:int = 1;	var s2: Sprite = new Sprite();	var g2: Graphics = s2.graphics;	var Mouse_x:int;	var Mouse_y:int;	var Drag_Flag:Boolean = false;		// This is the constructor		public function zoom_test() {		init();	}			private function init():void {			Alert.init(stage);		//Alert.show("Swf loaded", {buttons:["OK"]});		 Mouse.cursor="hand";		//g2.lineStyle(3,0x00ff00);		//g2.drawRect(0,0,550,390);		//g2.endFill();				// draw some circles		Circle(g2,100, 150, 10, 0xFF0000, 0.3, 1, 0x666666, 0.4, 1); 		Circle(g2,200, 175, 30, 0x00FF00, 0.9, 1, 0x000000, 0.8, 1);		Circle(g2,10, 400, 24, 0xFFFF00, 0.9, 1, 0x000000, 0.8, 1);		Circle(g2,50, 67, 20, 0x00FF00, 0.9, 1, 0x000000, 0.8, 1);		Circle(g2,300, 17, 30, 0x00FF00, 0.9, 1, 0x000000, 0.8, 1);			Circle(g2,275, 200, 30, 0x0000FF, 0.9, 1, 0xFF0000, 0.8, 1);										addChild(s2);			// label for slider							var slidersprite = new Sprite();				slidersprite.graphics.lineStyle(3,0x666666);		slidersprite.graphics.beginFill(0xFFFFFF, 1);				slidersprite.graphics.drawRect(0,0,50,120);		slidersprite.graphics.endFill();				var myLabel:Label = new Label();		//myLabel.autoSize = TextFieldAutoSize.LEFT;		myLabel.text = "some text";		myLabel.x=5;		myLabel.y=5;		slidersprite.addChild(myLabel);						var s:Slider = new Slider();		//mySlider.addEventListener(SliderEvent.THUMB_DRAG, thumbDragHandler);				s.snapInterval = 1; 		s.tickInterval = 1; 		s.maximum = 4; 		s.minimum = 1		s.value = 1; 		s.x = 25;		s.y = 15						//s.move(myLabel.x, myLabel.y + myLabel.height);		slidersprite.addChild(s);			s.direction = SliderDirection.VERTICAL;				// Ignore mouse clicks 		slidersprite.addEventListener(MouseEvent.MOUSE_DOWN,onStopPropDown,false, 0, true);		slidersprite.addEventListener(MouseEvent.MOUSE_UP,onStopPropDown,false, 0, true);						slidersprite.x = 10;		slidersprite.y = 10;		addChild(slidersprite);		s.addEventListener(SliderEvent.CHANGE, announceChange);			// listeners for draggability		stage.addEventListener(MouseEvent.MOUSE_DOWN,pickup)		stage.addEventListener(MouseEvent.MOUSE_UP,  dropit)				}//Begin Event Listener Function for pickUp         	 			function pickup(e:Event):void{		 s2.startDrag();		 Mouse.cursor="arrow";		 trace("start drag");		 }		 //End pickUp function                 		 //Begin Event Listener Function for dropIt         		function dropit(e:Event):void{			s2.stopDrag();			 Mouse.cursor="hand";			trace("stop drag");			}		//End dropIt function 	function onStopPropDown(evt:MouseEvent):void {    //output.text = "stopProp down";    	evt.stopPropagation();	}				function announceChange(e:SliderEvent):void {		var newzoom:int = e.target.value    			// size of s2 sprite to begin with		var initial_width:int = stagewidth * curzoomlevel;		var initial_height:int = stageheight * curzoomlevel; 				//The current center in sprite coordinates		var curcenterx:Number = stagewidth/2 - s2.x;		var curcentery:Number = stageheight/2 -s2.y;				// The relative position of the center		var relativecenterx:Number = curcenterx / initial_width;		var relativecentery:Number = curcentery / initial_height;				//Now reset the zoom level:				curzoomlevel=newzoom;		// Scale the sprite to fit		s2.scaleX = s2.scaleY = curzoomlevel;				// New dimensions		var final_width:int = stagewidth * curzoomlevel;		var final_height:int = stageheight * curzoomlevel;				// Calculate the center in terms of the zoomed sprite			var finalx:Number = relativecenterx * final_width;		var finaly:Number = relativecentery * final_height;				// Now calculate the new offsets		var finaloffsetx:Number = stagewidth/2 - finalx;		var finaloffsety:Number = stageheight/2 - finaly;				s2.x = finaloffsetx;		s2.y = finaloffsety;			}		function Circle(g:Graphics, center_x:Number, center_y:Number, radius:int, fillcolor:uint, fillalpha:Number, outlinewidth:int, outlinecolor:uint, outlinealpha: Number, zoom:Number) {			g.lineStyle(zoom*outlinewidth, outlinecolor, outlinealpha);		g.beginFill(fillcolor, fillalpha);		g.drawCircle(zoom*center_x, zoom*center_y, zoom*radius);		g.endFill();	}	} // end class} // end package		