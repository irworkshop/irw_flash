﻿package org.fenton.utils{	import flash.display.Sprite;import flash.text.TextField;import flash.text.TextFormat;import flash.text.TextFieldType;import flash.text.TextFieldAutoSize;import flash.text.Font;import flash.text.AntiAliasType;	public class maputils{				public static function getScoreboard(sbWidth:int, sbHeight:int, year:int, prisons:int, pop:int):Sprite {		var text_format = new TextFormat();		text_format.align = "left";		text_format.font = "Arial";		text_format.bold = true;		text_format.color = 0x000000;		text_format.size = 16;			var margin_top:int = 5;		var text_height:int = 22;		var sb:Sprite = new Sprite();		var sbColor:uint = 0xAAAAAA;		var sbOpacity:Number = 0.75;				// draw background;				sb.graphics.beginFill(sbColor, sbOpacity);		sb.graphics.drawRect(0,0,sbWidth, sbHeight);		sb.graphics.endFill();						// draw year:				var year_text = new TextField();						year_text.x = 250;		year_text.y = margin_top;		year_text.width = 100;		year_text.height = text_height;		year_text.wordWrap = false;		year_text.multiline = false;		year_text.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		year_text.htmlText = "Year: <b>" + String(year) + "</b>";		year_text.setTextFormat(text_format);				sb.addChild(year_text);				var total_pop_text = new TextField();		total_pop_text.x = 360;		total_pop_text.y = margin_top;		total_pop_text.width = 200;		total_pop_text.height = text_height;		total_pop_text.wordWrap = false;		total_pop_text.multiline = false;		total_pop_text.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		total_pop_text.htmlText = "Avg daily pop*: <b>" + addCommas(pop) + "</b>";		total_pop_text.setTextFormat(text_format);					sb.addChild(total_pop_text);					var prison_count = new TextField();		prison_count.x = 555;		prison_count.y = margin_top;		prison_count.width = 150;		prison_count.height = text_height;		prison_count.wordWrap = false;		prison_count.multiline = false;		prison_count.antiAliasType = AntiAliasType.ADVANCED;		// Initial value		//field.htmlText = "initial text"; 		prison_count.htmlText = "Facilities*: <b>" + addCommas(prisons) + "</b>";		prison_count.setTextFormat(text_format);								sb.addChild(prison_count);				return sb;	}	public static function addCommas(number:Number):String {	var negNum:String = "";	if (number<0){		negNum = "-";		number = Math.abs(number);	}	var num:String = String(number);	var results:Array = num.split(/\./);	num=results[0];	if (num.length>3) {		var mod:Number = num.length%3;		var output:String = num.substr(0, mod);		for (var i:Number = mod; i<num.length; i += 3) {			output += ((mod == 0 && i == 0) ? "" : ",")+num.substr(i, 3);		}		if(results.length>1){			if(results[1].length == 1){				return negNum+output+"."+results[1]+"0";			}else{				return negNum+output+"."+results[1];			}		}else{			return negNum+output;		}	}	if(results.length>1){	if(results[1].length == 1){	return negNum+num+"."+results[1]+"0";	}else{		return negNum+num+"."+results[1];	}}else{	return negNum+num;	}}		}	}		