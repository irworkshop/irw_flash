﻿/* ***********************************************************************Adapted from: ActionScript 3 Tutorial by Barbara Kaskoszwww.flashandmath.comSubstantially hacked up by Jacob Fenton************************************************************************ */package org.fenton.sliders {	    import flash.display.Sprite;	import flash.display.Shape;    import flash.events.*;	//import flash.display.InteractiveObject.middleClick	import flash.geom.Rectangle;	    import flash.filters.BitmapFilter;    import flash.filters.BitmapFilterQuality;    import flash.filters.GlowFilter;	import flash.filters.DropShadowFilter;	import flash.filters.BlurFilter;	import flash.display.Bitmap;		import flash.text.TextFormat;	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.text.TextFieldAutoSize;	import flash.text.Font;	import flash.text.AntiAliasType;		     public class DiscreteHorizontalSlider extends Sprite {	  	public static const SLIDER_CHANGE:String = "sliderChange";		protected var nLength:Number;	protected var nInnerLength:Number;	protected var shTrack:Shape;	protected var spKnob:Sprite;	protected var clickSprite:Sprite;	protected var clickSpriteColor:uint;		protected var nKnobColor:uint;	protected var nKnobOpacity:Number;	protected var nKnobWidth:Number;	protected var nKnobHeight:Number;	protected var nNumTics:int;	protected var sStyle:String;	protected var rBounds:Rectangle;	protected var _isPressed:Boolean;	protected var _isOver:Boolean;	protected var TicColor:uint;	protected var minorTicHeight:int;	protected var majorTicHeight:int;	protected var majorTicInterval:int;	protected var TicOffset:int; 	protected var TicLineWidth:int;	protected var TicMinimum:int;	private var label_height:int; 	private var label_width:int;	private var labelTextOffset:int;		private var label_format:TextFormat;		private var header_format:TextFormat;		protected var KnobOffset_y:int;	protected var TrackOffset_x:int;	protected var TrackOffset_y:int;	protected var TrackHeight:int;		//	private var normalKnob:Sprite;	private var mouseoverKnob:Sprite;	private var draggingKnob:Sprite;	private var dragMoveNotify:Boolean;			protected var prevX:Number;	protected var prevKnobLocation:int;	protected var knobstartX:Number;		private var tic_x:Array = new Array();	public var knobLocation:int;						// if we're assigning the controls from images do it like this:	//[Embed(source='img/slider_knob_up.png')]	//private var normalSliderImg:Class;	//private var sliderImg1:Bitmap = new normalSliderImg ();		[Embed(source='img/thirtyx20.png')]	private var sliderKnobImg:Class;	private var sliderImg1:Bitmap = new sliderKnobImg ();	private var sliderImg2:Bitmap = new sliderKnobImg ();			[Embed(source='img/thirtyx20_up.png')]	private var sliderKnobImg2:Class;		private var sliderImg3:Bitmap = new sliderKnobImg2 ();			public function DiscreteHorizontalSlider(len:Number, numtics:int, ticminimum:int, dragMoveNotify:Boolean = false){					this.nNumTics = numtics;		this.dragMoveNotify = dragMoveNotify;		this.nLength=len;		this.label_height = 18; 		this.label_width = 36;		this.labelTextOffset = 0;				this.TicMinimum = ticminimum;		this.TicColor = 0x666666;			this.minorTicHeight = 3;		this.majorTicHeight = 6;		this.majorTicInterval = 5; 		this.TicLineWidth = 1;		this.TicOffset = 7;				this.clickSpriteColor = 0xEEEEEE;		this.nKnobWidth=30;		this.nKnobHeight = 20;				this.KnobOffset_y = label_height + majorTicHeight + 3;		this.TrackOffset_y = KnobOffset_y ;		this.TrackHeight = 20;					this.nInnerLength = len - 2*TrackOffset_x;				this._isPressed=false;		this._isOver=false;				label_format = new TextFormat();		label_format.align = "left";		label_format.font = "Arial";		label_format.bold = true;		label_format.color = 0x000000;		label_format.size = 14;				clickSprite = new Sprite();		this.addChild(clickSprite);				shTrack=new Shape();		this.addChild(shTrack);		spKnob=new Sprite();		spKnob.y = KnobOffset_y;		spKnob.x = TrackOffset_x;		this.addChild(spKnob);		init_sprites();		init_tic_intervals();		drawSlider();		activateSlider();		setKnobPos(TicMinimum + nNumTics);					}		private function init_sprites():void {				normalKnob = new Sprite();		draggingKnob= new Sprite();		mouseoverKnob= new Sprite();				var glowFilter1:BitmapFilter = getBitmapFilter(0xF9A01B);		//var glowFilter2:BitmapFilter = getBitmapFilter(0xC44149);				//normalKnob.graphics.lineStyle(1,0x999999);				//normalKnob.graphics.beginFill(0x669CB5,1);		//normalKnob.graphics.drawRoundRect(0, 5, nKnobWidth, nKnobHeight-5, 3);								//normalKnob.graphics.endFill();		normalKnob.mouseEnabled = false;				sliderImg1.height = 20;		sliderImg1.width = 30;		normalKnob.addChild(sliderImg1);			//var blurred:BlurFilter = new BlurFilter(2, 2, 1);		//normalKnob.filters = [blurred];				//mouseoverKnob.graphics.lineStyle(1,0x999999);				//mouseoverKnob.graphics.beginFill(0x669CB5,0.4);		//mouseoverKnob.graphics.drawRoundRect(0, 5, nKnobWidth, nKnobHeight-5, 3);		mouseoverKnob.mouseEnabled = false;				mouseoverKnob.filters = [glowFilter1];		sliderImg2.height = 20;		sliderImg2.width = 30;		mouseoverKnob.addChild(sliderImg2);			mouseoverKnob.filters = [glowFilter1];				//draggingKnob.graphics.lineStyle(1,0x999999);				//draggingKnob.graphics.beginFill(0x337B9D,1);		//draggingKnob.graphics.drawRoundRect(0, 5, nKnobWidth, nKnobHeight-5, 3);		draggingKnob.mouseEnabled = false;				draggingKnob.filters = [glowFilter1];								sliderImg3.height=20;		sliderImg3.width=30;		draggingKnob.addChild(sliderImg3);		draggingKnob.filters = [glowFilter1];				clickSprite.graphics.beginFill(clickSpriteColor,1);		clickSprite.graphics.drawRect(0,0, nLength + nKnobWidth, TrackHeight);		clickSprite.graphics.endFill();				clickSprite.x = TrackOffset_x;		clickSprite.y = TrackOffset_y;			}		protected function init_tic_intervals():void {			// draw smaller intermediate tics		for (var i:int = 0; i<= nNumTics; i++) {			var tic_location:Number =  i*nInnerLength/nNumTics;			tic_x[i] = tic_location;			//trace(String(i) + " : " + String(tic_location));					}	}		// Returns the index, in the tic_x array, of the tic height. 	private function get_tic_index(current_x:Number):int {		var new_tic_index:int =  int(Math.round(nNumTics*(current_x-nKnobWidth/2)/nInnerLength));		//trace("Mapped " + String(current_x) + " to: " + String(new_tic_index));		if (new_tic_index < 0) {			new_tic_index=0;		}		return new_tic_index;			}			protected function drawSlider():void {				shTrack.graphics.clear();		spKnob.graphics.clear();					shTrack.graphics.lineStyle(TicLineWidth,TicColor);		// draw  tics		for (var i:int = 0; i<= nNumTics; i++) {			var slidervalue:int = i + TicMinimum;			shTrack.graphics.moveTo(TrackOffset_x + nKnobWidth/2 + i*nInnerLength/nNumTics, TrackOffset_y-TicOffset);			if ( slidervalue % majorTicInterval == 0 || slidervalue == 1981 || slidervalue == 2009) {				shTrack.graphics.lineTo(TrackOffset_x + nKnobWidth/2 + i*nInnerLength/nNumTics, TrackOffset_y-TicOffset - majorTicHeight);				drawTicLabel(String(slidervalue), TrackOffset_x + nKnobWidth/2 + i*nInnerLength/nNumTics);			} else {				shTrack.graphics.lineTo(TrackOffset_x + nKnobWidth/2 + i*nInnerLength/nNumTics, TrackOffset_y-TicOffset - minorTicHeight);			}		}		// set up spKnob. This will listen to events underneath the displayed sliders.		spKnob.graphics.beginFill(0xFF0000,0);		spKnob.graphics.drawRoundRect(0, 5, nKnobWidth, nKnobHeight-5, 3);		spKnob.graphics.endFill();				var shadow:DropShadowFilter = new DropShadowFilter(); 		shadow.distance = 3; 		shadow.angle = 45; 		shadow.alpha = 0.5;				spKnob.filters=[shadow];								spKnob.addChild(normalKnob);		spKnob.x = TrackOffset_x;				clickSprite			}		private function drawTicLabel(labelText:String, label_x:int) {		var this_label:TextField = new TextField();		//myLabel.autoSize = TextFieldAutoSize.LEFT;		this_label.text = labelText;		this_label.y=labelTextOffset;		this_label.x=label_x - label_width/2;		this_label.width=label_width;		this_label.height = label_height;				this_label.setTextFormat(label_format);		this.addChild(this_label);					}		protected function activateSlider(): void {		spKnob.addEventListener(MouseEvent.MOUSE_DOWN,downKnob, false, 0, true);		spKnob.addEventListener(MouseEvent.MOUSE_UP,upKnob, false, 0, true);		spKnob.addEventListener(MouseEvent.ROLL_OVER, knobMouseover, false, 0, true);		spKnob.addEventListener(MouseEvent.ROLL_OUT, knobMouseout, false, 0, true);					clickSprite.addEventListener(MouseEvent.MOUSE_DOWN, sliderClick, false, 0, true);		clickSprite.addEventListener(MouseEvent.ROLL_OVER, knobMouseover, false, 0, true);		clickSprite.addEventListener(MouseEvent.ROLL_OUT, knobMouseout, false, 0, true);							}		protected function sliderClick(e:MouseEvent): void {		var newX:int = e.localX;		//trace("slider clicked: " + String(newY));	  	var newKnobLocation:int; 	  		if ( newX < 0 ) {  			newKnobLocation = 0;		  	  	} else if (newX > nInnerLength) {		  	newKnobLocation = nNumTics;	  	} else {		  	//spKnob.y = newY;		  	newKnobLocation = get_tic_index(newX);	  	}	  	  	if (newKnobLocation != knobLocation) {			spKnob.x = tic_x[newKnobLocation];			knobLocation = newKnobLocation;			//trace("Index changed to: " + String(newKnobLocation));			dispatchEvent(new Event(DiscreteHorizontalSlider.SLIDER_CHANGE));		}			}		protected function knobMouseover(e:Event): void {		//trace("+mouseover");		_isOver = true;		if (! _isPressed) {			setMouseover();		}	}	protected function knobMouseout(e:Event): void {		//trace("-mouseout");		_isOver = false;		if (! _isPressed) {			setNormal();		}	}		protected function downKnob(e:MouseEvent): void {				//trace("downKnob");		//spKnob.startDrag(false,rBounds);				stage.addEventListener(MouseEvent.MOUSE_UP,upOutsideKnob);				stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMove);						prevX=e.stageX;		knobstartX = spKnob.x;				_isPressed=true;				setDragging();		prevKnobLocation = knobLocation;			}		protected function handleMove(e:MouseEvent):void {			  	  var newX:Number = knobstartX + e.stageX - prevX;	  var newKnobLocation:int; 	  	  if ( newX < 0 ) {  			newKnobLocation = 0;		  	  } else if (newX > nInnerLength) {		  newKnobLocation = nNumTics;	  } else {		  //spKnob.x = newX;		  newKnobLocation = get_tic_index(newX+nKnobWidth/2);	  }	  	  if (newKnobLocation != knobLocation) {			  spKnob.x = tic_x[newKnobLocation];			  knobLocation = newKnobLocation;			  if (dragMoveNotify) {				  //trace("Index changed to: " + String(newKnobLocation));				  dispatchEvent(new Event(DiscreteHorizontalSlider.SLIDER_CHANGE));			  }		  }			}		protected function upOutsideKnob(e:MouseEvent): void {		endDragging()	}		protected function upKnob(e:MouseEvent): void {		endDragging();	}	private function endDragging():void {				//spKnob.stopDrag();		// get the tic location that's closest, and set the slider there. 		if ( (prevKnobLocation != knobLocation) && (!dragMoveNotify) ) {			dispatchEvent(new Event(DiscreteHorizontalSlider.SLIDER_CHANGE));		}		stage.removeEventListener(MouseEvent.MOUSE_UP,upOutsideKnob);		stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMove);		_isPressed=false;		if (_isOver) {			setMouseover();		} else {			setNormal();		}				//e.updateAfterEvent();			}		public function setDragging():void {		//trace("set dragging");		spKnob.removeChildAt(0);		spKnob.addChild(draggingKnob);	}		private function setMouseover():void {		//trace("set mouseover");		spKnob.removeChildAt(0);		spKnob.addChild(mouseoverKnob);	}		public function setNormal():void {		//trace("set normal");		spKnob.removeChildAt(0);		spKnob.addChild(normalKnob);			}				public function get isPressed():Boolean {					return _isPressed;			}		public function setKnobPos(b:int):void {		var a:int = b-TicMinimum;		trace("set knob pos " + String(b));		if (a < 0) {			a=0;		}		if (a>nNumTics) {			a=nNumTics;		}		  		if (a != knobLocation) {			spKnob.x = tic_x[a];			knobLocation = a;		}			}		public function decreaseKnobPos():void {		var doDispatchEvent:Boolean = true;		if (knobLocation == 0 ) {			doDispatchEvent = false;		}		setKnobPos(TicMinimum + knobLocation-1);		if (doDispatchEvent) {			dispatchEvent(new Event(DiscreteHorizontalSlider.SLIDER_CHANGE));		}	}	public function increaseKnobPos():void {		var doDispatchEvent:Boolean = true;		if (knobLocation ==  nNumTics) {			doDispatchEvent = false;		}		setKnobPos(TicMinimum + knobLocation+1);		if (doDispatchEvent) {			dispatchEvent(new Event(VerticalSlider.SLIDER_CHANGE));		}	}			public function getKnobPos():int {				return knobLocation + TicMinimum;	}		public function getSliderLen():Number{				return nLength;	}		public function destroy():void {				spKnob.removeEventListener(MouseEvent.MOUSE_DOWN,downKnob);		spKnob.removeEventListener(MouseEvent.MOUSE_UP,upKnob);		stage.removeEventListener(MouseEvent.MOUSE_UP,upOutsideKnob);		stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMove);		spKnob.graphics.clear();		shTrack.graphics.clear();		this.removeChild(spKnob);		this.removeChild(shTrack);		shTrack=null;		spKnob=null;	}		private function getBitmapFilter(color:Number):BitmapFilter {	var alpha:Number = 0.4;	var blurX:Number = 10;	var blurY:Number = 10;	var strength:Number = 4;	var inner:Boolean = false;	var knockout:Boolean = false;	var quality:Number = BitmapFilterQuality.HIGH;	return new GlowFilter(color,						  alpha,						  blurX,						  blurY,						  strength,						  quality,						  inner,						  knockout);}		}}