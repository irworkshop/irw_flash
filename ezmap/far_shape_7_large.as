﻿// ************************************************************************//                                                                         //  Adapted from Edwin van Rijkom's FAR + SHP + DBF Sample                                                 //  For more info, see: http://www.vanrijkom.org//  Hacked together by jacob fenton//// ************************************************************************ package{ import flash.display.DisplayObjectContainer;import flash.display.DisplayObject;import flash.display.Sprite;import flash.display.StageAlign;import flash.display.StageScaleMode;import flash.display.Graphics; import flash.text.TextField;import flash.text.TextFieldAutoSize;import flash.text.TextFormat;import flash.text.TextFieldType; import fl.controls.Label;import fl.controls.Slider;import fl.events.SliderEvent;import fl.controls.SliderDirection; import flash.ui.Mouse;  //import flash.events.Event;//import flash.events.SecurityErrorEvent;import flash.events.*;  import flash.net.URLRequest;import flash.utils.ByteArray;import flash.geom.Rectangle; import org.vanrijkom.far.*;import org.fenton.shp.*;import org.fenton.tooltips.Rollover;import org.vanrijkom.dbf.*; import com.dVyper.utils.Alert; [SWF(width="950",height="350", frameRate="24", backgroundColor="0xFFFFFF")]public class far_shape_7_large extends Sprite{    private var status  : TextField;         var stagewidth:int = 950;    var stageheight:int = 350;          private var far     : FarStream;    private var world   : FarItem;    private var worlddb : FarItem;		var dbf: DbfHeader; 	var records: Array;              // This is the multiplier between map units (degrees) and unscaled pixels.    private var zi: Number = 1;    private var s: Sprite = new Sprite();    private var g: Graphics = s.graphics;         private var highlightsprite: Sprite = new Sprite();     var scircles: Sprite = new Sprite();    var gcircles: Graphics = scircles.graphics         private var ro:Rollover;         private var curzoomlevel:int = 1;    private var basezoomlevel:Number = 1;     // Put the circles in this array, then sort them by size before rendering, so the smallest are plotted last.    private var circles_holder:Array = new Array();         public function far_shape_7_large() {                 // initialize dVyper's alert class:        Alert.init(stage);                 //Send an alert on start        //var radius:int = getcircleradius(10000)        //Alert.show("radius for 10000 = " + radius, {buttons:["OK"]}); 		Mouse.cursor="hand";        init();    }         private function init():void {         // Instantiate a FarStream        far = new FarStream();                 // Get FarItem instances for the files we expect to        // find in our FAR arhive:        world   = far.item("world5.shp");        worlddb = far.item("world5.dbf");        //        // Download both files before we draw--the way we draw depends on the .dbffile        //        worlddb.addEventListener(Event.COMPLETE, drawworld);                 far.load(new URLRequest("world5.far"));        ro  = new Rollover(stage);                 // Make the map draggable        stage.addEventListener(MouseEvent.MOUSE_DOWN,startmapdrag)        stage.addEventListener(MouseEvent.MOUSE_UP,stopmapdrag)             }function startmapdrag(e:Event):void{    trace("start drag");    s.startDrag();	Mouse.cursor="button"; }                          function stopmapdrag(e:MouseEvent):void{    s.stopDrag();	// gotta set the cursor correctly if the drag ends on the zoom panel:	var thex:int = e.stageX;	var they:int = e.stageY;	if ( (thex > 10) && (thex < 60) && (they > 10 ) && (they < 100) ) {								   		Mouse.cursor = "arrow";		} else {		Mouse.cursor="hand";	}//    trace("stop drag at " + thex + " " + they);}             private function handlemouseover(x:int, y:int, msg:int, p, lbldata, dbf):void {        Mouse.cursor="arrow";		ro.moveto(x,y);                 var dr: DbfRecord = DbfTools.getRecord            ( lbldata   // ByteArray containing DBF file            , dbf       // Parsed DBF file header            , msg           // index of record to read            );            // DbfRecord.values is a dictionary: field            // values can be retreived like so:        var country_name:String = dr.values['NAME'];        var num_mech:int = dr.values['TOTAL'];        var prcnt_cert:int = dr.values['PRCNT_CRT'];        var lng:Number = dr.values['CENTROID_X'];        var lat:Number = dr.values['CENTROID_Y'];        		var ftot:String = addCommas(num_mech)        ro.sethtmltext("<font face='Arial Bold'>" + country_name + "<br></font><font face='Arial'>" + ftot + " mechanics " +  "<br>" + prcnt_cert + "% certificated</font>");	var radius:Number =  getcircleradius(num_mech);        Circle(highlightsprite.graphics,lng, -lat, radius/curzoomlevel, 0xFF0000, 0.6, 0.01, 0x000000, 0.1, zi);        ShpTools.drawPolyOutline(highlightsprite.graphics, p, zi, 0x005A84, 0);}         private function handlemousemove(x:int, y:int):void {        ro.moveto(x,y);    }    private function handlemouseout():void {        //Alert.show("msg: " + msg + "moused over " + x + ", " + y, {background:"blur"});		Mouse.cursor="hand";        ro.hide();        highlightsprite.graphics.clear();    }                                                    private function drawworld(e: Event):void {        // Parse the dbf header        dbf = new DbfHeader(worlddb.data);                        // Rewritten to add each shape in it's own sprite so we can attach listeners to each sprite        var shp: ShpHeader = new ShpHeader(world.data);        if  (   shp.shapeType != ShpType.SHAPE_POLYGON            &&  shp.shapeType != ShpType.SHAPE_POLYLINE            )            throw(new ShpError("Shapefile does not contain Polygon records (found type: "+shp.shapeType+")"));                              records = ShpTools.readRecords(world.data);                                          var shape_count:int = 0;;//      for each(var p: ShpRecord in records) {        records.forEach(function(p:ShpRecord,i:int, a:Array):void {                var s2: Sprite = new Sprite();            var g2: Graphics = s2.graphics;                         var scircle: Sprite = new Sprite();            var gcircle: Graphics = scircle.graphics;                       g2.lineStyle(0.01,0xFFFFFF);                                      var dr: DbfRecord = DbfTools.getRecord                ( worlddb.data  // ByteArray containing DBF file                , dbf       // Parsed DBF file header                , i         // index of record to read                );            // DbfRecord.values is a dictionary: field            // values can be retreived like so:            var num_mech:int = dr.values['TOTAL'];            var lng:Number = dr.values['CENTROID_X'];            var lat:Number = dr.values['CENTROID_Y'];               //if ( (num_mech > 0) && (i==194) ) {            if ( num_mech > 0 ) {                                                          //E0C2C6                //C3D6E1                ShpTools.drawPolyShp(g2, p, zi, 0xC3D6E1, 1);                  var radius:Number =  getcircleradius(num_mech);                //Circle(gcircle,lng, -lat, radius, 0xFF0000, 0.3, 1, 0x666666, 0.4, zi);                var circle_temp:Sprite = circle_sprite(lng, -lat, radius, 0xFF0000, 0.3, 0.01, 0x666666, 0.4, zi);                                            // It's critical that the final argument (useweakreference) be false, otherwise the event listener will be tossed as out of scope, or some such.                             circle_temp.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {                        // Get the coordinates in stageX/stageY -- the actual sprite is scaled with a zoom factor                        handlemouseover(e.stageX, e.stageY, i, p, worlddb.data, dbf)                }, false, 0, false);                 circle_temp.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void {                        // Get the coordinates in stageX/stageY -- the actual sprite is scaled with a zoom factor                        handlemousemove(e.stageX, e.stageY)                }, false, 0, false);                                    circle_temp.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {                        // Get the coordinates in stageX/stageY -- the actual sprite is scaled with a zoom factor                        handlemouseout()                }, false, 0, false);                                // Don't add it to gcircle yet -- we want to sort it by size and then add it to gcircle;                                 var circle_holder = new Object();                circle_holder.csprite = circle_temp;                circle_holder.radius = radius;                // Add it the circles_holder Array;                circles_holder.push(circle_holder);                                 } else {                ShpTools.drawPolyShp(g2, p, zi, 0xE6E6E6, 1);                          }                                          shape_count++;            s.addChild(s2);//          scircles.addChild(scircle);                      });                         // add sprite to canvas:        s.addChild(highlightsprite);                          // Add the circles, sorted by radius;        circles_holder = circles_holder.sortOn("radius", Array.DESCENDING | Array.NUMERIC);                           var i:int;        for (i=0; i< circles_holder.length; i++) {            scircles.addChild(circles_holder[i].csprite);            trace(i + " : " + circles_holder[i].radius);        }                 s.addChild(scircles);                 addChild(s);    // scale the clip to nicely fit our canvas:            scaleToFitCanvas(s,shp,zi);            drawzoombox();    }         public function drawOthers(e: Event): void {         // parse the header of the Shapefile loaded in cities.data:    //  var shp: ShpHeader = new ShpHeader(cities.data);        // parse the header of the Shapefile loaded in citiesdb.data:    //  var dbf: DbfHeader = new DbfHeader(citiesdb.data);        // draw city name labels:        /*        drawDbfLabelsAtShpPoints            ( s, zi             // target DisplayObjectContainer and zoom level            , cities.data       // ByteArray containing Shapefile            , shp               // Parsed Shapefile header            , citiesdb.data     // ByteArray containing DBF file            , dbf               // Parsed DBF file header            , "NAME"            // Value field name to use a label caption            );    */    }          private function drawzoombox():void {        var slidersprite = new Sprite();                                 slidersprite.graphics.lineStyle(1,0x999999);        slidersprite.graphics.beginFill(0xFFFFFF, 1);              slidersprite.graphics.drawRect(0,0,50,90);        slidersprite.graphics.endFill();				// Make the cursor an arrow when it's over the zoom control		slidersprite.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {                        Mouse.cursor="arrow";                }, false, 0, false);		slidersprite.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {                        Mouse.cursor="hand";                }, false, 0, false);		                          // We have to explicitly set the width of all the text label fields.        // If we don't, their default size is big enough that it interfere's        // with the mouse event listeners on the map.        var zoomtitle:Label = new Label();        //myLabel.autoSize = TextFieldAutoSize.LEFT;        zoomtitle.text = "ZOOM";        zoomtitle.x=5;        zoomtitle.y=5;        zoomtitle.width=40;        slidersprite.addChild(zoomtitle);                 var zoomplus:Label = new Label();        //myLabel.autoSize = TextFieldAutoSize.LEFT;        zoomplus.text = "+";        zoomplus.x=33;        zoomplus.y=18;        zoomplus.width = 10;        slidersprite.addChild(zoomplus);                          var zoomminus:Label = new Label();        //myLabel.autoSize = TextFieldAutoSize.LEFT;        zoomminus.text = "-";        zoomminus.x=33;        zoomminus.y=68;        zoomminus.width = 10;        slidersprite.addChild(zoomminus);                                var zoomslider:Slider = new Slider();        //mySlider.addEventListener(SliderEvent.THUMB_DRAG, thumbDragHandler);                 zoomslider.snapInterval = 1;        zoomslider.tickInterval = 1;        zoomslider.maximum = 7;        zoomslider.minimum = 1        zoomslider.value = 1;        zoomslider.x = 20;        zoomslider.y = 27;        zoomslider.liveDragging = true;                          //s.move(myLabel.x, myLabel.y + myLabel.height);                 zoomslider.direction = SliderDirection.VERTICAL;        zoomslider.setSize(20, 50);                 slidersprite.addChild(zoomslider);        // Ignore mouse clicks        slidersprite.addEventListener(MouseEvent.MOUSE_DOWN,onStopPropDown,false, 0, true);        //slidersprite.addEventListener(MouseEvent.MOUSE_UP,onStopPropDown,false, 0, true);                          slidersprite.x = 10;        slidersprite.y = 10;        addChild(slidersprite);        zoomslider.addEventListener(SliderEvent.CHANGE, zoomChange);      }                  public function scaleToFitCanvas(t: DisplayObject, shp: ShpHeader, zoom: Number): void {        // fit to requested width/height:        var r: Rectangle    = getBounds(t);            var f: Number       = Math.min                                ( stage.stageHeight / r.height                                , stage.stageWidth / r.width                                );                 // set calculated scale:        if (f!=Infinity)            t.scaleX = t.scaleY = f;        // set the class variable so we can zoom further in later            basezoomlevel = f;                  // maintain top-left position:        t.x = -shp.boundsXY.left * zoom * f;        t.y = (shp.boundsXY.bottom-shp.boundsXY.top) * zoom * f;                 //             }              public function Circle(g:Graphics, center_x:Number, center_y:Number, radius:Number, fillcolor:uint, fillalpha:Number, outlinewidth:int, outlinecolor:uint, outlinealpha: Number, zoom:Number) {             g.lineStyle(zoom*outlinewidth, outlinecolor, outlinealpha);        g.beginFill(fillcolor, fillalpha);        g.drawCircle(zoom*center_x, zoom*center_y, zoom*radius);        g.endFill();     }     public function circle_sprite(center_x:Number, center_y:Number, radius:int, fillcolor:uint, fillalpha:Number, outlinewidth:int, outlinecolor:uint, outlinealpha: Number, zoom:Number):Sprite {     var return_sprite:Sprite = new Sprite();    var h:Graphics = return_sprite.graphics;         h.lineStyle(zoom*outlinewidth, outlinecolor, outlinealpha);    h.beginFill(fillcolor, fillalpha);    h.drawCircle(zoom*center_x, zoom*center_y, radius/curzoomlevel);    h.endFill();   	trace("radius: " + radius + " radius: " + radius/curzoomlevel + " zoom " + zoom);     return return_sprite;    }     public function getcircleradius(mechanics:int):Number {        var radius:Number = 10*Math.sqrt(mechanics)/(122.4)        if (radius < 2) {            radius = 2;        }        return radius;    }     function zoomChange(e:SliderEvent):void {    var newzoom:int = e.target.value;    trace("new zoom is " + newzoom);          // size of s2 sprite to begin with    var initial_width:int = stagewidth * curzoomlevel;    var initial_height:int = stageheight * curzoomlevel;         //The current center in sprite coordinates    var curcenterx:Number = stagewidth/2 - s.x;    var curcentery:Number = stageheight/2 -s.y;         // The relative position of the center    var relativecenterx:Number = curcenterx / initial_width;    var relativecentery:Number = curcentery / initial_height;              //Alert.show('zooming to ' + newzoom + " with zi " + zi + " basezoomlevel: " + basezoomlevel, {buttons:["OK"]});         //Now reset the zoom level:        curzoomlevel=newzoom;    // Scale the sprite to fit              s.scaleX = s.scaleY = curzoomlevel * basezoomlevel;         // New dimensions    var final_width:int = stagewidth * curzoomlevel;    var final_height:int = stageheight * curzoomlevel;         // Calculate the center in terms of the zoomed sprite      var finalx:Number = relativecenterx * final_width;    var finaly:Number = relativecentery * final_height;         // Now calculate the new offsets    var finaloffsetx:Number = stagewidth/2 - finalx;    var finaloffsety:Number = stageheight/2 - finaly;         s.x = finaloffsetx;    s.y = finaloffsety;	    // Now redraw the circles    redrawCircles();	     }     function redrawCircles():void { // remove all the existing circles.    while(scircles.numChildren > 0){        scircles.removeChildAt(0);    }    drawallcircles(); }function drawallcircles():void {	circles_holder = [];	records.forEach(function(p:ShpRecord,i:int, a:Array):void { 															var s2: Sprite = new Sprite();	var g2: Graphics = s2.graphics;	 	var scircle: Sprite = new Sprite();	var gcircle: Graphics = scircle.graphics;          	g2.lineStyle(0.01,0xFFFFFF);	var shape_count:int = 0;	 	 	var dr: DbfRecord = DbfTools.getRecord		( worlddb.data  // ByteArray containing DBF file		, dbf       // Parsed DBF file header		, i         // index of record to read		);	// DbfRecord.values is a dictionary: field	// values can be retreived like so:	var num_mech:int = dr.values['TOTAL'];	var lng:Number = dr.values['CENTROID_X'];	var lat:Number = dr.values['CENTROID_Y'];  	//if ( (num_mech > 0) && (i==194) ) {	if ( num_mech > 0 ) {   			 		var radius:Number =  getcircleradius(num_mech);		//Circle(gcircle,lng, -lat, radius, 0xFF0000, 0.3, 1, 0x666666, 0.4, zi);		var circle_temp:Sprite = circle_sprite(lng, -lat, radius, 0xFF0000, 0.3, 0.01, 0x666666, 0.4, zi);							// It's critical that the final argument (useweakreference) be false, otherwise the event listener will be tossed as out of scope, or some such.	 		circle_temp.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {				// Get the coordinates in stageX/stageY -- the actual sprite is scaled with a zoom factor				handlemouseover(e.stageX, e.stageY, i, p, worlddb.data, dbf)		}, false, 0, false);		circle_temp.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void {				// Get the coordinates in stageX/stageY -- the actual sprite is scaled with a zoom factor				handlemousemove(e.stageX, e.stageY)		}, false, 0, false);               		circle_temp.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {				// Get the coordinates in stageX/stageY -- the actual sprite is scaled with a zoom factor				handlemouseout()		}, false, 0, false);						// Don't add it to gcircle yet -- we want to sort it by size and then add it to gcircle;		 		var circle_holder = new Object();		circle_holder.csprite = circle_temp;		circle_holder.radius = radius;		// Add it the circles_holder Array;		circles_holder.push(circle_holder);    		 	} 		 	 	shape_count++;	s.addChild(s2);//          scircles.addChild(scircle);             	});		circles_holder = circles_holder.sortOn("radius", Array.DESCENDING | Array.NUMERIC);        		var i:int;	for (i=0; i< circles_holder.length; i++) {		scircles.addChild(circles_holder[i].csprite);//		trace(i + " : " + circles_holder[i].radius);	}	 ///	s.addChild(scircles);	}function onStopPropDown(evt:MouseEvent):void {//output.text = "stopProp down";    evt.stopPropagation();} function addCommas(number:Number):String {	var negNum:String = "";	if (number<0){		negNum = "-";		number = Math.abs(number);	}	var num:String = String(number);	var results:Array = num.split(/\./);	num=results[0];	if (num.length>3) {		var mod:Number = num.length%3;		var output:String = num.substr(0, mod);		for (var i:Number = mod; i<num.length; i += 3) {			output += ((mod == 0 && i == 0) ? "" : ",")+num.substr(i, 3);		}		if(results.length>1){			if(results[1].length == 1){				return negNum+output+"."+results[1]+"0";			}else{				return negNum+output+"."+results[1];			}		}else{			return negNum+output;		}	}	if(results.length>1){	if(results[1].length == 1){	return negNum+num+"."+results[1]+"0";	}else{		return negNum+num+"."+results[1];	}}else{	return negNum+num;	}}     } // end of class } // end of package