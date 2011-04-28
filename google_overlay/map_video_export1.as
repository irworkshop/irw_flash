﻿package{import com.google.maps.LatLng;import com.google.maps.LatLngBounds;import com.google.maps.Map;import com.google.maps.MapMoveEvent;import com.google.maps.MapEvent;import com.google.maps.MapMouseEvent;import com.google.maps.MapType;import com.google.maps.controls.ZoomControl;import com.google.maps.controls.MapTypeControl;// styling importsimport com.google.maps.StyledMapType;import com.google.maps.StyledMapTypeOptions;import com.google.maps.styles.MapTypeStyleElementType;import com.google.maps.styles.MapTypeStyleFeatureType;import com.google.maps.styles.MapTypeStyleRule;import com.google.maps.styles.MapTypeStyle;import com.google.maps.overlays.GroundOverlayOptions;import com.google.maps.overlays.GroundOverlay;import flash.geom.Point;import flash.display.MovieClip;import flash.display.Sprite;import flash.events.Event;import fl.core.UIComponent;import flash.display.Bitmap;import flash.display.BitmapData;import flash.geom.ColorTransform;import flash.filters.ColorMatrixFilter;import flash.geom.Rectangle;import org.fenton.tooltips.Rollover;import com.dVyper.utils.Alert;import flash.text.TextField;import flash.text.TextFieldAutoSize;import flash.text.TextFormat;import flash.text.TextFieldType; import fl.controls.Label;import fl.controls.Slider;import fl.events.SliderEvent;import fl.controls.SliderDirection;import flash.ui.Mouse; import flash.events.*;import flash.net.*import flash.utils.Timer;import flash.filters.DropShadowFilter;import flash.filters.BitmapFilter;import flash.filters.BitmapFilterQuality;import flash.filters.GlowFilter;import org.fenton.sliders.DiscreteVerticalSlider;import org.fenton.sliders.DiscreteHorizontalSlider;import org.fenton.utils.maputils;[SWF(width="700",height="500", frameRate="30", backgroundColor="0xFFFFFF")]public class map_video_export1 extends MovieClip{//private var ref:UIComponent;private var ref:Sprite;private var lastPoint:Point;private var overlayholder:Sprite = new Sprite();// put latlngs here://private var points:Array = new Array();// and corresponding pixels in here:private var points_pixels:Array = new Array();private var ro:Rollover;// which data hunk is the rollover showing? Don't bother updating it unless it's changed.private var ro_showing_index:int;private var mapwidth:int=700;private var mapheight:int=500;private var zoomlevel:int = 4;private var numpoints:int = 500;//private var radius:int = 6;// These are the interior radii of the circle bitmaps;private var min_radius:int = 3;private var max_radius:int = 50;private var circles_array:Array = new Array;private var circles_alpha_array:Array = new Array;private var rollover_circles_array:Array = new Array;private var line_width:int = 2;//private var crit_radius:int = 4+Math.pow((radius+line_width+2),2);// When the map is dragged, don't redraw unless we really have to--just keep track of how far it's been moved. private var last_center:LatLng;private var first_center:LatLng;// Keep track of when the map loading and data loading complete -- only run the setup when both are ready to go. private var loadafterdata:Boolean = false;private var dataisready:Boolean = false;// var loader:URLLoader = new URLLoader();var result : Array = new Array ()	var current_year:int = 2009;var glowFilter1:BitmapFilter;[Embed(source='IRW_magnify_icon_zoom.gif')]private var zoomInImg:Class;private var zoomIn:Bitmap = new zoomInImg ();[Embed(source='IRW_magnify_icon_zoom_out.gif')]private var zoomOutImg:Class;private var zoomOut:Bitmap = new zoomOutImg ();private var zoomSlider:DiscreteVerticalSlider;[Embed(source='play_alt.png')]private var playImg:Class;private var play1:Bitmap = new playImg ();	[Embed(source='stop_alt.png')]private var stopImg:Class;private var stop1:Bitmap = new stopImg ();		[Embed(source='700x500_background.png')]private var bkImg:Class;private var backgroundImage:Bitmap = new bkImg ();	private var controlsprite:Sprite = new Sprite();private var playstate:int = 0;private var playstateChanged:Boolean = false;private var scoreboardSprite:Sprite = new Sprite();var myTimer:Timer;var yeartimer:int;var yearTimer:DiscreteHorizontalSlider;var map:Map = new Map();private var nocitylabelsstyle:StyledMapType;private var hascitylabelsstyle:StyledMapType;var overlay_1:GroundOverlay;var overlay_0:GroundOverlay;	public function map_video_export1() {		load_data();				// add the background image: 		//addChild(backgroundImage);						// initialize the rollover		ro  = new Rollover(stage);		// draw the bitmaps		initialize_circles();		glowFilter1= getBitmapFilter(0xF9A01B);				//var map:Map = new Map();		map.key = "ABQIAAAAD0ng6hhfw1-ZXVHi8-_1IRTm2E_fMzPNNPQWz2AeEXeYkSD5QhQjzVgo-IesHaawQxgV1otoWX8v-g";		map.sensor = "false";		//map.setSize(new Point(stage.stageWidth, stage.stageHeight));				map.setSize(new Point(mapwidth, mapheight));								var red:Number = 0.3086; // luminance contrast value for red		var green:Number = 0.694; // luminance contrast value for green		var blue:Number = 0.0820; // luminance contrast value for blue		var cmf:ColorMatrixFilter = new ColorMatrixFilter([red, green, blue, 0, 0, 													   red, green, blue, 0, 0, 													   red, green, blue, 0, 0, 													   0, 0, 0, 1, 0]);				// just make it more transparent		var cmf2:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 													   0, 1, 0, 0, 0, 													   0, 0, 1, 0, 0, 													   0, 0, 0, 0.5, 0]);														setMapFilter( cmf2 );						this.addChild(map);		this.addChild(overlayholder);		overlayholder.mouseEnabled = false;		map.addEventListener(MapEvent.MAP_READY, loadmapifdataready);						}		public function loadmapifdataready(event:Event) {		if (dataisready) {			onMapReady();		} else {			loadafterdata=true;		}	}		public function load_data() {      configureListeners(loader);      var request:URLRequest = new URLRequest("http://irw.s3.amazonaws.com/flash/points.txt");      try {            	loader.load(request);           } catch (error:Error) {                trace("Unable to load requested document.");		   }	}			private function configureListeners(dispatcher:IEventDispatcher):void {		dispatcher.addEventListener(Event.COMPLETE, completeHandler);            //dispatcher.addEventListener(Event.OPEN, openHandler);            //dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);            //dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);            //dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);            //dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);  	}						private function completeHandler ( event : Event )	{		var rows = loader.data.toString().split("\n");        for(  var i : int = 1; i < rows.length-1; i++ )        {			//trace("handling row " + i);			result.push( rows[ i ].split("|") );		}		dataisready = true;		trace("loaded data with row[500][0] " + String(result[500][0]) );		if (loadafterdata) {			trace("loading map after data");			onMapReady();		}		    }			public function mapmovestart(event:Event) : void	{		last_center=map.getCenter();		first_center=last_center;		//trace("start: " + String(last_center));	}		public function mapmoveend(event:Event) : void	{		var p:Point = map.fromLatLngToViewport(last_center);		var xoffset:Number = p.x-mapwidth/2;		var yoffset:Number = p.y-mapheight/2;		//trace("end: " + String(p) + " " + String(xoffset) + " " + String(yoffset));		ref.x += xoffset;		ref.y += yoffset;				overlayholder.removeChild(ref);		recalculate_latlng_pixels();		drawStuff();		init_rollover_circle();	}		public function mapmovestep(event:Event) : void	{		var new_center:LatLng = map.getCenter();		var p:Point = map.fromLatLngToViewport(last_center);		var xoffset:Number = p.x-mapwidth/2;		var yoffset:Number = p.y-mapheight/2;		//trace("end: " + String(p) + " " + String(xoffset) + " " + String(yoffset));		ref.x += xoffset;		ref.y += yoffset;		last_center=new_center;			}		public function recalculate_latlng_pixels(): void 	{		trace("recalculate lat lng pixels " + String(result.length));		// Dump what's in the pixels array and repopulate it		points_pixels = new Array();		for (var k:Number = result.length-1; k > -1; k--) {			var t:Array = result[k];			var annual_data:int = t[2009-current_year+8];			if (annual_data > 0) {				var a:Point = map.fromLatLngToViewport( new LatLng(t[6],t[7]) );				//trace("adding point: " + String(t[6]) + " , " + String(t[7]) + " Point: " + a );				var point_holder:Object = new Object;				point_holder.point = a;				point_holder.radius = getcircleradius(annual_data);				point_holder.data_index = k;				point_holder.annual_data = annual_data;				points_pixels.push(point_holder);			}		}	}	public function translate_latlng_pixels(offset:Point): void	{		// When the map is just moved, it's (probably) faster to just move the points rather than reproject them. 		for (var k:Number = numpoints-1; k > -1; k--) {			points_pixels[k].point.x += offset.x;			points_pixels[k].point.y += offset.y;		}	}		public function initialize_circles(): void 	{				for (var k:Number = min_radius; k < max_radius; k++) {						// Create a marker to clone:			var s:Sprite = new Sprite();			s.graphics.lineStyle(line_width, 0x333333, 2);			if (zoomlevel <6) {				s.graphics.beginFill(0xFF0000, 0.40);			} else if (zoomlevel == 6) {				s.graphics.beginFill(0xFF0000,0.55);			} else {				s.graphics.beginFill(0xFF0000,0.6);			}			s.graphics.drawCircle(k+line_width, k+line_width, k);									var circle:BitmapData = new BitmapData(2*k+2*line_width, 2*k+2*line_width, true, 0x00000000);			circle.draw(s);			circles_array[k]=circle;									// Create an alphabitmap layer -- documentation on this is crap			// It seems like the color in this bitmap is ignored and only the alpha level is included. 						var t:Sprite = new Sprite();			t.graphics.beginFill(0x000000, 1);			t.graphics.drawCircle(k+line_width, k+line_width, k);			var circleAlpha:BitmapData = new BitmapData(2*k+2*line_width, 2*k+line_width, true, 0x00000000);			circleAlpha.draw(t);			circles_alpha_array[k]=circleAlpha;		}	}		public function getcircleradius(prisonsize:int):int {        var radius:Number = 20*Math.sqrt(prisonsize)/(42.4)        if (radius < 3) {            radius = 3;        }        if (zoomlevel == 4) {			return int(radius);		} else if (zoomlevel == 5) {			var newi:int =  int(radius*1.5);			if (newi>=max_radius) {				newi=max_radius-1;			}			return newi;		} else if (zoomlevel == 6) {			var newi:int =  int(radius*2);			if (newi>=max_radius) {				newi=max_radius-1;			}			return newi;		} 						else  {			var newi:int =  int(radius*2.5);			if (newi>=max_radius) {				newi=max_radius-1;			}			return newi;		}    }		public function drawStuff() : void	{		//ref = new UIComponent(); // creating a UI component Object		ref = new Sprite();		overlayholder.addChild(ref); // add UI component to stage		var width:Number = mapwidth;		var height:Number = mapheight;		var startpoint:Number;						 		// Create a biggish bitmapdata				var b:BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);						var zeropoint:Point = new Point(0,0);				recalculate_latlng_pixels();				// copy points		var npoints:int = points_pixels.length;		for (var k:int = 0; k < npoints; k++) {			var a:Point = points_pixels[k].point;			var size:int = points_pixels[k].radius;			var copyrect:Rectangle = new Rectangle(0,0,2*size+2*line_width,2*size+2*line_width);			var c:Point= new Point(a.x-size-line_width, a.y-size-line_width);			//trace("Trying to draw " + String(k) +" with size: " + size) ;			b.copyPixels(circles_array[size], copyrect, c , circles_alpha_array[size], zeropoint, true);   			}						// draw the bitmapdata to a bitmap and add it. 				var bi:Bitmap = new Bitmap(b);		bi.x=0;		bi.y=0;				// Ignore mouse events. If we listen to them, they don't propagate to the map underneath.		ref.mouseEnabled = false;		ref.addChild( bi);					}			public function moveacircle(circleindex:int, x:int, y:int):void {		for (var k:Number = min_radius; k < max_radius; k++) {			if (k==circleindex) {				rollover_circles_array[circleindex].sprite.x = x;				rollover_circles_array[circleindex].sprite.y = y;				rollover_circles_array[circleindex].shown = true;			}			else {				if (rollover_circles_array[k].shown) {					rollover_circles_array[k].shown = false;					rollover_circles_array[k].sprite.x = -1000;					rollover_circles_array[k].sprite.y = -1000;														}			}		}	}	public function hidecircles():void {		for (var k:Number = min_radius; k < max_radius; k++) {			if (rollover_circles_array[k].shown) {					rollover_circles_array[k].shown = false;					rollover_circles_array[k].sprite.x = -1000;					rollover_circles_array[k].sprite.y = -1000;														}		}	}	private function init_rollover_circle():void {			for (var k:Number = min_radius; k < max_radius; k++) {// rollover_circles_array			var t:Sprite = new Sprite();				t.graphics.lineStyle(line_width, 0xF9A01B, 1);			t.graphics.beginFill(0xFFFFFF, 0.5);			t.graphics.drawCircle(0, 0, k);			t.graphics.endFill();			// don't listen to events			t.mouseEnabled = false;			var rollover_holder:Object = new Object;			rollover_holder.sprite = t;			var f:Boolean = false;			rollover_holder.shown = f;			rollover_circles_array[k] = rollover_holder;			//ref.addChild(t);			t.x=-1000;			t.y=-1000;			ref.addChild(t);		}		}		private function hittest(point:Point, invalidateYear:Boolean):void {		lastPoint = point;		var cx:Number = point.x;		var cy:Number = point.y;		var d2:Number;		var min_d2:Number=2500;		var close_point:Point;		var close_point_index:int;		var show_rollover:Boolean = false;				for (var i:int = points_pixels.length-1; i > -1; i--) {		// What's exponent in flex? 			var thispoint:Object = points_pixels[i];			// bias the pointer to highlight the smaller point -- this helps with concentric circles.			d2=Math.pow((cx-thispoint.point.x),2)+Math.pow((cy-thispoint.point.y),2) + thispoint.radius/30;			//Alert.show("cx: " + cx + " cy: " + cy + " pointsx " + points[i].x + " pointsy: " + points[i].y + " d2: " + d2);									if (d2 < min_d2) {				if (d2 < 20 + Math.pow(thispoint.radius,2)) {					min_d2 = d2;					close_point = thispoint.point;					close_point_index = i;					show_rollover = true;				}			}		}				if (show_rollover) {			//trace("mousing over: " + String(close_point_index));									if (points_pixels[close_point_index].data_index != ro_showing_index || invalidateYear) {								var result_row:Array = result[points_pixels[close_point_index].data_index];				ro.setrollover(result_row, current_year);				ro_showing_index = points_pixels[close_point_index].data_index;				//trace("updated rollover");			}			// Doing it this way would make the markers appear in a fixed position			//ro.moveto(close_point.x,close_point.y);						ro.moveto(point.x, point.y);									//trace("Near: " + String(close_point.x) + " " + String(close_point.y) + " " + String(points_pixels[close_point_index].radius));			// we gotta make up for the fact that the underlying sprite may have moved			moveacircle(points_pixels[close_point_index].radius, close_point.x-ref.x, close_point.y-ref.y);			} else {			ro.hide();			hidecircles();		}				}			private function exitHandler(e:Event) {	// make sure the rollover isn't shown when the mouse is off the stage. Without this, the rollovers were appearing if a bubble was at the 0,0 position on the map.	// Not clear how many browsers this works on... 		ro.hide();		hidecircles();	}	function onMapReady():void {	 var hascityStyles:Array = [	 // new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,	//	  MapTypeStyleElementType.GEOMETRY,	//	  [MapTypeStyleRule.hue(0x00ff00),	//	  MapTypeStyleRule.saturation(100)]),	 // new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,	//	  MapTypeStyleElementType.GEOMETRY,	//	  [MapTypeStyleRule.lightness(-100)])	new MapTypeStyle(MapTypeStyleFeatureType.POI,		MapTypeStyleElementType.ALL,			 		[MapTypeStyleRule.visibility("off")]),		new MapTypeStyle(MapTypeStyleFeatureType.ROAD,		MapTypeStyleElementType.ALL,			 		[MapTypeStyleRule.visibility("off")]),		//new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE_LOCALITY,	//	MapTypeStyleElementType.ALL,			 	//	[MapTypeStyleRule.visibility("off")]),			new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE_PROVINCE,		MapTypeStyleElementType.GEOMETRY,			 		[MapTypeStyleRule.lightness(-100)]),			new MapTypeStyle(MapTypeStyleFeatureType.WATER,		MapTypeStyleElementType.GEOMETRY,			 		[MapTypeStyleRule.hue(0x000000)])		  ];  var hascitynameOptions:StyledMapTypeOptions = new StyledMapTypeOptions({	  name: 'has city',	  alt: 'City'  });  hascitylabelsstyle = new StyledMapType(hascityStyles, hascitynameOptions);	///	  var simplerStyles:Array = [	 // new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,	//	  MapTypeStyleElementType.GEOMETRY,	//	  [MapTypeStyleRule.hue(0x00ff00),	//	  MapTypeStyleRule.saturation(100)]),	 // new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,	//	  MapTypeStyleElementType.GEOMETRY,	//	  [MapTypeStyleRule.lightness(-100)])	new MapTypeStyle(MapTypeStyleFeatureType.POI,		MapTypeStyleElementType.ALL,			 		[MapTypeStyleRule.visibility("off")]),		new MapTypeStyle(MapTypeStyleFeatureType.ROAD,		MapTypeStyleElementType.ALL,			 		[MapTypeStyleRule.visibility("off")]),		new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE_LOCALITY,		MapTypeStyleElementType.ALL,			 		[MapTypeStyleRule.visibility("off")]),			new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE_PROVINCE,		MapTypeStyleElementType.GEOMETRY,			 		[MapTypeStyleRule.lightness(-100)]),			new MapTypeStyle(MapTypeStyleFeatureType.WATER,		MapTypeStyleElementType.GEOMETRY,			 		[MapTypeStyleRule.hue(0x000000)])		  ];  var simplerOptions:StyledMapTypeOptions = new StyledMapTypeOptions({	  name: 'Simpler',	  alt: 'Simpler'  });  nocitylabelsstyle = new StyledMapType(simplerStyles, simplerOptions);  map.addMapType(nocitylabelsstyle);  map.addMapType(hascitylabelsstyle);  //map.addControl(new MapTypeControl());//setMapType(mapType:IMapType): void//Changes the map type for the map.//Parameter 	Type 				//	//		map.setCenter(new LatLng(39.8, -98.5), zoomlevel, nocitylabelsstyle);	var ll:LatLngBounds = map.getLatLngBounds();	//trace("bounds are : " + String(ll));			//	//		var s:Sprite = drawBox(100,100,0xffffff);	    overlay_0 = new GroundOverlay(s,new LatLngBounds(new LatLng(90,-180), new LatLng(-90,180)));		map.addOverlay(overlay_0);				var overlay_1_options:GroundOverlayOptions = new GroundOverlayOptions({	  strokeStyle: {		color: 0xFFFFFF,		alpha: 0,		thickness: 0,		pixelHinting: true	  },	  rotation: 0,	  applyProjection: false,	  renderContent: false	});					var overlay_1_bounds:LatLngBounds = new LatLngBounds(new LatLng(20.9920976432336, -129.26171875), new LatLng(54.59109042897792, -67.73828125000001));	overlay_1 = new GroundOverlay(backgroundImage, overlay_1_bounds, overlay_1_options);	map.addOverlay(overlay_1);	Alert.init(stage);			var start:Date = new Date();	trace('start:' + start.time);	drawStuff();		var controls:Sprite  = drawTimeControl();	controls.x = 60;	controls.y = 10;	addChild(controls);		var zoomcontrols:Sprite = drawZoomBox();	zoomcontrols.x = 15;	zoomcontrols.y = 60;	stage.addChild(zoomcontrols);	//map.addControl(new ZoomControl());		scoreboardSprite.y = 450;	scoreboardSprite.x = 0;	stage.addChild(scoreboardSprite);	scoreboardSprite.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {		//Mouse.cursor="button";		ro.hide();		hidecircles();	});	setScoreBoard();				var end:Date = new Date();	trace('time elapsed:' + (end.time - start.time)); 		//Alert.show("Drew  " + String(points_pixels.length) + "  points. Draw time= " +  String(end.time - start.time) + " milliseconds", {buttons:["OK"]});	init_rollover_circle();		map.addEventListener(MapMoveEvent.MOVE_START, mapmovestart);	map.addEventListener(MapMoveEvent.MOVE_END, mapmoveend);	map.addEventListener(MapMoveEvent.MOVE_STEP, mapmovestep);	map.addEventListener(MapMouseEvent.MOUSE_MOVE, function(e:MapMouseEvent):void {		hittest(map.fromLatLngToViewport(e.latLng), false);	});	stage.addEventListener(Event.MOUSE_LEAVE, exitHandler);			// trying to export as movie:	lastPoint = new Point(0,0);	var aTimer:Timer = new Timer(20, 1);	aTimer.addEventListener(TimerEvent.TIMER_COMPLETE, runMovieHandler);	aTimer.start();		trace("started timer");		}public function runMovieHandler(e:Event) {				controlclick();		var bTimer:Timer = new Timer(12000, 1);	bTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showKrome);	bTimer.start();			}public function showKrome(e:Event) {		lastPoint = new Point(550, 447), 	hittest(lastPoint, true);}function onStopPropDown(evt:MouseEvent):void {//output.text = "stopProp down";    evt.stopPropagation();}private function setMapFilter( filter : ColorMatrixFilter ) : void{	//var s1:Sprite = map.getChildAt(1) as Sprite;	//var s2:Sprite = s1.getChildAt(0) as Sprite;	//s2.filters = [ filter ]; 	map.filters = [ filter ]; }  public function drawZoomBox():Sprite {		var zoom_container:Sprite = new Sprite();		zoom_container.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {		//Mouse.cursor="button";		ro.hide();		hidecircles();	});	zoom_container.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {		//Mouse.cursor="arrow";	});		// draw an overall rounded rect to hold everything: 	zoom_container.graphics.lineStyle(2,0x999999);	zoom_container.graphics.beginFill(0xFFFFFF,1);	zoom_container.graphics.drawRoundRect(0, 0, 40, 104, 10);	zoom_container.graphics.endFill();		var shadow:DropShadowFilter = new DropShadowFilter(); 	shadow.distance = 7; 	shadow.angle = 45; 	shadow.alpha = 0.3;		zoom_container.filters=[shadow];		var zoomInSprite = new Sprite();	zoomIn.height=17;	zoomIn.width=20;	zoomInSprite.addChild(zoomIn);	zoomInSprite.x=10;	zoomInSprite.y=5;	zoom_container.addChild(zoomInSprite);		var zoomOutSprite = new Sprite();	zoomOut.height=17;	zoomOut.width=20;	zoomOutSprite.addChild(zoomOut);	zoomOutSprite.x=10;	zoomOutSprite.y=82;	zoom_container.addChild(zoomOutSprite);			// add listeners to sprites containing images:	zoomInSprite.addEventListener(MouseEvent.MOUSE_DOWN, runZoomIn, false, 0, true);		zoomOutSprite.addEventListener(MouseEvent.MOUSE_DOWN, runZoomOut, false, 0, true);		zoomSlider =new DiscreteVerticalSlider(50,3, false);		zoomSlider.x=8;	zoomSlider.y=27;	zoom_container.addChild(zoomSlider);		zoomSlider.setKnobPos(3);	zoomSlider.addEventListener(DiscreteVerticalSlider.SLIDER_CHANGE, ZoomChange);						  						zoomInSprite.addEventListener(MouseEvent.ROLL_OVER, zoomSlider.knobMouseover, false, 0, true);	zoomInSprite.addEventListener(MouseEvent.ROLL_OUT, zoomSlider.knobMouseout, false, 0, true);			zoomOutSprite.addEventListener(MouseEvent.ROLL_OVER, zoomSlider.knobMouseover, false, 0, true);	zoomOutSprite.addEventListener(MouseEvent.ROLL_OUT, zoomSlider.knobMouseout, false, 0, true);						return zoom_container;}//function showChange(e:Event): void {//	trace("new slider position: " + String(zoomSlider.getKnobPos()) );//}private function runZoomIn(e:MouseEvent):void {	zoomSlider.decreaseKnobPos()}private function runZoomOut(e:MouseEvent):void {	zoomSlider.increaseKnobPos()}function ZoomChange(e:Event):void {    var newzoom:int = 7 - zoomSlider.getKnobPos();    trace("new zoom is " + newzoom);	if (newzoom != zoomlevel) {		zoomlevel=newzoom;		initialize_circles();		map.setZoom(newzoom);		setScoreBoard();				if (newzoom < 6) {			map.setMapType(nocitylabelsstyle);			if (newzoom < 5) {				overlay_1.show();				overlay_0.show();			} else {				overlay_1.hide();				overlay_0.hide();			}				} else {			map.setMapType(hascitylabelsstyle);			overlay_1.hide();			overlay_0.hide();		}	}     }private function drawTimeControl():Sprite {		var tcSprite:Sprite = new Sprite();	var sliderLen:Number=490;		tcSprite.graphics.lineStyle(2,0x999999);	tcSprite.graphics.beginFill(0xFFFFFF,1);	tcSprite.graphics.drawRoundRect(1, 0, 598, 55, 10);	tcSprite.graphics.endFill();		tcSprite.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {		ro.hide();		hidecircles();	});		var shadow:DropShadowFilter = new DropShadowFilter(); 	shadow.distance = 7; 	shadow.angle = 45; 	shadow.alpha = 0.3;		tcSprite.filters=[shadow];	play1.height = 37;	play1.width = 37; 	stop1.height = 37;	stop1.height = 37;	controlsprite.addChild(play1);	controlsprite.x = 9;		controlsprite.y = 9;	controlsprite.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {		controlclick()	}, false, 0, false);	controlsprite.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {		controlmouseover()	}, false, 0, false);	controlsprite.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {		controlmouseout()	}, false, 0, false);		tcSprite.addChild(controlsprite);		 	yearTimer=new DiscreteHorizontalSlider(sliderLen,28, 1981, true);	tcSprite.addChild(yearTimer);	yearTimer.x=62;	yearTimer.y=2;	yearTimer.setKnobPos(current_year);	yearTimer.addEventListener(DiscreteHorizontalSlider.SLIDER_CHANGE, updateYear);			return tcSprite;}function updateYear(e:Event): void {	var newYear:int = yearTimer.getKnobPos();	trace("new slider position: " + String(newYear) );	current_year = newYear;	redraw();	setScoreBoard();}function redraw():void {	overlayholder.removeChild(ref);	recalculate_latlng_pixels();	drawStuff();	init_rollover_circle();}private function controlclick():void {	trace("Controls clicked ");	if (playstate==0) {		controlsprite.removeChild(play1);		controlsprite.addChild(stop1);		playstate=1;		myTimer = new Timer(300, 29);		myTimer.addEventListener("timer", timerHandler);		myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);		yearTimer.setKnobPos(current_year);		//current_year = 1981;		setScoreBoard();		yeartimer = current_year+1;				yearTimer.setDragging();		dispatchEvent(new TimerEvent(Event.INIT));		myTimer.start();					} else {		controlsprite.removeChild(stop1);		controlsprite.addChild(play1);		playstate=0;		myTimer.stop();		yearTimer.setNormal();	}}public function timerHandler(event:TimerEvent):void {	trace("timerHandler: " + yeartimer);	if (yeartimer == 2010) {		yeartimer = 1981;	}	yearTimer.setKnobPos(yeartimer);	var newYear:int = yeartimer;	trace("new slider position: " + String(newYear) );	current_year = newYear;	redraw();	hittest(lastPoint, true);	//trace("Re-running hit test on: " + String(lastPoint));	yeartimer++;	setScoreBoard();}public function timerCompleteHandler(event:TimerEvent):void {	trace("timer is complete");	controlsprite.removeChild(stop1);	controlsprite.addChild(play1);	playstate=0;		yearTimer.setNormal();		}public function controlmouseover():void {	//Mouse.cursor="button";	controlsprite.filters = [glowFilter1];}public function controlmouseout():void {	//Mouse.cursor="arrow";	controlsprite.filters = [];}	private function getBitmapFilter(color:Number):BitmapFilter {	var alpha:Number = 0.4;	var blurX:Number = 15;	var blurY:Number = 15;	var strength:Number = 4;	var inner:Boolean = false;	var knockout:Boolean = false;	var quality:Number = BitmapFilterQuality.HIGH;	return new GlowFilter(color,						  alpha,						  blurX,						  blurY,						  strength,						  quality,						  inner,						  knockout);}public function countYearlyPop():int {	var yearlytot:int = 0;	var cur_year_index:int = 36-current_year+1981;	var l:int = result.length;	for (var i:int=0; i<l; i++) {		yearlytot = yearlytot + int(result[i][cur_year_index]);		//trace("... " + String(i) + " " + String(result[i][cur_year_index]));	}	return yearlytot;}public function setScoreBoard():void {	while(scoreboardSprite.numChildren > 0){        scoreboardSprite.removeChildAt(0);    }	trace("set prisons to: " + String(int(points_pixels.length)));				var size1:int = 35;	var size2:int = 200;			var bm1:Bitmap = getbitmapfromindex(getcircleradius(size1));	var bm2:Bitmap = getbitmapfromindex(getcircleradius(size2));		var sb:Sprite = maputils.getScoreboard(700, 50, current_year, int(points_pixels.length), countYearlyPop(), [bm1, bm2], [size1, size2]);	sb.y = 0;	scoreboardSprite.addChild(sb);}private function getbitmapfromindex(thissize:int) {	var bd:BitmapData = new BitmapData(2*thissize+2*line_width, 2*thissize+2*line_width, true, 0x00FFFFFF);	var ap:Point = new Point(0,0);	var copyrect:Rectangle = new Rectangle(0,0,2*thissize+2*line_width,2*thissize+2*line_width);			//var c:Point= new Point(a.x-size-line_width, a.y-size-line_width);			//trace("Trying to draw " + String(k) +" with size: " + size) ;	bd.copyPixels(circles_array[thissize], copyrect, ap , circles_alpha_array[thissize], ap, true);   		var bm:Bitmap = new Bitmap(bd);	bm.width = 2*thissize+2*line_width;	bm.height = 2*thissize+2*line_width;	return bm;}function drawBox(width:Number, height:Number, color:Number):Sprite {			// Call our function to set it all up right!			var box:Sprite = new Sprite();			box.graphics.beginFill(color);			box.graphics.drawRect(0, 0, width, height);			box.graphics.endFill();			return box;		}} // end of class} // end of package