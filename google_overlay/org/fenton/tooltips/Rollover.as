﻿// ************************************************************************ //																			//  A basic rollover intended to be updated on mousemove 													//  Hacked together by jacob fenton																						//																			// ************************************************************************ package org.fenton.tooltips{		import flash.display.Sprite;	import flash.text.TextField;	import flash.display.Stage;		public class Rollover{		//stage reference	private static var stage:Stage = null;	// Rollover variables	private static var text_width:int = 130;	private static var text_height:int = 50;	private static var rollover_offset:int = 20;	private static var padding:int = 5;		public var rolloverSprite:Sprite;		public var field:TextField;			/**	 * Constructor.	 * @param stageReference -- the stage rollover should be drawn to	 * @return	 * 	 */				public function Rollover(stageReference:Stage):void {		stage = stageReference;		rolloverSprite = new Sprite();				field = new TextField();				field.x = padding + 5 ;		field.y = padding;		field.width = text_width;		field.height = text_height;		field.wordWrap = true;		field.multiline = true;		// Initial value		field.htmlText = "initial text";    		rolloverSprite.addChild(field);		rolloverSprite.graphics.lineStyle(2, 0x000000);		rolloverSprite.graphics.beginFill(0xFFFFFF , 1);		// rolloverSprite.graphics.beginFill(0xFFE8BC , 0.7);		rolloverSprite.graphics.drawRect(0, 0, text_width+2*padding, text_height+2*padding);		rolloverSprite.graphics.endFill();		stage.addChild(rolloverSprite);		rolloverSprite.x = -1000;		rolloverSprite.y = -1000;						}					// Set the rollover position so it's not off the stage	public function moveto(x:int, y:int):void {				if (x + rollover_offset + text_width+2*padding > stage.stageWidth ) {			rolloverSprite.x = x - rollover_offset - text_width-2*padding;		} else {			rolloverSprite.x = x + rollover_offset;		}				if (y + rollover_offset + text_height+2*padding > stage.stageHeight ) {			rolloverSprite.y = y - rollover_offset - text_height-2*padding;		} else {			rolloverSprite.y = y + rollover_offset;		}			}		public function sethtmltext(newtext:String):void {		field.htmlText = newtext;	}		public function hide():void {			rolloverSprite.x = -1000;		rolloverSprite.y = -1000;	}			} // end of class} // End of package