﻿package{import flash.display.MovieClip;import flash.events.Event;//import org.fenton.loaders.parsecomma;import com.dVyper.utils.Alert;import com.flashandmath.utilities.HorizontalSlider;import com.flashandmath.utilities.VerticalSlider;[SWF(width="500",height="300", frameRate="24", backgroundColor="0xFFFFFF")]public class slidertester extends MovieClip{		// constructor	public function slidertester() {	var sliderLen:Number=100;/*The constructor of the HorizontalSlider class takes two parameters:the length of the slider and the type of the knob. (Possible choices are 'triangle' or 'rectangle'.) The sizeand the coloring of the knob and the slider track can be customized laterusing the methods of the class.*/	var hsSliderRed:VerticalSlider=new VerticalSlider(sliderLen,"rectangle");	addChild(hsSliderRed);	hsSliderRed.x=20;	hsSliderRed.y=30;		hsSliderRed.changeKnobColor(0xCC0000);	hsSliderRed.setKnobPos(sliderLen);		hsSliderRed.addEventListener(HorizontalSlider.SLIDER_CHANGE, redChange);	function redChange(e:Event):void {		    var curPos:Number=hsSliderRed.getKnobPos();			trace("Changed. New value = " + String(curPos));		}		}} // end of class} // end of package