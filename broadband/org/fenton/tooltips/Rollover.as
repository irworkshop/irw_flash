﻿// ************************************************************************ //																			//  A basic rollover intended to be updated on mousemove 													//  Hacked together by jacob fenton																						//																			// ************************************************************************ // Hacked up from a version that included a graph. package org.fenton.tooltips{		import flash.display.Sprite;	import flash.text.TextField;	import flash.display.Stage;		import flash.filters.DropShadowFilter;	import flash.text.TextFormat;	import flash.text.TextFieldType;	import flash.geom.Point;	import flash.text.TextFieldAutoSize;	import flash.text.Font;	import flash.text.AntiAliasType;		public class Rollover{		//stage reference	private static var stage:Stage = null;	// Rollover variables	private static var text_width:int = 100;	private static var text_height:int = 60;	private static var rollover_offset:int = 20;	private static var padding:int = 10;		private var rolloverSprite:Sprite;	private var graph:Sprite;	private var header:TextField;	private var bodytext:TextField;	private var header_format:TextFormat;	private var bodytext_format:TextFormat;					/**	 * Constructor.	 * @param stageReference -- the stage rollover should be drawn to	 * @return	 * 	 */				public function Rollover(stageReference:Stage):void {				header_format = new TextFormat();		header_format.align = "left";		header_format.font = "Arial Narrow";		header_format.bold = true;		header_format.color = 0x000000;		header_format.size = 13;					bodytext_format = new TextFormat();		bodytext_format.align = "left";		bodytext_format.font = "Arial";		//bodytext_format.color = 0x999999;		bodytext_format.size = 11;		stage = stageReference;		rolloverSprite = new Sprite();				header = new TextField();						header.x = padding ;		header.y = padding;		header.width = text_width;		header.height = 18;		header.wordWrap = true;		header.multiline = true;		header.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		header.text = "";								bodytext = new TextField();						bodytext.x = padding ;		bodytext.y = padding + 20;		bodytext.width = text_width;		bodytext.height = 60;		bodytext.wordWrap = true;		bodytext.multiline = true;		// Initial value		//field.htmlText = "initial text"; 		bodytext.text = "";		bodytext.antiAliasType = AntiAliasType.ADVANCED;								rolloverSprite.addChild(header);		rolloverSprite.addChild(bodytext);				rolloverSprite.graphics.lineStyle(2, 0x999999);		rolloverSprite.graphics.beginFill(0xFFFFFF , 1);		// rolloverSprite.graphics.beginFill(0xFFE8BC , 0.7);		rolloverSprite.graphics.drawRoundRect(0, 0, text_width+2*padding, text_height+2*padding, 10);		rolloverSprite.graphics.endFill();				// add rect to serve as 'padding'		//var backdrop:Sprite = new Sprite();				//backdrop.graphics.lineStyle(0,0xFDE1B4);		//backdrop.graphics.beginFill(0xFDE1B4, 1);      		//backdrop.graphics.drawRect(0,0,190,100);		//backdrop.graphics.endFill();		//backdrop.x = padding;		//backdrop.y = 90;		//rolloverSprite.addChild(backdrop);				//graph = new Sprite();		//graph.x = padding + 5;		//graph.y =95;		//rolloverSprite.addChild(graph);						// Add drop shadow:		var shadow:DropShadowFilter = new DropShadowFilter(); 		shadow.distance = 7; 		shadow.angle = 45; 		shadow.alpha = 0.3; 			// You can also set other properties, such as the shadow color, 		// alpha, amount of blur, strength, quality, and options for  		// inner shadows and knockout effects.  		rolloverSprite.filters = [shadow];		stage.addChild(rolloverSprite);		rolloverSprite.x = -1000;		rolloverSprite.y = -1000;						}					// Set the rollover position so it's not off the stage	public function moveto(x:int, y:int):void {				if (x + rollover_offset + text_width+2*padding > stage.stageWidth ) {			rolloverSprite.x = x - rollover_offset - text_width-2*padding;		} else {			rolloverSprite.x = x + rollover_offset;		}				if (y + rollover_offset + text_height+2*padding > stage.stageHeight ) {			rolloverSprite.y = y - rollover_offset - text_height-2*padding;		} else {			rolloverSprite.y = y + rollover_offset;		}			}		public function setrollover(result_row:Array): void {		sethtmltext("<font face='Arial Bold'>" + result_row[1] + "<br></font>");		//setheadertext(result_row[1]);		//setbodytext('<font color="#999999">' + result_row[2] + "\n" + result_row[3] + ", " + result_row[4] + "\n" + String(current_year) + ' Avg. pop: </font><b>' + String(result_row[8+2009-current_year] + "</b>"));		//rolloverSprite.removeChild(graph);		//graph = drawgraph(result_row, current_year);		//graph.x = padding + 5;		//graph.y = 95;		//rolloverSprite.addChild(graph);			}		public function sethtmltext(newtext:String):void {		bodytext.htmlText = newtext;	}	public function setheadertext(newtext:String):void {		//field.htmlText = null;		header.text = newtext;		header.setTextFormat(header_format);	}	public function setbodytext(newtext:String):void {		//field.htmlText = null;		bodytext.htmlText = newtext;		bodytext.setTextFormat(bodytext_format);	}		// returns the location it's at when hidden.	public function hide():Point {		var oldPoint:Point = new Point(rolloverSprite.x, rolloverSprite.y);		rolloverSprite.x = -1000;		rolloverSprite.y = -1000;		return oldPoint;	}		private function drawgraph(rowdata:Array, currentyear:int):Sprite 	{		//trace("Building graph of " + String(rowdata[1]));				var align_right:TextFormat = new TextFormat();		align_right.align = "left";		align_right.font = "Arial";		align_right.color = 0x333333;		align_right.size = 13;				var outerwidth:int = 180;		var outerheight:int = 90;				var label_height:int = 13; 				var label_width:int = 37;		var tic_length:int = 5; 				var origin_y:int = outerheight - 20;		var origin_x:int = 18				var tic_width:int = 1;		var tic_color:uint = 0x999999;				var line_width:int = 2;		var line_color:uint = 0x999999;						var y_max_value:int = 1800;		var y_min_value:int = 0;				var y_scale:Number = ( y_max_value - y_min_value ) / ( origin_y - ( label_height/2 ) ) ;				var x_max_value:int = 2009;		var x_min_value:int = 1981;								var graf:Sprite = new Sprite;				// outline - for testing.		graf.graphics.lineStyle(0,0xFDE1B4);		graf.graphics.beginFill(0xFDE1B4, 1);      		graf.graphics.drawRect(0,0,outerwidth,outerheight);		graf.graphics.endFill();				graf.graphics.lineStyle(1,0x999999);				// Draw Y labels:				var y_max_label:TextField = new TextField();		//myLabel.autoSize = TextFieldAutoSize.LEFT;		y_max_label.text = "1,800";		y_max_label.x=0;		y_max_label.y=0;		y_max_label.width=label_width;		y_max_label.setTextFormat(align_right);		graf.addChild(y_max_label);				var y_min_label:TextField = new TextField();		//myLabel.autoSize = TextFieldAutoSize.LEFT;		y_min_label.text = "0";		y_min_label.x=0;		y_min_label.y=origin_y - label_height/2 - 2;		y_min_label.width=label_width;		y_min_label.setTextFormat(align_right);		graf.addChild(y_min_label);				// Draw Y tics at max and min:		graf.graphics.lineStyle(tic_width, tic_color);		// top tic:		graf.graphics.moveTo (outerwidth - label_width/2, label_height/2);		graf.graphics.lineTo (outerwidth - label_width/2 + tic_length, label_height/2);		// bottom tic: 		graf.graphics.moveTo (outerwidth - label_width/2, origin_y);		graf.graphics.lineTo (outerwidth - label_width/2 + tic_length, origin_y);						// Draw X labels:				var x_max_label:TextField = new TextField();		//myLabel.autoSize = TextFieldAutoSize.LEFT;		x_max_label.text = "2009";		x_max_label.x=outerwidth - label_width;		x_max_label.y=outerheight-label_height;		x_max_label.width=label_width;		x_max_label.setTextFormat(align_right);		graf.addChild(x_max_label);		var x_min_label:TextField = new TextField();		//myLabel.autoSize = TextFieldAutoSize.LEFT;		x_min_label.text = "1981";		x_min_label.x=origin_x - label_width/2 + 3;		x_min_label.y=outerheight - label_height;		x_min_label.width=label_width;		x_min_label.setTextFormat(align_right);		graf.addChild(x_min_label);						// left tic:		graf.graphics.moveTo (origin_x, origin_y);		graf.graphics.lineTo (origin_x, origin_y + tic_length);		// right tic: 		graf.graphics.moveTo (outerwidth - label_width/2, origin_y);		graf.graphics.lineTo (outerwidth - label_width/2, origin_y + tic_length);						var x_steps:int = x_max_value - x_min_value;						graf.graphics.lineStyle(line_width, line_color);				// move to the first step before drawing		graf.graphics.moveTo (origin_x, origin_y + rowdata[8+2009-1981]/y_scale);				for(  var i : int = 1; i <=  x_steps; i++ ) {			//trace("plotting: " + String(i) + "  " + String( rowdata[8+2009-1981-i]));			graf.graphics.lineTo(origin_x + i/x_steps * (outerwidth-label_width/2 - origin_x), origin_y - rowdata[8+2009-1981-i]/y_scale);					}				// Print a dot for the current data point:		graf.graphics.lineStyle(3, 0x000000);		var current_year_index:int = currentyear-1981		graf.graphics.drawCircle(origin_x + current_year_index/x_steps * (outerwidth-label_width/2 - origin_x) , origin_y - rowdata[36-current_year_index]/y_scale, 1);				return graf;					}			} // end of class} // End of package