﻿package org.fenton.utils{	import flash.display.Sprite;import flash.text.TextField;import flash.text.TextFormat;import flash.text.TextFieldType;import flash.text.TextFieldAutoSize;import flash.text.Font;import flash.text.AntiAliasType;	import flash.display.Bitmap;import flash.display.BitmapData;public class maputils{				private static function drawLabel(labelText:String, label_x:int, label_y:int):TextField {	var this_label:TextField = new TextField();	//myLabel.autoSize = TextFieldAutoSize.LEFT;	var label_width:int = 22;	var label_height:int = 13;	var label_format:TextFormat = new TextFormat();	label_format.align = "right";	label_format.font = "Arial";	label_format.bold = false;	label_format.color = 0x000000;	label_format.size = 10;				var this_label:TextField = new TextField();	//myLabel.autoSize = TextFieldAutoSize.LEFT;	this_label.text = labelText;	this_label.y=label_y;	this_label.x=label_x - label_width/2;	this_label.width=label_width;	this_label.height = label_height;		this_label.setTextFormat(label_format);	return(this_label);		}				public static function getScoreboard(sbWidth:int, sbHeight:int, year:int, prisons:int, pop:int, legend_sprites:Array, legend_values:Array):Sprite {		var text_format = new TextFormat();		text_format.align = "left";		text_format.font = "Arial";		//text_format.bold = false;		text_format.color = 0x000000;		//text_format.size = 14;			var margin_top:int = 10;		var text_height:int = 24;		var sb:Sprite = new Sprite();		var sbColor:uint = 0xBBBBBB;		var sbOpacity:Number = .7;				// draw background;				sb.graphics.beginFill(sbColor, sbOpacity);		sb.graphics.drawRect(0,0,sbWidth, sbHeight);		sb.graphics.endFill();				var cur_sprite_width:int = 90;		for (var i:int = 0; i< legend_sprites.length; i++) {			var this_legend_sprite:Bitmap = legend_sprites[i];			this_legend_sprite.x = 15 + cur_sprite_width;			this_legend_sprite.y = int(22 - this_legend_sprite.height/2);						sb.addChild(drawLabel(String(legend_values[i]), cur_sprite_width+15 + this_legend_sprite.width/2 , 36));			cur_sprite_width = this_legend_sprite.width + this_legend_sprite.x;			trace("width: " + this_legend_sprite.width);			sb.addChild(this_legend_sprite);						}				var legend_text = new TextField();						legend_text.x = 10;		legend_text.y = margin_top;		legend_text.width = 87;		legend_text.height = text_height;		legend_text.wordWrap = false;		legend_text.multiline = false;		legend_text.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		legend_text.htmlText = "<font size='18'><b>Map Key:</b></font> ";		legend_text.setTextFormat(text_format);				sb.addChild(legend_text);		// draw year:				var year_text = new TextField();						year_text.x = 250;		year_text.y = margin_top;		year_text.width = 100;		year_text.height = text_height;		year_text.wordWrap = false;		year_text.multiline = false;		year_text.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		year_text.htmlText = "<font size='14'>Year: </font><font size='18'><b>" + String(year) + "</b></font>";		year_text.setTextFormat(text_format);				sb.addChild(year_text);				var total_pop_text = new TextField();		total_pop_text.x = 360;		total_pop_text.y = margin_top;		total_pop_text.width = 200;		total_pop_text.height = text_height;		total_pop_text.wordWrap = false;		total_pop_text.multiline = false;		total_pop_text.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		total_pop_text.htmlText = "<font size='14'>Avg daily pop*: </font><font size='18'><b>" + addCommas(pop) + "</b></font>";		total_pop_text.setTextFormat(text_format);					sb.addChild(total_pop_text);					var prison_count = new TextField();		prison_count.x = 555;		prison_count.y = margin_top;		prison_count.width = 150;		prison_count.height = text_height;		prison_count.wordWrap = false;		prison_count.multiline = false;		prison_count.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		prison_count.htmlText = "<font size='14'>Facilities*: </font><font size='18'><b>" + addCommas(prisons) + "</b></font>";		prison_count.setTextFormat(text_format);								sb.addChild(prison_count);				return sb;	}			public static function addCommas(number:Number):String {	var negNum:String = "";	if (number<0){		negNum = "-";		number = Math.abs(number);	}	var num:String = String(number);	var results:Array = num.split(/\./);	num=results[0];	if (num.length>3) {		var mod:Number = num.length%3;		var output:String = num.substr(0, mod);		for (var i:Number = mod; i<num.length; i += 3) {			output += ((mod == 0 && i == 0) ? "" : ",")+num.substr(i, 3);		}		if(results.length>1){			if(results[1].length == 1){				return negNum+output+"."+results[1]+"0";			}else{				return negNum+output+"."+results[1];			}		}else{			return negNum+output;		}	}	if(results.length>1){	if(results[1].length == 1){	return negNum+num+"."+results[1]+"0";	}else{		return negNum+num+"."+results[1];	}}else{	return negNum+num;	}}		}	}		