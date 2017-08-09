#################################### Begin Cargo.nas ################################################

#possibly replace key binding xml entries in airplane/airplane-set.xml
#as is, to jankey
keyHandler = func {
	#Ctrl-O = Auto Attach CargoContainer
	if ( getprop( "devices/status/keyboard/ctrl") ){
		if( getprop("devices/status/keyboard/event/key") == 15 ){
			setprop("sim/model/cargo-auto-hook", 1);
		}
	}
	#Shift-O = Attach CargoContainer
	if ( getprop( "devices/status/keyboard/shift") ){
		if( getprop("devices/status/keyboard/event/key") == 79 ){
			setprop("sim/model/cargo-hook", 1);
		}
	}
	#o = Release CargoContainer
	if( getprop("devices/status/keyboard/event/key") == 111 ){
		setprop("controls/cargo-release", 1);
	}
	#settimer( func { timer() } , .5 );
} 
#keyHandler();
#end

################################# properties for towrope #######################################
props.Node.new({ "sim/hitches/aerotow/rope/exist":0 });
props.globals.initNode("sim/hitches/aerotow/rope/exist", 0, "DOUBLE" );
props.Node.new({ "sim/hitches/aerotow/rope/model_id":0 });
props.globals.initNode("sim/hitches/aerotow/rope/model_id", -1, "INT" );
props.Node.new({ "sim/hitches/aerotow/rope/path_to_model":0 });
props.globals.initNode("sim/hitches/aerotow/rope/path_to_model", "Aircraft/AirCrane/Models/ropes.xml", "STRING" );
props.Node.new({ "sim/hitches/aerotow/rope/rope-diameter-mm":0 });
props.globals.initNode("sim/hitches/aerotow/rope/rope-diameter-mm", 60, "INT" );
#tow/length in meters
props.Node.new({ "sim/hitches/aerotow/tow/length":0 });
props.globals.initNode("sim/hitches/aerotow/tow/length", 98, "INT" );
	
################################# properties for hitches #######################################
# Cargo Docked
# 	shippingContainer.ac
#		x-m=-2.5
#		y-m=0
#		z-m=-3.25
#	shippingContainerBig.ac
#		x-m=-2.5
#		y-m=0
#		z-m=-3.85
# 	shippingContainerHuge.ac
#		x-m=-1.5
#		y-m=0
#		z-m=-4.65
# 	shippingContainerWide.ac
#		x-m=-1.25
#		y-m=0
#		z-m=-4
# Cargo Hanging
#	x-m=2.5
#	y-m=0
#	z-m=-30
props.Node.new({ "sim/hitches/aerotow/local-pos-x":0 });
props.globals.initNode("sim/hitches/aerotow/local-pos-x", 0, "DOUBLE" );
props.Node.new({ "sim/hitches/aerotow/local-pos-y":0 });
props.globals.initNode("sim/hitches/aerotow/local-pos-y", 0, "DOUBLE" );
props.Node.new({ "sim/hitches/aerotow/local-pos-z":0 });
props.globals.initNode("sim/hitches/aerotow/local-pos-z", 0, "DOUBLE" );

props.Node.new({ "ai/models/cargo/sim/hitches/aerotow/local-pos-x":0 });
props.globals.initNode("ai/models/cargo/sim/hitches/aerotow/local-pos-x", 2.5, "DOUBLE" );
props.Node.new({ "ai/models/cargo/sim/hitches/aerotow/local-pos-y":0 });
props.globals.initNode("ai/models/cargo/sim/hitches/aerotow/local-pos-y", 0, "DOUBLE" );
props.Node.new({ "ai/models/cargo/sim/hitches/aerotow/local-pos-z":0 });
props.globals.initNode("ai/models/cargo/sim/hitches/aerotow/local-pos-z", -3.85, "DOUBLE" );
props.Node.new({ "ai/models/cargo/sim/hitches/aerotow/tow/dist":0 });
props.globals.initNode("ai/models/cargo/sim/hitches/aerotow/tow/dist", -1, "DOUBLE" );

################################# properties for cargo control #######################################	
props.Node.new({ "controls/hook-assist":0 });
props.globals.initNode("controls/hook-assist", 0, "BOOL" );
props.Node.new({ "controls/cargo-release":0 });
props.globals.initNode("controls/cargo-release", 0, "BOOL" );
props.Node.new({ "controls/cargo-realtime":0 });
props.globals.initNode("controls/cargo-realtime", 0, "BOOL" );
props.Node.new({ "sim/model/cargo-hook":0, "sim/model/cargo-auto-hook":0, "sim/model/cargo-on-hook":0 });
props.globals.initNode("sim/model/cargo-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-auto-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-on-hook", 0, "BOOL" );
props.Node.new({ "sim/submodels/serviceable":1 });
props.globals.initNode("sim/submodels/serviceable", 1, "BOOL" );

var cargo_menuNum = -1; #set this to -1 initially and then the FG menu number when it is assigned
####################################################################################
# Add GUI menubar items
# Credit to Wildfire and Bombable codebase 
var init_towCargo_dialog = func () {
#print("In cargo gui!");
    #Set cargo_menuNum to -1 at initialization time.  
	#On reinit & some other times, this routine will be called again.
	#So if cargo_menuNum != -1 we know not to seek out another new menu number
	#Without this check, we'd get a new Cargo menu added each time FG reinits or re-positions. 
	if (cargo_menuNum==nil or cargo_menuNum==-1) {
		#find the next open menu number
		cargo_menuNum=97; #the default
		for (var i=0;i<300;i+=1) {
			p=props.globals.getNode("/sim/menubar/default/menu["~i~"]");
			if ( typeof(p) == "nil" ) {
				cargo_menuNum=i;
				break;
			}   
		}
	} 
	
	#create GUI menubar items
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/enabled", 1).setBoolValue(1);
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/label", 1).setValue("CargoTow");
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item/enabled", 1).setBoolValue(1);
	
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item/label", 1).setValue("RealTime " ~ props.globals.getNode( "controls/cargo-realtime").getBoolValue());
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item/binding/command", 1).setValue("nasal");
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item/binding/script", 1).setValue(
		'props.globals.getNode("controls/cargo-realtime" ).setBoolValue(!props.globals.getNode("controls/cargo-realtime" ).getBoolValue()); 
		props.globals.getNode ("/sim/menubar/default/menu['~cargo_menuNum~']/item/label", 1).setValue("RealTime " ~ props.globals.getNode( "controls/cargo-realtime").getBoolValue()); 
		fgcommand ("gui-redraw");'
		);
	
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item[1]/label", 1).setValue("Hook Assist");
    props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item[1]/binding/command", 1).setValue("nasal");
	props.globals.getNode ("/sim/menubar/default/menu["~cargo_menuNum~"]/item[1]/binding/script", 1).setValue('props.globals.getNode("controls/hook-assist").setBoolValue(!props.globals.getNode("controls/hook-assist").getBoolValue())');
   	
	fgcommand ("gui-redraw");
				
}

var dlg = gui.Dialog.new("/sim/gui/dialogs/hookAltitude/dialog", "Aircraft/AirCrane/Dialogs/hookAltitude.xml");
var AircraftCargo = {};
##############################################################################
AircraftCargo.new = func {
#print("In cargo new!");
  var obj = {};
  
  obj.parents = [AircraftCargo];
  obj.hookNode = props.globals.getNode( "sim/model/cargo-hook", 1 );
  obj.autoHookNode = props.globals.getNode( "sim/model/cargo-auto-hook", 1 );
  obj.onHookNode = props.globals.getNode( "sim/model/cargo-on-hook", 1 );
  #obj.speedbrakeNode = props.globals.getNode( "controls/flight/speedbrake" );
  obj.releaseNode = props.globals.getNode( "controls/cargo-release", 1 );
  obj.lonNode = props.globals.getNode("/position/longitude-deg", 1);
  obj.latNode = props.globals.getNode("/position/latitude-deg", 1);
  obj.altNode = props.globals.getNode( "/position/altitude-agl-ft", 1 );
  obj.altftNode = props.globals.getNode("/position/altitude-ft", 1);
  obj.hedNode = props.globals.getNode( "/orientation/heading-deg", 1 );
  obj.hookAssist = props.globals.getNode( "controls/hook-assist", 1 );

  # realTime true = real time ai object updating and rope drawing
  # (currently to much teleporting)
  obj.realTime = props.globals.getNode( "controls/cargo-realtime", 1 );
  obj.aiAlt=0;
  
  obj.cargoParent = "";
  obj.cargoName = "";
  obj.hookDistance = 1e-8;
  #obj.hookDistance = 1e-9;
  #hardDock (meters)
  obj.hookHeight = 15;
  #ropeTow (meters)
  #obj.hookHeight = 110;
  obj.hooked = 0;
  obj.cargoFalling = 0;
  obj.minDist = 999;
    
  # needs adjusting for best performance
  obj.interval = .025;

  #obj.timer();
  
  return obj;
}

##############################################################################
# main loop
AircraftCargo.timer = func {
#print("In cargo timer!");
	#print(me.altNode.getValue()~" "~me.altftNode.getValue());
	if(me.onHookNode.getValue() == 0 and (me.altNode.getValue() < me.hookHeight) and me.cargoFalling == 0) {
    #gui.popupTip("In Ranging", 1);
		foreach(var cargoN; props.globals.getNode( "/ai/models", 1).getChildren( "aircraft" )) {
			if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
				if(me.hooked == 0) {
					var dlat = cargoN.getNode( "position/latitude-deg" ).getValue() - me.latNode.getValue();
					var dlon = cargoN.getNode( "position/longitude-deg" ).getValue() - me.lonNode.getValue();
					var dist = dlat * dlat + dlon*dlon;
					if(dist < me.minDist) {
						me.minDist = dist;
					}
					#hardDock
					if(dist <= me.hookDistance) { 
					#towRope in meters 103
					#if(dist <= me.hookDistance and me.altNode.getValue() > 103) {
						gui.popupTip("Cargo in Range", 1);
						#print( "Cargo in Range\n" );
						if (me.hookNode.getValue() == 1 or me.autoHookNode.getValue() == 1) {
							me.hooked = 1;
							#me.speedbrakeNode.setBoolValue( 1 );
							me.cargoParent = cargoN.getNode( "callsign" ).getParent().getName() ~ "[" ~ cargoN.getNode( "callsign" ).getParent().getIndex() ~ "]";
							me.cargoName = cargoN.getNode( "callsign" ).getValue();
							if (me.realTime.getValue() == 0) { #submodel ai and rope update
								me.onHookNode.setBoolValue( 1 );
								setprop("sim/model/"~me.cargoName~"-onhook", 1);
								cargoN.getNode( "position/altitude-ft" ).setDoubleValue(-999);
							}
						} 
					}
				}
			}
		}
	}
  if (me.hooked == 1) {
		gui.popupTip("Cargo in Tow", 1);
		#me.realTime only used for RealTime AI Cargo towing (as of now, to slow - teleporting)
		if (me.realTime.getValue() == 1) {
			me.aiAlt = props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/altitude-ft" ).getValue();
			var elev_m = geo.elevation( props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/latitude-deg" ).getValue(), props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/longitude-deg" ).getValue());		
			if ( (me.altftNode.getValue() - props.globals.getNode("sim/hitches/aerotow/tow/length").getValue()) > (elev_m * 3.2808) ) {
				me.aiAlt = (me.altftNode.getValue() - props.globals.getNode("sim/hitches/aerotow/tow/length").getValue());
				props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/altitude-ft" ).setDoubleValue(me.aiAlt);	
			}
			props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/latitude-deg" ).setDoubleValue(me.latNode.getValue());
			props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/longitude-deg" ).setDoubleValue(me.lonNode.getValue());
			#cargoN.getNode( "orientation/true-heading-deg" ).setDoubleValue(me.hedNode.getValue());
		}
		#me.realTime only used for realTime AI Cargo towing
		if( me.releaseNode.getValue() == 1 and (me.onHookNode.getValue() == 1 or me.realTime.getValue())) {
			me.onHookNode.setBoolValue( 0 );
			me.releaseNode.setBoolValue( 0 );
			me.hooked = 0;
			#me.speedbrakeNode.setBoolValue( 0 );
			me.hookNode.setBoolValue( 0 );
			me.cargoFalling = 1;
			gui.popupTip("Cargo Released", 3);
			setprop("sim/model/"~me.cargoName~"-onhook", 0);
			setprop("controls/release-"~me.cargoName, 1);
		}
	} else {
		if (me.autoHookNode.getValue() == 1) {
			gui.popupTip("Auto Hook Engaged", 1);
		}
		#release auto.hook by pressing hook
		if ( me.hookNode.getValue() == 1 and me.autoHookNode.getValue() == 1) {
			me.autoHookNode.setBoolValue( 0 );
			me.hookNode.setBoolValue( 0 );
		}
	}
	if (me.cargoFalling == 1) {
    gui.popupTip("Cargo falling", 1);
		props.globals.getNode("/ai/models/" ~ me.cargoParent ~ "/position/altitude-ft").setDoubleValue(-999);
		if (getprop("ai/models/ballistic/impact")){
			gui.popupTip("Made Impact", 1);
			props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/position/latitude-deg" ).setDoubleValue(getprop("ai/models/ballistic/impact/latitude-deg"));
			props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/position/longitude-deg" ).setDoubleValue(getprop("ai/models/ballistic/impact/longitude-deg"));
			props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/position/altitude-ft" ).setDoubleValue((getprop("ai/models/ballistic/impact/elevation-m")* 3.2808));
			props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/orientation/true-heading-deg" ).setDoubleValue(getprop("orientation/heading-deg"));
			props.globals.getNode("ai/models/ballistic/").removeChildren();
			setprop("controls/release-"~me.cargoName, 0);
      me.cargoName="";
			me.cargoFalling=0;
		} else 
			if (me.realTime.getValue() == 1) {
				props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/position/latitude-deg" ).setDoubleValue(getprop("position/latitude-deg"));
				props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/position/longitude-deg" ).setDoubleValue(getprop("position/longitude-deg"));
				var elev_m = geo.elevation(getprop("/position/latitude-deg"), getprop("/position/longitude-deg"));
				props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/position/altitude-ft" ).setDoubleValue(elev_m * 3.2808);
				props.globals.getNode( "/ai/models/" ~ me.cargoParent ~ "/orientation/true-heading-deg" ).setDoubleValue(getprop("orientation/heading-deg"));
				setprop("controls/release-"~me.cargoName, 0);
        me.cargoName="";
				me.cargoFalling=0;
			}
	}	
	#comment out for hardDock
	#aerotow(me.realTime.getValue(), me.hooked, me.cargoParent, me.aiAlt);
	
	if (me.hookAssist.getValue()) dlg.open();
	else dlg.close();
	
	settimer( func { me.timer() } , me.interval );
}

var aircraftCargo = nil;
##############################################################################
var init_cargo = func {
#print("In cargo init!");
	#########################################################################
	# Use your "first" cargo callsign as trigger for aborting Cargo Towing.
	# If no forced exit and no cargo you will get nasal errors.
	############################ End Forced Exit ############################
	aircraftCargo = AircraftCargo.new();
    var ct=0;
	foreach(var cargoN; props.globals.getNode( "/ai/models", 1 ).getChildren( "aircraft" )){
		if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
			ct+=.001;
			
			setprop("sim/model/"~cargoN.getNode("callsign").getValue()~"-onhook", 0);
			setprop("controls/release-"~cargoN.getNode("callsign").getValue(), 0);
			#props.Node.new({ "sim/model/"~cargoN.getNode("callsign").getValue()~"-onhook":0 });
			#props.globals.initNode("sim/model/"~cargoN.getNode("callsign").getValue()~"-onhook", 0, "BOOL" );

			var factor = ct + rand() * .001;

			var heading = getprop("orientation/heading-deg")+90;
			var x = math.cos(heading*0.0174533);
			var y = math.sin(heading*0.0174533);
			y = y * -1;
			x = x * factor;
			y = y * factor;

			cargoN.getNode( "position/latitude-deg" ).setDoubleValue(getprop("position/latitude-deg")+y);
			cargoN.getNode( "position/longitude-deg" ).setDoubleValue(getprop("position/longitude-deg")+x);
			cargoN.getNode( "orientation/true-heading-deg" ).setDoubleValue(rand()*360);

			var elev_m = geo.elevation(cargoN.getNode( "position/latitude-deg" ).getValue(), cargoN.getNode( "position/longitude-deg" ).getValue());
		    cargoN.getNode( "position/altitude-ft" ).setDoubleValue(elev_m * 3.2808);
		    print( "Cargo Created:" ~ 
		        cargoN.getNode( "callsign" ).getValue() ~ "\n" ~ 
		        cargoN.getNode( "position/latitude-deg" ).getValue() ~ "/" ~ 
		        cargoN.getNode( "position/longitude-deg" ).getValue() ~ "\nElev-ft:" ~ 
		        cargoN.getNode( "position/altitude-ft" ).getValue() ~ "\nHead:" ~ 
		        cargoN.getNode( "orientation/true-heading-deg" ).getValue() ~ "\n");
		}
	}
	#gui.fpsDisplay(1);
	if (!ct) {
		print("No AI Cargo, exiting cargo.nas!");
    return;
  }
	else {
		init_towCargo_dialog();
    aircraftCargo.timer();
  }
}

setlistener("/sim/signals/fdm-initialized", init_cargo );

var FT2M = 0.30480;
var M2FT = 1 / FT2M;
# ########################################################################################
#  									aerotow function

var aerotow = func (realTime, hooked, cargo, ai_alt){

		createTowrope("aerotow");
	
	############################### my hitch position ###################################
	myPosition = geo.aircraft_position();

	var my_pitch_deg = getprop("orientation/pitch-deg");
	var my_roll_deg  = getprop("orientation/roll-deg");
	var my_head_deg  = getprop("orientation/heading-deg");
	
	# hook coordinates in Yasim-system (x-> nose / y -> left wing / z -> up)
	var x = getprop("sim/hitches/aerotow/local-pos-x");
	var y = getprop("sim/hitches/aerotow/local-pos-y");
	var z = getprop("sim/hitches/aerotow/local-pos-z");
	
	#roll factor=1.0
	#x=-1
	#y=0
	#z=-.1
	#side-slip-deg factor=1.0
	#x=1
	#y=0
	#z=0
	#pitch-deg factor=1.0
	#x=0
	#y=1
	#z=-.1
	
	var alpha_deg = my_roll_deg * (1.);   # roll clockwise (looking in x-direction) := +
	var beta_deg  = my_pitch_deg * (-1.); # pitch clockwise (looking in y-direction) := -
	
	# transform hook coordinates
	var Xn = PointRotate3D(x:x,y:y,z:z,xr:0.,yr:0.,zr:0.,alpha_deg:alpha_deg,beta_deg:beta_deg,gamma_deg:0.);

	var install_distance_m = Xn[0]; # in front of ref-point of glider
	var install_side_m     = Xn[1];
	var install_alt_m      = Xn[2];  

	var myHitch_pos    = myPosition.apply_course_distance( my_head_deg , install_distance_m ); 
	var myHitch_pos    = myPosition.apply_course_distance( my_head_deg - 90. , install_side_m );   
	myHitch_pos.set_alt(myPosition.alt() + install_alt_m); 
	
	###############################  my new ai hitch position  ###########################
	
	var aiPosition = geo.aircraft_position();
	
	if (realTime == 1 and hooked==1) {		
		var ai_lat = props.globals.getNode("/ai/models/" ~ cargo ~ "/position/latitude-deg").getValue();
		var ai_lon = props.globals.getNode("/ai/models/" ~ cargo ~ "/position/longitude-deg").getValue();
		#var ai_alt = props.globals.getNode("/ai/models/" ~ cargo ~ "/position/altitude-ft").getValue();
		aiPosition = geo.Coord.set_latlon( ai_lat, ai_lon, ai_alt * FT2M );
	}
	
	var ai_pitch_deg = getprop("orientation/pitch-deg");
	var ai_roll_deg  = getprop("orientation/roll-deg");
	var ai_head_deg  = getprop("orientation/heading-deg");
	
	# hook coordinates in Yasim-system (x-> nose / y -> left wing / z -> up)
	var aiHitchX = props.globals.getNode("/ai/models/cargo/sim/hitches/aerotow/local-pos-x").getValue();
	var aiHitchY = props.globals.getNode("/ai/models/cargo/sim/hitches/aerotow/local-pos-y").getValue();
	var aiHitchZ = props.globals.getNode("/ai/models/cargo/sim/hitches/aerotow/local-pos-z").getValue();

	var alpha_deg = 0;
	var beta_deg  = 0;
		
	#if (hooked==1) {	
	#	alpha_deg = ai_roll_deg * (1.);   # roll clockwise (looking in x-direction) := +
	#	beta_deg  = ai_pitch_deg * (-1.); # pitch clockwise (looking in y-direction) := -
	#} 
	
	# transform hook coordinates
	var Xn = PointRotate3D(x:aiHitchX,y:aiHitchY,z:aiHitchZ,xr:0.,yr:0.,zr:0.,alpha_deg:alpha_deg,beta_deg:beta_deg,gamma_deg:0.);
	
	var install_distance_m = Xn[0]; # in front of ref-point of glider
	var install_side_m     = Xn[1];
	var install_alt_m      = Xn[2];  

	var aiHitch_pos    = aiPosition.apply_course_distance( ai_head_deg , install_distance_m ); 
	var aiHitch_pos    = aiPosition.apply_course_distance( ai_head_deg - 90. , install_side_m );   
	aiHitch_pos.set_alt(aiPosition.alt() + install_alt_m); 
	
	#############################  distance between hitches  ####################################
	    
	var distance = (myHitch_pos.direct_distance_to(aiHitch_pos));      # distance to plane in meter
	var aiHitchheadto = (myHitch_pos.course_to(aiHitch_pos));
	var height = myHitch_pos.alt() - aiHitch_pos.alt();

	var aiHitchpitchto = -math.asin((math.round(myHitch_pos.alt()-aiHitch_pos.alt()))/math.round(distance)) / 0.01745;
	
	#print("  pitch: ", ~ aiHitchpitchto);

	# update position of rope
	setprop("ai/models/aerotowrope/position/latitude-deg", myHitch_pos.lat());
	setprop("ai/models/aerotowrope/position/longitude-deg", myHitch_pos.lon());
	setprop("ai/models/aerotowrope/position/altitude-ft", myHitch_pos.alt() * M2FT);
	#print("ai_lat,lon,alt",myHitch_pos.lat(),"   ",myHitch_pos.lon(),"   ",myHitch_pos.alt() );

	# update pitch and heading of rope
	setprop("ai/models/aerotowrope/orientation/true-heading-deg", aiHitchheadto);
	setprop("ai/models/aerotowrope/orientation/pitch-deg", aiHitchpitchto);

	# update length of rope
	setprop("sim/hitches/aerotow/tow/dist", distance);
}
      

# ###############################################################################################
#                                             create towrope
var createTowrope = func (device){

	#create the towrope in the model property tree	
	if ( getprop("sim/hitches/" ~ device ~ "/rope/exist") == 0 ) {   # does the towrope exist?

	    # get the next free model id
	    var freeModelid = getFreeModelID();

	    props.globals.getNode("sim/hitches/" ~ device ~ "/rope/model_id").setIntValue(freeModelid);
	    props.globals.getNode("sim/hitches/" ~ device ~ "/rope/exist").setBoolValue(1);
	    
	    var towrope_ai  = props.globals.getNode("ai/models/" ~ device ~ "rope", 1);
	    var towrope_mod  = props.globals.getNode("models", 1);
	        
	    towrope_ai.getNode("id", 1).setIntValue(4711);
	    towrope_ai.getNode("callsign", 1).setValue("towrope");
	    towrope_ai.getNode("valid", 1).setBoolValue(1);
	    towrope_ai.getNode("position/latitude-deg", 1).setValue(0.);
	    towrope_ai.getNode("position/longitude-deg", 1).setValue(0.);
	    towrope_ai.getNode("position/altitude-ft", 1).setValue(0.);
	    towrope_ai.getNode("orientation/true-heading-deg", 1).setValue(0.);
	    towrope_ai.getNode("orientation/pitch-deg", 1).setValue(0.);
	    towrope_ai.getNode("orientation/roll-deg", 1).setValue(0.);

	    towrope_mod.model = towrope_mod.getChild("model", freeModelid, 1);
	    towrope_mod.model.getNode("path", 1).setValue(getprop("sim/hitches/" ~ device ~ "/rope/path_to_model") );
	    towrope_mod.model.getNode("longitude-deg-prop", 1).setValue("ai/models/" ~ device ~ "rope/position/longitude-deg");
	    towrope_mod.model.getNode("latitude-deg-prop", 1).setValue("ai/models/" ~ device ~ "rope/position/latitude-deg");
	    towrope_mod.model.getNode("elevation-ft-prop", 1).setValue("ai/models/" ~ device ~ "rope/position/altitude-ft");
	    towrope_mod.model.getNode("heading-deg-prop", 1).setValue("ai/models/" ~ device ~ "rope/orientation/true-heading-deg");
	    towrope_mod.model.getNode("roll-deg-prop", 1).setValue("ai/models/" ~ device ~ "rope/orientation/roll-deg");
	    towrope_mod.model.getNode("pitch-deg-prop", 1).setValue("ai/models/" ~ device ~ "rope/orientation/pitch-deg");
	    towrope_mod.model.getNode("load", 1).remove();
	}
}


# ######################################################################################################################
#                                     get the next free id of "models/model" members        
var getFreeModelID = func {
  #print("getFreeModelID");
  var modelid = 0;   # next unused id  
  modelobjects = props.globals.getNode("models", 1).getChildren(); 
  foreach ( var member; modelobjects ) { 
    if ( (var c = member.getIndex()) != nil) { 
      modelid = c + 1;
    }
  }
  #print("modelid=",modelid);    
  return(modelid);
}

# ######################################################################################################################
#                                                      point transformation  
var PointRotate3D = func (x,y,z,xr,yr,zr,alpha_deg,beta_deg,gamma_deg){

  # ---------------------------------------------------------------------------------
  #   rotates point (x,y,z) about all 3 cartesian axis
  #   center of rotation (xr,yr,zr)
  #   angle of rotation about x-axis = alpha
  #   angle of rotation about y-axis = beta
  #   angle of rotation about z-axis = gamma
  #   delivers new point coordinates (x_new,y_new,z_new)
  # ---------------------------------------------------------------------------------
  #
  #
  # Definitions:
  # ---------------- 
  #
  # x        y           z     
  # alpha    beta        gamma   
  #                       
  #                        
  #       z                
  #       |  y             
  #       | / 	         
  #       |/ 	         
  #       ----->x	         
  #		         
  #----------------------------------------------------------------------------------  

  # Transformation in rotation-system X_rel = X-Xr = (x-xr, y-yr, z-zr)
  var x_rel = x-xr;
  var y_rel = y-yr;  
  var z_rel = z-zr;  

  # Trigonometry
  var deg2rad = math.pi / 180.;   

  var alpha_rad	   = deg2rad * alpha_deg;
  var beta_rad	   = deg2rad * beta_deg;
  var gamma_rad	   = deg2rad * gamma_deg;

  var sin_alpha = math.sin(alpha_rad);
  var cos_alpha = math.cos(alpha_rad);

  var sin_beta  = math.sin(beta_rad);
  var cos_beta  = math.cos(beta_rad);

  var sin_gamma = math.sin(gamma_rad);
  var cos_gamma = math.cos(gamma_rad);

  # Matrices 
  #
  # Rotate about x-axis Rx(alpha) 
  #
  #		Rx11 Rx12 Rx13      1	  0	       0
  # Rx(alpha)=  Rx21 Rx22 Rx23   =  0  cos(alpha)  -sin(alpha)
  #		Rx31 Rx32 Rx33      0  sin(alpha)   cos(alpha)
  #
  var Rx11 = 1.;
  var Rx12 = 0.;
  var Rx13 = 0.;
  var Rx21 = 0.;
  var Rx22 = cos_alpha;
  var Rx23 = - sin_alpha;
  var Rx31 = 0.;
  var Rx32 = sin_alpha;
  var Rx33 = cos_alpha;
  #
  # Rotate about y-axis Ry(beta) 
  #
  #	       Ry11 Ry12 Ry13	   cos(beta)  0   sin(beta)   
  # Ry(beta)=  Ry21 Ry22 Ry23	=      0      1      0 
  #	       Ry31 Ry32 Ry33	  -sin(beta)  0   cos(beta)
  #
  var Ry11 = cos_beta;
  var Ry12 = 0.;
  var Ry13 = sin_beta;
  var Ry21 = 0.;
  var Ry22 = 1.;
  var Ry23 = 0.;
  var Ry31 = - sin_beta;
  var Ry32 = 0.;
  var Ry33 = cos_beta;
  #
  # Rotate about z-axis Rz(gamma) 
  #
  #	       Rz11 Rz12 Rz13	   cos(gamma)  -sin(gamma)  0  
  # Rz(gamma)= Rz21 Rz22 Rz23	=  sin(gamma)	cos(gamma)  0	
  #	       Rz31 Rz32 Rz33	       0	    0	    1
  #
  var Rz11 = cos_gamma;
  var Rz12 = - sin_gamma;
  var Rz13 = 0.;
  var Rz21 = sin_gamma;
  var Rz22 = cos_gamma;
  var Rz23 = 0.;
  var Rz31 = 0.;
  var Rz32 = 0.;
  var Rz33 = 1.; 
  #
  # First rotation about x-axis
  # X_x = Rx*X_rel
  var x_x = Rx11 * x_rel + Rx12 * y_rel + Rx13 * z_rel;
  var y_x = Rx21 * x_rel + Rx22 * y_rel + Rx23 * z_rel;
  var z_x = Rx31 * x_rel + Rx32 * y_rel + Rx33 * z_rel;  
  #
  # subsequent rotation about y-axis
  # X_xy = Ry*X_x
  var x_xy = Ry11 * x_x + Ry12 * y_x + Ry13 * z_x;
  var y_xy = Ry21 * x_x + Ry22 * y_x + Ry23 * z_x;
  var z_xy = Ry31 * x_x + Ry32 * y_x + Ry33 * z_x; 
  #
  # subsequent rotation about z-axis:
  # X_xyz = Rz*X_xy
  var x_xyz = Rz11 * x_xy + Rz12 * y_xy + Rz13 * z_xy;
  var y_xyz = Rz21 * x_xy + Rz22 * y_xy + Rz23 * z_xy;
  var z_xyz = Rz31 * x_xy + Rz32 * y_xy + Rz33 * z_xy;
  
  # Back transformation  X_rel = X-Xr = (x-xr, y-yr, z-zr)
  var xn = xr + x_xyz;
  var yn = yr + y_xyz;
  var zn = zr + z_xyz;
  
  var Xn = [xn,yn,zn];
  
  return Xn;
  
}
############################# End Cargo.nas #################################################