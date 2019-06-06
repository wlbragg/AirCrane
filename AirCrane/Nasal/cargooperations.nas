#################### inject cargo models into the scene ####################

var cargo1 = {};
var cargo2 = {};
var cargo3 = {};
var cargo4 = {};
var cargo5 = {};
var cargo6 = {};
var cargo7 = {};
var cargo8 = {};
var cargo9 = {};
var cargo10 = {};
var cargo11 = {};
var cargo12 = {};
var cargo13 = {};
var cargo14 = {};
var cargo15 = {};
var cargo16 = {};
var cargo17 = {};
var cargo18 = {};
var cargo19 = {};
var cargo20 = {};
var cargo21 = {};
var cargo22 = {};
var cargo23 = {};
var cargo24 = {};
var cargo25 = {};
var cargo26 = {};
var cargo27 = {};
var cargo28 = {};
var cargo29 = {};
var cargo30 = {};
var cargo31 = {};
var cargo32 = {};

setlistener("/sim/signals/fdm-initialized", func (n) {

  #set initial position of the cargo models out of site and out of range
  var lat = getprop("/position/latitude-deg")-.0002;
  var lon = getprop("/position/longitude-deg")-.0002;
  var alt = -999;

  #property tree location of cargo models
  var model_path = "Aircraft/AirCrane/Models/Cargo-Hauling/";

  #                            offset ft    cargoheight m     harnessheight m
  #container-big    -3.879 m = 12.72        2.66              6.10
  #cub-ground       -3.209 m = 10.53        1.83              5.98
  #ground-tank      -3.737 m = 12.26        2.42              6.44
  #ground-tank-lg   -5.884 m = 18.58        4.18              6.02
  #ground-tank-tall -4.976 m = 16.32        3.69              6.02
  #tank-stand       -3.562 m = 11.68        2.12              6.08
  #pine-tree        -3.334 m = 10.93        2.08              6.12
  #dump-truck       -6.937 m = 22.76        9.3              10.59
  #micro-relay      -7.257 m = 23.81        5.98              6.06
  #micro-wave       -8.101 m = 26.58        5.99              6.99
  #tower-sec-one   -14.053 m = 46.14       12.81              8.52
  #tower-sec-two   -14.129 m = 46.35       12.94              8.52
  #tower-sec-three -14.323 m = 46.99       13.06              8.52
  #tower-sec-four  -14.416 m = 47.29       13.24              8.52
  #tower-sec-five  -14.436 m = 47.36       13.22              8.52
  #tower-sec-six   -14.435 m = 47.35       13.22              8.52
  #tower-sec-seven -14.469 m = 47.47       13.25              8.52
  #tower-radio    -162.331 m =532.58      173.63              8.52
  #radio-tower-sec -26.058 m = 85.49       24.84             16.75
  #mobile-pod       -4.059 m = 13.32        2.86             14.39

  # there are three types of cargo depending on connection capability
  # 1) long line only
  #     (stack = 0, offset = distance from blender 0 z to cargo bottom z), alt = alt-90)
  # 2) long line and hard docked
  #     (stack = 0, offset = distance from blender 0 z to cargo bottom z), alt = def of -999
  # 3) stackable
  #     (stack = position of object it can stack on)
  #     (can be either 1 or 2 connection type, but is implemented only when in long line) 
  #     TODO: limit stackable to on long line only

  #use height in feet or *3.28 for ground
  #use height in feet or *3.28 or drop height for connection to stack

  #inject new cargo models into the scene                           stack   drop         height                              
  #                     itemnum index name              location    index   height  weight      harness                 
  cargo1 =  place_model( "1",   0, "cub-ground",        model_path,  0,     0.0,    1200, 1.83, 5.98, lat, lon, alt,    0, 0, 0);
  cargo2 =  place_model( "2",   1, "container-big",     model_path,  3,     2.66,   1500, 2.66, 6.10, lat, lon, alt,    0, 0, 0);
  cargo3 =  place_model( "3",   2, "container-big",     model_path,  1,     2.66,   1000, 2.66, 6.10, lat, lon, alt,    0, 0, 0);
  cargo4 =  place_model( "4",   3, "container-big",     model_path,  2,     2.66,   5000, 2.66, 6.10, lat, lon, alt,    0, 0, 0);
  cargo5 =  place_model( "5",   4, "ground-tank",       model_path,  0,     0.0,    2000, 2.42, 6.44, lat, lon, alt,    0, 0, 0);
  cargo6 =  place_model( "6",   5, "ground-tank-lg",    model_path,  0,     0.0,    4200, 4.18, 6.02, lat, lon, alt-90, 0, 0, 0);
  cargo7 =  place_model( "7",   6, "ground-tank-tall",  model_path,  0,     0.0,    3000, 3.69, 6.02, lat, lon, alt-90, 0, 0, 0);
  cargo8 =  place_model( "8",   7, "tank-stand",        model_path,  0,     0.0,     250, 2.12, 6.08, lat, lon, alt,    0, 0, 0);
  cargo9 =  place_model( "9",   8, "pine-tree",         model_path, 13,     0.0,     150, 2.08, 6.12, lat, lon, alt,    0, 0, 0);
  cargo10 = place_model("10",   9, "pine-tree",         model_path, 13,     0.0,     150, 2.08, 6.12, lat, lon, alt,    0, 0, 0);
  cargo11 = place_model("11",   10, "pine-tree",        model_path, 13,     0.0,     150, 2.08, 6.12, lat, lon, alt,    0, 0, 0);
  cargo12 = place_model("12",   11, "pine-tree",        model_path, 13,     0.0,     150, 2.08, 6.12, lat, lon, alt,    0, 0, 0);
  cargo13 = place_model("13",   12, "pine-tree",        model_path, 13,     0.0,     150, 2.08, 6.12, lat, lon, alt,    0, 0, 0);
  cargo14 = place_model("14",   13, "dump-truck",       model_path,  0,      .5,   10000, 5.69,15.45, lat, lon, alt-90, 0, 0, 0);
  cargo15 = place_model("15",   14, "micro-relay",      model_path, 20,     0.0,     400, 5.98, 6.06, lat, lon, alt-90, 0, 0, 0);
  cargo16 = place_model("16",   15, "micro-wave",       model_path, 21,     0.0,     400, 5.99, 6.99, lat, lon, alt-90, 0, 0, 0);
  cargo17 = place_model("17",   16, "tower-sec-one",    model_path,  0,    12.81,   1400,12.81, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo18 = place_model("18",   17, "tower-sec-two",    model_path, 16,    12.94,   1300,12.94, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo19 = place_model("19",   18, "tower-sec-three",  model_path, 17,    13.06,   1200,13.06, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo20 = place_model("20",   19, "tower-sec-four",   model_path, 18,    13.24,   1100,13.24, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo21 = place_model("21",   20, "tower-sec-five",   model_path, 19,    13.22,   1000,13.22, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo22 = place_model("22",   21, "tower-sec-six",    model_path, 20,    13.22,    950,13.22, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo23 = place_model("23",   22, "tower-sec-seven",  model_path, 21,    13.25,    900,13.25, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo24 = place_model("24",   23, "tower-radio",      model_path,  0,     0.0,    5000,161,   8.52, lat, lon, alt-90, 0, 0, 0);
  cargo25 = place_model("25",   24, "radio-tower-sec",  model_path, 30,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo26 = place_model("26",   25, "radio-tower-sec",  model_path, 24,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo27 = place_model("27",   26, "radio-tower-sec",  model_path, 25,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo28 = place_model("28",   27, "radio-tower-sec",  model_path, 26,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo29 = place_model("29",   28, "radio-tower-sec",  model_path, 27,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo30 = place_model("30",   29, "radio-tower-sec",  model_path, 28,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo31 = place_model("31",   30, "radio-tower-sec",  model_path, 29,    24.84,    500,24.84, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo32 = place_model("32",   31, "mobile-pod",       model_path,  0,     0.0,    1200, 2.86,14.39, lat, lon, alt,    0, 0, 0);
  cargo33 = place_model("33",   32, "wind-tower-base",  model_path,  0,    14.96,    600,14.96, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo34 = place_model("34",   33, "wind-tower",       model_path, 32,    44.04,   1200,44.04, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo35 = place_model("35",   34, "wind-tower-gen",   model_path, 33,     4.90,   1200, 4.90, 8.52, lat, lon, alt-90, 0, 0, 0);
  cargo36 = place_model("36",   35, "wind-tower-hub",   model_path, 34,    37.83,   1200,60.91, 8.52, lat, lon, alt-90, 0, 0, 0);

  cargo_init();
});

#################### inject cargo models into the scene (helper) ####################

var place_model = func(number, position, desc, path, stack, drop, weight, height, harness, lat, lon, alt, heading, pitch, roll) {

  var m = props.globals.getNode("models", 1);
		  for (var i = 0; 1; i += 1)
			  if (m.getChild("model", i, 0) == nil)
				  break;
  var model = m.getChild("model", i, 1);

  setprop("/models/cargo/cargo["~position~"]/latitude-deg", lat);
  setprop("/models/cargo/cargo["~position~"]/longitude-deg", lon);
  setprop("/models/cargo/cargo["~position~"]/elevation-ft", alt);
  setprop("/models/cargo/cargo["~position~"]/heading-deg", heading);
  setprop("/models/cargo/cargo["~position~"]/pitch-deg", pitch);
  setprop("/models/cargo/cargo["~position~"]/roll-deg", roll);
  setprop("/models/cargo/cargo["~position~"]/callsign", "cargo"~number);
  setprop("/models/cargo/cargo["~position~"]/description", desc);
  setprop("/models/cargo/cargo["~position~"]/weight", weight);
  setprop("/models/cargo/cargo["~position~"]/height", height);
  setprop("/models/cargo/cargo["~position~"]/harness", harness);
  setprop("/models/cargo/cargo["~position~"]/stack", stack);
  setprop("/models/cargo/cargo["~position~"]/drop", drop);

  var cargomodel = props.globals.getNode("/models/cargo/cargo["~position~"]", 1);
  var latN = cargomodel.getNode("latitude-deg",1);
  var lonN = cargomodel.getNode("longitude-deg",1);
  var altN = cargomodel.getNode("elevation-ft",1);
  var headN = cargomodel.getNode("heading-deg",1);
  var pitchN = cargomodel.getNode("pitch-deg",1);
  var rollN = cargomodel.getNode("roll-deg",1);
  var callsignN = cargomodel.getNode("callsign",1);
  var descriptionN = cargomodel.getNode("description",1);
  var weightN = cargomodel.getNode("weight",1);
  var heightN = cargomodel.getNode("height",1);
  var harnessN = cargomodel.getNode("harness",1);
  var stackN = cargomodel.getNode("stack",1);
  var dropN = cargomodel.getNode("drop",1);

  model.getNode("path", 1).setValue(path~"cargo"~number~".xml");
  model.getNode("latitude-deg-prop", 1).setValue(latN.getPath());
  model.getNode("longitude-deg-prop", 1).setValue(lonN.getPath());
  model.getNode("elevation-ft-prop", 1).setValue(altN.getPath());
  model.getNode("heading-deg-prop", 1).setValue(headN.getPath());
  model.getNode("pitch-deg-prop", 1).setValue(pitchN.getPath());
  model.getNode("roll-deg-prop", 1).setValue(rollN.getPath());
  model.getNode("callsign-prop", 1).setValue(callsignN.getPath());
  model.getNode("description-prop", 1).setValue(descriptionN.getPath());
  model.getNode("weight-prop", 1).setValue(weightN.getPath());
  model.getNode("height-prop", 1).setValue(heightN.getPath());
  model.getNode("harness-prop", 1).setValue(harnessN.getPath());
  model.getNode("stack-prop", 1).setValue(stackN.getPath());
  model.getNode("drop-prop", 1).setValue(dropN.getPath());
  model.getNode("load", 1).remove();

  return model;
}

#################### cargo hauling ####################

props.Node.new({ "controls/hook-assist":0 });
props.globals.initNode("controls/hook-assist", 0, "BOOL" );
props.Node.new({ "controls/cargo-release":0 });
props.globals.initNode("controls/cargo-release", 0, "BOOL" );
props.Node.new({ "sim/cargo/cargo-hook":0, "sim/cargo/cargo-auto-hook":0, "sim/cargo/cargo-on-hook":0 });
props.globals.initNode("sim/cargo/cargo-hook", 0, "BOOL" );
props.globals.initNode("sim/cargo/cargo-auto-hook", 0, "BOOL" );
props.globals.initNode("sim/cargo/cargo-on-hook", 0, "BOOL" );

var AircraftCargo = {};
var parents = [AircraftCargo];
var cargoParent = "";
var cargoName = "";
#hookHeight (in meters)
var hookHeight = 15;
var hooked = 0;
var cargoReleased = 0;
var interval = 0;
var currentYaw = 0;
var originalYaw = 0;
var ropeLength = 0;
var hitchOffset = 1.1;
var cargoHeight = 0;
var cargoWeight = 0;
var cargoHarness = 0;
var cargoElevation = 0;
var cargoGroundElevFt = 0;
var haulable = 0;
var stack = 0;
var stackConnected = 0;
var currentLat = 0;
var currentLon = 0;
var asinInput = 0;
var cargo_pos = geo.Coord.new();
var stack_pos = geo.Coord.new();
var bearing = 0.0;
var cargo_dist = 0.0;
var seg_length = getprop("/sim/cargo/rope/factor");
var offset = getprop("/sim/cargo/rope/coil-angle");

var cargo_init = func () {

    var ct=0;
    foreach(var cargoN; props.globals.getNode("/models/cargo", 1).getChildren("cargo")){
		  if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
			  ct+=.001;
			
			  setprop("sim/cargo/"~cargoN.getNode("callsign").getValue()~"-onhook", 0);
			  setprop("controls/release-"~cargoN.getNode("callsign").getValue(), 0);

        if (getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/saved") == 1) {
          cargoN.getNode("latitude-deg").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/latitude-deg"));
          cargoN.getNode("longitude-deg").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/longitude-deg"));	
          cargoN.getNode("elevation-ft").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/altitude-ft"));
          cargoN.getNode("heading-deg").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/orientation/true-heading-deg"));
          aircraft.data.add("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/latitude-deg",
            "/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/longitude-deg",
            "/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/altitude-ft",
            "/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/orientation/true-heading-deg",
            "/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/saved");
          aircraft.data.save();
        } else
          if (getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/random") == 1) {
            var factor = ct + rand() * .001;
        	  var heading = getprop("orientation/heading-deg") + 90;
		        var x = math.cos(heading*0.0174533);
		        var y = math.sin(heading*0.0174533);
		        y = y * -1;
		        x = x * factor;
		        y = y * factor;
            cargoN.getNode("latitude-deg").setDoubleValue(getprop("position/latitude-deg")+y);
            cargoN.getNode("longitude-deg").setDoubleValue(getprop("position/longitude-deg")+x);
            cargoN.getNode("heading-deg").setDoubleValue(rand()*360);
            var elev_m = geo.elevation(cargoN.getNode("latitude-deg").getValue(), cargoN.getNode("longitude-deg").getValue());
            cargoN.getNode("elevation-ft").setDoubleValue(elev_m * 3.2808);
          }

	      print( "Cargo Created:" ~ 
          cargoN.getNode("callsign").getValue() ~ "\n" ~
          cargoN.getNode("latitude-deg").getValue() ~ "/" ~ 
          cargoN.getNode("longitude-deg").getValue() ~ "\nElev-ft:" ~ 
          cargoN.getNode("elevation-ft").getValue() ~ "\nHead:" ~ 
          cargoN.getNode("heading-deg").getValue() ~ "\n");
		  }
	  }

	  #gui.fpsDisplay(1);
	  if (!ct) {
		  print("No AI Cargo, exiting cargo.nas!");
      return;
    }
	  else {
      cargo_tow();
    }
  }

  var cargo_tow = func () {

    var hookNode = getprop("sim/cargo/cargo-hook");
    var autoHookNode = getprop("sim/cargo/cargo-auto-hook");
    var onHookNode = getprop("sim/cargo/cargo-on-hook");
    var releaseNode = getprop("controls/cargo-release");

    #use only geo?
    var lonNode = getprop("/position/longitude-deg");
    var latNode = getprop("/position/latitude-deg");
    var aircraft_pos = geo.aircraft_position();

    var headNode = getprop("/orientation/heading-deg");
    var pitchNode = getprop("/orientation/pitch-deg");
    var rollNode = getprop("/orientation/roll-deg");

    var onGround = getprop("gear/gear/wow") * getprop("gear/gear[1]/wow") * getprop("gear/gear[2]/wow");
    var cargoOnGround = getprop("/sim/cargo/hitsground");

    var longline = getprop("/sim/gui/dialogs/aicargo-dialog/connection");

    #var aircraft_alt_ft = getprop("/position/altitude-ft") - 13.8;
    var aircraft_alt_ft = getprop("/position/altitude-ft") - offset;
    var true_grnd_elev_ft = geo.elevation(latNode, lonNode) * 3.28;
    #can't use because of collision
    #var altNode = getprop("/position/altitude-agl-ft");
    var altNode =  aircraft_alt_ft - true_grnd_elev_ft;
    setprop("position/true-agl-ft", altNode);
    var elvPos = getprop("/position/ground-elev-ft") + (getprop("/position/altitude-agl-ft")-4.5);

    var n_seg_reeled = getprop("/sim/cargo/rope/segments-reeled-in");
    ropeLength = (90 - n_seg_reeled) * seg_length;

    if (longline){
        #hookHeight = 55;
        hookHeight = ropeLength * 3.28;
      }else{
        hookHeight = 15;
      }

	  if(onHookNode == 0 and cargoReleased == 0 and hooked == 0) {

var cargo_last=0;
var cargo_comp=0;
var cargo_closest=0;

        #gui.popupTip("In ranging", 1);
        foreach(var cargoN; props.globals.getNode("/models/cargo", 1).getChildren("cargo")) {

            #if (hooked) return;

            cargoElevation = cargoN.getNode("elevation-ft").getValue();
            cargoGroundElevFt = geo.elevation(cargoN.getNode("latitude-deg").getValue(), cargoN.getNode("longitude-deg").getValue()) * 3.28;

            #if (altNode - (hookHeight + (offset * 3.28)) < cargoElevation - cargoGroundElevFt) {
            if (altNode - (hookHeight + offset) < cargoElevation - cargoGroundElevFt) {

setprop("/sim/cargo/current-cargo-elevation", cargoElevation - cargoGroundElevFt);
setprop("/sim/cargo/current-cargo-elevation-two", altNode - ropeLength);

			          if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
                    cargo_pos.set_latlon(cargoN.getNode("latitude-deg").getValue(), cargoN.getNode("longitude-deg").getValue());
                    cargo_dist = aircraft_pos.distance_to(cargo_pos);

if(cargo_comp == 0) {
  cargo_last = cargo_dist;
  cargo_comp = 1;
} else {
  if(cargo_dist < cargo_last) {
    cargo_closest=cargo_dist;
  } else {    
    cargo_last = cargo_dist;
  }
  setprop("/sim/cargo/current-cargo-distance", cargo_closest);
}

                    if (cargo_dist <= (hookHeight + 5)/3.281) {
                        if (cargoN.getNode("elevation-ft").getValue() > -999){
                            gui.popupTip(cargoN.getNode("callsign").getValue()~" in range", 1);
					                  if (hookNode == 1 or autoHookNode == 1) {
						                    hooked = 1;

						                    cargoParent = cargoN.getNode("callsign").getParent().getName() ~ "[" ~ cargoN.getNode("callsign").getParent().getIndex() ~ "]";
                                cargoName = cargoN.getNode("callsign").getValue();

                                #maybe condition to only if longline
                                currentYaw = (headNode+(headNode-cargoN.getNode("heading-deg").getValue()))-headNode;
                                originalYaw = cargoN.getNode("heading-deg").getValue();
                                if (currentYaw > 360) currentYaw = currentYaw - 360;
                                if (currentYaw < 0) currentYaw = currentYaw + 360;
                                setprop("/sim/cargo/currentyaw", currentYaw);

                                cargoHeight = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/height").getValue();
                                cargoWeight = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/weight").getValue();
                                cargoHarness = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/harness").getValue();
                                cargoElevation = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/elevation-ft").getValue();
                                cargoGroundElevFt = geo.elevation(props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/latitude-deg").getValue(), props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/longitude-deg").getValue()) * 3.28;
                                stack = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/stack").getValue();

                                if (cargoHeight < 3.12)
                                  haulable = 1;
                                else
                                  haulable = 0;
						                    
                                if (longline or haulable) {
                                    longline_animation(1);
                                    currentLat = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/latitude-deg").getValue();
                                    currentLon = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/longitude-deg").getValue();

                                    setprop("sim/cargo/cargoharness", -cargoHarness);
                                    setprop("sim/cargo/cargoheight", -cargoHeight);

                                    if (!longline) {
                                        props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/elevation-ft").setDoubleValue(elvPos);
                                        props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/latitude-deg").setDoubleValue(latNode);
                                        props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/longitude-deg").setDoubleValue(lonNode);
                                        props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/heading-deg").setDoubleValue(headNode);
                                        props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/pitch-deg").setDoubleValue(pitchNode);
                                        props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/roll-deg").setDoubleValue(rollNode);
                                    }
                                }
                                setprop("sim/cargo/"~cargoName~"-onhook", 1);
                                setprop("sim/cargo/cargo-on-hook", 1);
                            }
					              }
				            }
			          }
            }
		    } #for
	  }
    if (hooked == 1) {
        cargoHeight = getprop("/models/cargo/" ~ cargoParent ~ "/height");
        if (!longline) {
            if (haulable) {
                # TODO: -optimize- some of this this may need to only happen once, each time the condition becomes true VS every loop

                currentYaw = (headNode+(headNode-originalYaw))-headNode;
                if (currentYaw > 360) currentYaw = currentYaw - 360;
                if (currentYaw < 0) currentYaw = currentYaw + 360;
                setprop("/sim/cargo/currentyaw", currentYaw);

                setprop("sim/cargo/cargoalt", 0);

                setprop("sim/weight[3]/weight-lb", cargoWeight);

                props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/elevation-ft").setDoubleValue(elvPos);
                props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/latitude-deg").setDoubleValue(latNode);
                props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/longitude-deg").setDoubleValue(lonNode);
                props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/heading-deg").setDoubleValue(headNode);
                props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/pitch-deg").setDoubleValue(pitchNode);
                props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/roll-deg").setDoubleValue(rollNode);

            } else {
                gui.popupTip("Cargo too tall use rope", 3);
                hooked = 0;
                setprop("sim/cargo/cargo-hook", 0);
                setprop("sim/cargo/cargo-on-hook", 0);
			          setprop("sim/cargo/"~cargoName~"-onhook", 0);
            }
        } else {
            if (longline and !cargoOnGround) {
                setprop("/sim/cargo/rope/damping", .1);
                setprop("/sim/cargo/rope/load-damping", .9);

                setprop("sim/cargo/rope/pulling", 0); 

                currentYaw = (headNode+(headNode-originalYaw))-headNode;
                if (currentYaw > 360) currentYaw = currentYaw - 360;
                if (currentYaw < 0) currentYaw = currentYaw + 360;
                setprop("/sim/cargo/currentyaw", currentYaw);

                setprop("sim/cargo/cargoalt", -ropeLength + -cargoHarness + -hitchOffset);

                setprop("sim/cargo/harnessalt", -hitchOffset + -ropeLength);

                setprop("sim/weight[3]/weight-lb", cargoWeight);

                currentLat = latNode;
                currentLon = lonNode;
                setprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg", currentLat);
                setprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg", currentLon);

                if (stack > 0) {
                    #var cargoBaseHeight = (aircraft_alt_ft + 13.8) - ((ropeLength + cargoHarness + cargoHeight) * 3.28);
                    var cargoBaseHeight = (aircraft_alt_ft + offset) - ((ropeLength + cargoHarness + cargoHeight) * 3.28);
                    var stackTopHeight = getprop("/models/cargo/cargo[" ~ stack ~ "]/elevation-ft");

setprop("/sim/cargo/current-cargo-elevation", stackTopHeight);
setprop("/sim/cargo/current-cargo-elevation-two", cargoBaseHeight);

                    var verticalDist = cargoBaseHeight - stackTopHeight;
                    stack_pos.set_latlon(getprop("/models/cargo/cargo[" ~ stack ~ "]/latitude-deg"), getprop("/models/cargo/cargo[" ~ stack ~ "]/longitude-deg"));
                    cargo_pos.set_latlon(currentLat, currentLon);
                    cargo_dist = cargo_pos.distance_to(stack_pos);

setprop("/sim/cargo/current-connection-distance", cargo_dist);

                    if (cargo_dist <= 10 and (verticalDist > -1 and verticalDist < 2)) {
                        gui.popupTip(cargoName~" Connection in range", 1);
                        stackConnected = 1;
                    } else
                        stackConnected = 0;
                }

            } else {
                setprop("/sim/cargo/rope/damping", .6);
                setprop("/sim/cargo/rope/load-damping", 1);

                longline_animation(1);
                setprop("sim/cargo/rope/pulling", 1);

                currentYaw = (headNode+(headNode-originalYaw))-headNode;
                if (currentYaw > 360) currentYaw = currentYaw - 360;
                if (currentYaw < 0) currentYaw = currentYaw + 360;
                setprop("/sim/cargo/currentyaw", currentYaw);
               
                setprop("sim/weight[3]/weight-lb", 0);

                cargo_pos.set_latlon(currentLat, currentLon);
                cargo_dist = aircraft_pos.distance_to(cargo_pos);

                var lMin = -(cargoHeight*3.28)/((ropeLength + (cargoHarness * .5))*3.28);
                var lMax = ((ropeLength + (cargoHarness * .5) + cargoHeight) * 3.28)/((ropeLength + (cargoHarness * .5))*3.28);
                var iput = (altNode-(cargoHeight*3.28))/((ropeLength + (cargoHarness * .5))*3.28);

                if (iput > lMax) iput = lMax;
                if (iput < lMin) iput = lMin;
                asinInput = normalize_h(iput, lMax, lMin);
                setprop("/sim/cargo/rope/pull-factor-pitch", (math.asin(asinInput)*57.2958)*-1);

                bearing = aircraft_pos.course_to(cargo_pos);
                var rel_bearing =  (headNode - 180.0) - bearing;
                setprop("/sim/cargo/rope/yaw1", rel_bearing);       
                
                if (cargo_dist > (ropeLength + 3)) {
                    setprop("sim/cargo/rope/pulling", 2);

                    setprop("sim/weight[3]/weight-lb", cargoWeight);
           
                    #x and y transformation to move cargo (incrementally) towards aircrane as rope is taut and pulling cargo
                    #this needs to be calculated precisely
                    currentLat = currentLat - ((currentLat-latNode)*.03);
                    currentLon = currentLon - ((currentLon-lonNode)*.03);

                    setprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg", currentLat);
                    setprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg", currentLon);
                }
                
                if (cargo_dist > (ropeLength + 6)) {
                    setprop("controls/cargo-release", 1);
                }

                setprop("/models/cargo/"~cargoParent~"/elevation-ft", (geo.elevation(currentLat, currentLon) + cargoHeight) * 3.2808);
            }
        }
        #gui.popupTip(cargoName~" in tow", 1);
setprop("/sim/cargo/current-cargo-name", cargoName);
        if (releaseNode == 1 and onHookNode == 1) {
            if (onGround or (longline and cargoOnGround) or (stack and stackConnected)) {
                setprop("sim/cargo/cargo-on-hook", 0);
                setprop("controls/cargo-release", 0);
	              hooked = 0;
                setprop("sim/cargo/cargo-hook", 0);
	              cargoReleased = 1;
                if (getprop("sim/cargo/rope/pulling") == 2) {
	                  gui.popupTip("Drag force exceeded", 3);
                } else 
                    gui.popupTip("Cargo released", 3);
                setprop("sim/cargo/rope/pulling", 0);
	              setprop("sim/cargo/"~cargoName~"-onhook", 0);
	              setprop("controls/release-"~cargoName, 1);
                if (stackConnected)
                    gui.popupTip(cargoName~" Connected", 1);
            } else {
                gui.popupTip("Cargo not on ground or out of position", 1);
                setprop("controls/cargo-release", cargoReleased = 0);
            }
        }
    } else {
        if (autoHookNode == 1) {
            gui.popupTip("Auto hook engaged", 1);
        }
        #release auto.hook by pressing hook
        if (hookNode == 1 and autoHookNode == 1) {
            setprop("sim/cargo/cargo-auto-hook", 0);
            setprop("sim/cargo/cargo-hook", 0);
        }
    }

	  if (cargoReleased == 1) {
        setprop("sim/weight[3]/weight-lb", 0);

        setprop("/sim/cargo/rope/damping", .6);
        setprop("/sim/cargo/rope/load-damping", 1);
        
        #use to offset cargo behind aircraft
        #var x = math.cos((headNode+90)*0.0174533);
        #var y = math.sin((headNode+90)*0.0174533);
        #y = y * -1;
        #x = x * .0000239;
        #y = y * .0000239;

        if (!longline) {
            setprop("/models/cargo/"~cargoParent~"/elevation-ft", (geo.elevation(latNode, lonNode) + cargoHeight) * 3.2808);
            setprop("/models/cargo/"~cargoParent~"/heading-deg", headNode);
            setprop("/models/cargo/"~cargoParent~"/latitude-deg", latNode);
            setprop("/models/cargo/"~cargoParent~"/longitude-deg", lonNode);
        } else {
            setprop("/models/cargo/"~cargoParent~"/heading-deg", originalYaw);
            if (stack and stackConnected) {
                setprop("/models/cargo/"~cargoParent~"/elevation-ft", getprop("/models/cargo/cargo[" ~ stack ~ "]/elevation-ft") + (getprop("/models/cargo/" ~ cargoParent ~ "/drop") * 3.28));
                setprop("/models/cargo/"~cargoParent~"/latitude-deg", getprop("/models/cargo/cargo[" ~ stack ~ "]/latitude-deg"));
                setprop("/models/cargo/"~cargoParent~"/longitude-deg", getprop("/models/cargo/cargo[" ~ stack ~ "]/longitude-deg"));
            } else
                setprop("/models/cargo/"~cargoParent~"/elevation-ft", (geo.elevation(latNode, lonNode) + cargoHeight) * 3.2808);
        }

        if (getprop("/sim/model/aircrane/"~cargoName~"/saved")) {
            #gui.popupTip(cargoName~" position saved", 1);
            setprop("/sim/model/aircrane/"~cargoName~"/position/latitude-deg", getprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg"));
            setprop("/sim/model/aircrane/"~cargoName~"/position/longitude-deg", getprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg"));
            setprop("/sim/model/aircrane/"~cargoName~"/position/altitude-ft", getprop("/models/cargo/" ~ cargoParent ~ "/elevation-ft"));
            setprop("/sim/model/aircrane/"~cargoName~"/orientation/true-heading-deg", getprop("/models/cargo/" ~ cargoParent ~ "/heading-deg"));
            aircraft.data.add("/sim/model/aircrane/"~cargoName~"/position/latitude-deg",
                              "/sim/model/aircrane/"~cargoName~"/position/longitude-deg",
                              "/sim/model/aircrane/"~cargoName~"/position/altitude-ft",
                              "/sim/model/aircrane/"~cargoName~"/orientation/true-heading-deg");
            aircraft.data.save();
        }
        cargoName="";
        cargoReleased=0;
        setprop("sim/cargo/cargo-auto-hook", 0);

        #TODO: Make this to update GUI correctly 
        #var aic = getprop("/sim/gui/dialogs/aicargo-dialog/ai-path");
        #if (aic != nil and aic == cargoParent) {
        #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lat", getprop("/models/cargo" ~ cargoParent ~ "/position/latitude-deg"));#new location not AI
        #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lon", getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg"));
        #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_alt", getprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft"));
        #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head", getprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg"));
        #}
	  }

    if (hookNode)
        setprop("/sim/cargo/cargo-hook", 0);
    if (releaseNode)
        setprop("/controls/cargo-release", 0);

    longline_animation(0);

	  settimer(cargo_tow, interval);

}

#degrees to radians
var deg2rad = func (deg) {
	var rad = deg * math.pi/180;
	return rad;
}

#round
var round = func (pos) {
	return math.round(pos * 1000) / 1000;
}

var normalize_h = func (x, min, max) {
  return (x - min) / (max - min);
}

var normalize_hr = func (x, minI, maxI, minO, maxO) {
  var r = maxO - minO;
  var t = normalize_h(x, minI, maxI);
  return (minO + (r * t));
}
