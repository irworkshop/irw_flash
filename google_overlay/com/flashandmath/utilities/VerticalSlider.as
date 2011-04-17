﻿/* ***********************************************************************ActionScript 3 Tutorial by Barbara Kaskoszwww.flashandmath.comLast modified: April 2, 2008************************************************************************ *//*Hacked up by jf*/package com.flashandmath.utilities {	    import flash.display.Sprite;		import flash.display.Shape;      import flash.events.*;		import flash.geom.Rectangle;     public class VerticalSlider extends Sprite {	  	public static const SLIDER_CHANGE:String = "sliderChange";		protected var nLength:Number;	protected var nInnerLength:Number;	protected var shTrack:Shape;	protected var spKnob:Sprite;	protected var nKnobColor:uint;	protected var nKnobOpacity:Number;	protected var nKnobWidth:Number;	protected var nKnobHeight:Number;	protected var nNumTics:int;	protected var sStyle:String;	protected var rBounds:Rectangle;	protected var _isPressed:Boolean;	protected var _isOver:Boolean;	protected var TicColor:uint;	protected var KnobOffset_x:int;		//	private var normalKnob:Sprite;	private var draggingKnob:Sprite;			protected var prevY:Number;		public function VerticalSlider(len:Number, numtics:int){					this.nNumTics = numtics;		this.TicColor = 0x666666;			this.nKnobWidth=20;		this.nKnobHeight = 10;		 		this.KnobOffset_x = 5;					this.nLength=len;		this.nInnerLength = len - nKnobHeight;				this._isPressed=false;		this._isOver=false;				this.nKnobColor=0x666666;		this.nKnobOpacity=1.0;		rBounds=new Rectangle(KnobOffset_x,0,0,nLength-nKnobHeight);		shTrack=new Shape();		this.addChild(shTrack);		spKnob=new Sprite();		spKnob.x = KnobOffset_x;		spKnob.y = 0;		this.addChild(spKnob);		init_knobs();		drawSlider();		activateSlider();		setKnobPos(0);					}		private function init_knobs():void {				normalKnob = new Sprite();		draggingKnob= new Sprite();				normalKnob.graphics.beginFill(0x999999,1);		normalKnob.graphics.drawRect(0, 0, nKnobWidth, nKnobHeight);		normalKnob.graphics.endFill();		normalKnob.mouseEnabled = false;					draggingKnob.graphics.beginFill(0xFF0000,1);		draggingKnob.graphics.drawRect(0, 0, nKnobWidth, nKnobHeight);		draggingKnob.graphics.endFill();				draggingKnob.mouseEnabled = false;	}			protected function drawSlider():void {				shTrack.graphics.clear();		spKnob.graphics.clear();					shTrack.graphics.lineStyle(2,TicColor);		// top tic:		shTrack.graphics.moveTo(0,nKnobHeight/2);		shTrack.graphics.lineTo(2*KnobOffset_x+nKnobWidth,nKnobHeight/2);		// bottom tic:		shTrack.graphics.moveTo(0, nLength-nKnobHeight/2);		shTrack.graphics.lineTo(2*KnobOffset_x+nKnobWidth,nLength-nKnobHeight/2);					// draw smaller intermediate tics		for (var i:int = 1; i< nNumTics; i++) {			shTrack.graphics.moveTo(KnobOffset_x, nKnobHeight/2 + i*nInnerLength/nNumTics);			shTrack.graphics.lineTo(KnobOffset_x+nKnobWidth,nKnobHeight/2 + i*nInnerLength/nNumTics);		}		//nNumTics		//innerLength				spKnob.graphics.beginFill(0xFF0000,1);		spKnob.graphics.drawRect(0, 0, nKnobWidth, nKnobHeight);		spKnob.graphics.endFill();				spKnob.addChild(normalKnob);		spKnob.x = KnobOffset_x;			}		protected function activateSlider(): void {		spKnob.addEventListener(MouseEvent.MOUSE_DOWN,downKnob, false, 0, true);		spKnob.addEventListener(MouseEvent.MOUSE_UP,upKnob, false, 0, true);					}		protected function downKnob(e:MouseEvent): void {				trace("downKnob");		spKnob.startDrag(false,rBounds);				stage.addEventListener(MouseEvent.MOUSE_UP,upOutsideKnob);				stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMove);						prevY=spKnob.y;				_isPressed=true;				setDragging();			}		protected function handleMove(e:MouseEvent):void {			  var curY=spKnob.y;		if(_isPressed){			if(Math.abs(curY-prevY)>0){				prevY=curY;				}			}			}		protected function upOutsideKnob(e:MouseEvent): void {		endDragging()	}		protected function upKnob(e:MouseEvent): void {		endDragging();	}	private function endDragging():void {				spKnob.stopDrag();		// get the tic location that's closest, and set the slider there. 				dispatchEvent(new Event(VerticalSlider.SLIDER_CHANGE));		stage.removeEventListener(MouseEvent.MOUSE_UP,upOutsideKnob);		stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMove);		_isPressed=false;		setNormal();						//e.updateAfterEvent();			}		private function setDragging():void {		trace("set dragging");		spKnob.removeChildAt(0);		spKnob.addChild(draggingKnob);	}		private function setNormal():void {		trace("set normal");		spKnob.removeChildAt(0);		spKnob.addChild(normalKnob);			}				public function get isPressed():Boolean {					return _isPressed;			}		public function setKnobPos(a:Number):void {				spKnob.y=a;			}				public function getKnobPos():Number {				return spKnob.y;					}		public function getSliderLen():Number{				return nLength;			}		public function destroy():void {				spKnob.removeEventListener(MouseEvent.MOUSE_DOWN,downKnob);				spKnob.removeEventListener(MouseEvent.MOUSE_UP,upKnob);				stage.removeEventListener(MouseEvent.MOUSE_UP,upOutsideKnob);				stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMove);				spKnob.graphics.clear();				shTrack.graphics.clear();				this.removeChild(spKnob);				this.removeChild(shTrack);				shTrack=null;				spKnob=null;					}			}}