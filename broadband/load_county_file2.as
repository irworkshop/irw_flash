﻿package{import com.google.maps.LatLng;import com.google.maps.LatLngBounds;import com.google.maps.Map;import com.google.maps.MapMoveEvent;import com.google.maps.MapEvent;import com.google.maps.MapMouseEvent;import com.google.maps.MapZoomEvent;import com.google.maps.MapType;import com.google.maps.controls.ZoomControl;import com.google.maps.overlays.Polygon;import com.google.maps.overlays.PolygonOptions;import com.google.maps.overlays.Polyline;import com.google.maps.overlays.PolylineOptions;import com.google.maps.overlays.EncodedPolylineData;import com.google.maps.styles.FillStyle;import com.google.maps.styles.StrokeStyle;import com.google.maps.InfoWindowOptions;import flash.geom.ColorTransform;import flash.filters.ColorMatrixFilter;import flash.geom.Point;import flash.display.MovieClip;import flash.display.Sprite//import flash.events.Event;// should figure out what's really needed from these: import flash.events.*;import flash.net.*import flash.geom.Rectangle;import com.dVyper.utils.Alert;import org.fenton.tooltips.Rollover;[SWF(width="950",height="500", frameRate="24", backgroundColor="0xFFFFFF")]public class load_county_file2 extends MovieClip{	var map:Map;		private var url_prefix:String = "http://irw.s3.amazonaws.com/broadband/data/state_files/";		private var rawOptions:PolygonOptions = new PolygonOptions({ 				strokeStyle: new StrokeStyle({					color: 0x999999,					thickness: 0,					alpha: 0}), 				fillStyle: new FillStyle({					color: 0x000000,					alpha: 0.4})			})		private var hilite_options:PolygonOptions = new PolygonOptions( { strokeStyle: { color: 0x000000, alpha: 1, thickness: 1 },	  fillStyle: { alpha: 0.4 }} ); 		private var unhilite_options:PolygonOptions = new PolygonOptions( { strokeStyle: { color: 0x999999, alpha: 0,thickness: 0 },	  fillStyle: { alpha: 0.4 }} );		// Where is the mouse right now? Used to update rollover locations	private var curlatLng:LatLng;		// The rollover object	private var ro:Rollover;		// Should we display the info window? 	private var displayRollover = false;			// Array of objects that contain the actual polygons, etc. We need to keep the original overlay object in memory in order to erase it, I think. 	var display_objects:Array = new Array;			var red:Number = 0.3086; // luminance contrast value for red	var green:Number = 0.694; // luminance contrast value for green	var blue:Number = 0.0820; // luminance contrast value for blue	var cmf:ColorMatrixFilter = new ColorMatrixFilter([red, green, blue, 0, 0, 												   red, green, blue, 0, 0, 												   red, green, blue, 0, 0, 												   0, 0, 0, 1, 0]);			private function getshapeobject(thepoly:Polygon, fips:String) {		var this_obj:Object = new Object;		this_obj.poly = thepoly;		this_obj.fips = fips;		return this_obj;	}			private function getpoly(polylines:String, levels:String, this_fips:String, data1:int, data2:int, data3:int, data4:int, data5:int):Polygon {		var plines:Array = polylines.split('"');		var plevels:Array = levels.split('"'); 		//Ditch the empty final elements		plines.pop();		plevels.pop();		var poly_pieces:Array = [];	// The polyline delimiting scheme I'm using is to just throw a double quote at the end of each one--so the last one is empty.		var num_points:int = plines.length;		var j:int;		for (j = 0; j < num_points; j++)		{			var shape_data:EncodedPolylineData =  new    EncodedPolylineData(plines[j],18,plevels[j],2);			poly_pieces.push(shape_data);   		}		var polygon:Polygon = Polygon.fromEncoded(poly_pieces,rawOptions);				polygon.addEventListener(MapMouseEvent.ROLL_OVER, function(e:MapMouseEvent):void {							polygon.setOptions(hilite_options);					polygon.pane.bringToTop(polygon);					//polymessage = msg;					//polygon.pane.bringToTop(polygon);					// We gotta call the menu move here too, otherwise we can end up with the infowindow never visible.					displayRollover = true;					ro.sethtmltext(this_fips + "<br>" + data1 + " "  + data2 + " "  + data3 + " "  + data4 + " "  + data5 + " " );					updatelatlng(e.latLng);						});						polygon.addEventListener(MapMouseEvent.ROLL_OUT, function(e:MapMouseEvent):void {					polygon.setOptions(unhilite_options);					displayRollover = false;					ro.hide();							});										return polygon;	}		private function adddata(data_returned:String):void {						// how long does this load take? 				var start:Date = new Date();		trace('start:' + start.time);				//trace("load complete with data" + data_returned);		var lines:Array = data_returned.split("\n");		//trace(lines);		for each (var this_line:String in lines) {			//trace("*** " + this_line.length + " " +  this_line  ); 			// The last split function gives us a zero-length last line, so ignore it			if (this_line.length > 0) {				var thisresult:Array = this_line.split("\t");								var poly_to_display:Polygon = getpoly(thisresult[3], thisresult[4], thisresult[1], thisresult[5], thisresult[6], thisresult[7], thisresult[8], thisresult[9] );								poly_to_display.setOptions(new PolygonOptions( { fillStyle: { color: get_fcc_color(thisresult[9])}}) );								map.addOverlay(poly_to_display);										}		}				var end:Date = new Date();		//trace('time elapsed:' + String(end.time - start.time));		Alert.show("Time to draw overlay: " + String(end.time - start.time));	}			private function updatelatlng(curlatLng:LatLng):void {		if (displayRollover) {			var thispoint:Point = map.fromLatLngToViewport(curlatLng);			//trace("moving to: " + thispoint.x + ", " + thispoint.y);			ro.moveto(thispoint.x, thispoint.y);		}	}			public function addcountybystatefips():void {		var loader:URLLoader = new URLLoader();		//configureListeners(loader);				loader.addEventListener(Event.COMPLETE, function(e:Event):void{			adddata(loader.data.toString());		});				//var request1:URLRequest = new URLRequest(url_prefix + fips + ".txt");			var request1:URLRequest = new URLRequest("http://irw.s3.amazonaws.com/broadband/data/national_file/national_file2.txt");		try {            loader.load(request1);      	} catch (error:Error) {        	trace("Unable to load requested documents.");		}	}				function onMapReady():void {		map.setCenter(new LatLng(41.7,-97.4), 4, MapType.NORMAL_MAP_TYPE);		map.addControl(new ZoomControl());		setMapFilter( cmf );						   	}			public function load_county_file2() {				// initialize the rollover		ro  = new Rollover(stage);		Alert.init(stage);					map = new Map();														map.key = "ABQIAAAAD0ng6hhfw1-ZXVHi8-_1IRSYLxpl1FJwo67z08DrvK15_jpagxREG61kM4I16jOc_NzGi2_zoJPEkg";		map.sensor = "false";		map.setSize(new Point(stage.stageWidth, stage.stageHeight));				this.addChild(map);		map.addEventListener(MapEvent.MAP_READY, function(e:Event):void{			onMapReady();			addcountybystatefips();		});				map.addEventListener(MapMouseEvent.MOUSE_MOVE, function(e:MapMouseEvent):void {			curlatLng = e.latLng;		//update_curlatLng(curlatLng);		//trace("cur lat lng is: " + curlatLng);							updatelatlng(e.latLng);				});				//map.addEventListener(MapMoveEvent.MOVE_END, mapmoveend);	}	public function mapmoveend(event:Event) : void	{		var center:LatLng = map.getCenter();		trace("center is: " + center);	}		private function get_fcc_color(fcc:int):uint {		if (fcc == 0) {			return 0xFFFFFF;		} else if (fcc == 1) {			return 0xFAf181;		} else if (fcc  == 2) {			return 0xFFF200;		} else if (fcc == 3 ) {			return 0xF9A01B;		} else if (fcc == 4 ) {			return 0xED5922;		} else if (fcc == 5) {			return 0xC44149;		} else {			return 0x00FF00;		}		}	private function setMapFilter( filter : ColorMatrixFilter ) : void	{		var s1:Sprite = map.getChildAt(1) as Sprite;		var s2:Sprite = s1.getChildAt(0) as Sprite;		s2.filters = [ filter ];   	 }}}