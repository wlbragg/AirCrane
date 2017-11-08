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

setlistener("/sim/signals/fdm-initialized", func (n) {

  #set initial position of the cargo models out of site and out of range
  var lat = getprop("/position/latitude-deg")-.0002;
  var lon = getprop("/position/longitude-deg")-.0002;
  var alt = -999;

  #property tree location of cargo models
  var model_path = "Aircraft/AirCrane/Models/Cargo-Hauling/";

  #                             offset ft   cargoheight m     harnessheight m
  #container-big    -3.879 m = 12.72        2.66              6.10
  #cub-ground       -3.231 m = 10.60        1.83              5.98
  #ground-tank      -3.737 m = 12.26        2.42              6.44
  #ground-tank-lg                           4.18              6.02
  #ground-tank-tall                         3.69              6.02
  #tank-stand       -3.562 m = 11.68        2.12              6.08
  #pine-tree        -3.334 m = 10.93        2.08              6.12
  #dump-truck                               9.3              10.59
  #micro-relay                              5.98              6.06
  #micro-wave                               5.99              6.99
  #tower-sec-one                           12.64             16.49
  #tower-sec-two                           12.70             16.49
  #tower-sec-three                         13.05             16.49
  #tower-sec-four                          13.11             16.49
  #tower-sec-five                          13.05             16.49
  #tower-sec-six                           12.25             16.49
  #tower-sec-seven                         12.82             16.49
  #tower-radio                            161.21             16.49


  #inject new cargo models into the scene
  cargo1 =  place_model( "1",  0, "container-big",    model_path,  0, 5000, 2.66, 6.10, lat, lon, alt,  12.72, 0, 0, 0);
  cargo2 =  place_model( "2",  1, "container-big",    model_path,  0, 1500, 2.66, 6.10, lat, lon, alt,  12.72, 0, 0, 0);
  cargo3 =  place_model( "3",  2, "container-big",    model_path,  0, 1000, 2.66, 6.10, lat, lon, alt,  12.72, 0, 0, 0);
  cargo4 =  place_model( "4",  3, "cub-ground",       model_path,  0, 1200, 1.83, 5.98, lat, lon, alt,  10.60, 0, 0, 0);
  cargo5 =  place_model( "5",  4, "ground-tank",      model_path,  0, 2000, 2.42, 6.44, lat, lon, alt,  12.26, 0, 0, 0);
  cargo6 =  place_model( "6",  5, "ground-tank-lg",   model_path,  0, 4200, 4.18, 6.02, lat, lon, alt-90,   0, 0, 0, 0);
  cargo7 =  place_model( "7",  6, "ground-tank-tall", model_path,  0, 3000, 3.69, 6.02, lat, lon, alt-90,   0, 0, 0, 0);
  cargo8 =  place_model( "8",  7, "tank-stand",       model_path,  0,  600, 2.12, 6.08, lat, lon, alt,  11.68, 0, 0, 0);
  cargo9 =  place_model( "9",  8, "pine-tree",        model_path,  0,  350, 2.08, 6.12, lat, lon, alt,  10.93, 0, 0, 0);
  cargo10 = place_model("10",  9, "pine-tree",        model_path,  0,  350, 2.08, 6.12, lat, lon, alt,  10.93, 0, 0, 0);
  cargo11 = place_model("11", 10, "pine-tree",        model_path,  0,  350, 2.08, 6.12, lat, lon, alt,  10.93, 0, 0, 0);
  cargo12 = place_model("12", 11, "pine-tree",        model_path,  0,  350, 2.08, 6.12, lat, lon, alt,  10.93, 0, 0, 0);
  cargo13 = place_model("13", 12, "pine-tree",        model_path,  0,  350, 2.08, 6.12, lat, lon, alt,  10.93, 0, 0, 0);
  cargo14 = place_model("14", 13, "dump-truck",       model_path,  0,18000,  9.3,10.59, lat, lon, alt-90,   0, 0, 0, 0);
  cargo15 = place_model("15", 14, "micro-relay",      model_path, 22,  400, 5.98, 6.06, lat, lon, alt-90,   0, 0, 0, 0);
  cargo16 = place_model("16", 15, "micro-wave",       model_path, 21,  400, 5.99, 6.99, lat, lon, alt-90,   0, 0, 0, 0);
  cargo17 = place_model("17", 16, "tower-sec-one",    model_path,  0, 1400,12.64,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo18 = place_model("18", 17, "tower-sec-two",    model_path, 16, 1300,12.70,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo19 = place_model("19", 18, "tower-sec-three",  model_path, 17, 1200,13.05,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo20 = place_model("20", 19, "tower-sec-four",   model_path, 18, 1100,13.11,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo21 = place_model("21", 20, "tower-sec-five",   model_path, 19, 1000,13.05,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo22 = place_model("22", 21, "tower-sec-six",    model_path, 20,  950,12.25,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo23 = place_model("23", 22, "tower-sec-seven",  model_path, 21,  900,12.82,16.49, lat, lon, alt-90,   0, 0, 0, 0);
  cargo24 = place_model("24", 23, "tower-radio",      model_path,  0, 3000,161.21,16.49,lat, lon, alt-90,   0, 0, 0, 0);

  cargo_init();
});

#################### inject cargo models into the scene (helper) ####################

var place_model = func(number, position, desc, path, stack, weight, height, harness, lat, lon, alt, offset, heading, pitch, roll) {

  var m = props.globals.getNode("models", 1);
		  for (var i = 0; 1; i += 1)
			  if (m.getChild("model", i, 0) == nil)
				  break;
  var model = m.getChild("model", i, 1);

  setprop("/models/cargo/cargo["~position~"]/latitude-deg", lat);
  setprop("/models/cargo/cargo["~position~"]/longitude-deg", lon);
  setprop("/models/cargo/cargo["~position~"]/elevation-ft", alt);
  setprop("/models/cargo/cargo["~position~"]/elev-offset", offset);
  setprop("/models/cargo/cargo["~position~"]/heading-deg", heading);
  setprop("/models/cargo/cargo["~position~"]/pitch-deg", pitch);
  setprop("/models/cargo/cargo["~position~"]/roll-deg", roll);
  setprop("/models/cargo/cargo["~position~"]/callsign", "cargo"~number);
  setprop("/models/cargo/cargo["~position~"]/description", desc);
  setprop("/models/cargo/cargo["~position~"]/weight", weight);
  setprop("/models/cargo/cargo["~position~"]/height", height);
  setprop("/models/cargo/cargo["~position~"]/harness", harness);
  setprop("/models/cargo/cargo["~position~"]/stack", stack);

  var cargomodel = props.globals.getNode("/models/cargo/cargo["~position~"]", 1);
  var latN = cargomodel.getNode("latitude-deg",1);
  var lonN = cargomodel.getNode("longitude-deg",1);
  var altN = cargomodel.getNode("elevation-ft",1);
  var altoffsetN = cargomodel.getNode("elev-offset",1);
  var headN = cargomodel.getNode("heading-deg",1);
  var pitchN = cargomodel.getNode("pitch-deg",1);
  var rollN = cargomodel.getNode("roll-deg",1);
  var callsignN = cargomodel.getNode("callsign",1);
  var descriptionN = cargomodel.getNode("description",1);
  var weightN = cargomodel.getNode("weight",1);
  var heightN = cargomodel.getNode("height",1);
  var harnessN = cargomodel.getNode("harness",1);
  var stackN = cargomodel.getNode("stack",1);

  model.getNode("path", 1).setValue(path~"cargo"~number~".xml");
  model.getNode("latitude-deg-prop", 1).setValue(latN.getPath());
  model.getNode("longitude-deg-prop", 1).setValue(lonN.getPath());
  model.getNode("elevation-ft-prop", 1).setValue(altN.getPath());
  model.getNode("elev-offset-prop", 1).setValue(altoffsetN.getPath());
  model.getNode("heading-deg-prop", 1).setValue(headN.getPath());
  model.getNode("pitch-deg-prop", 1).setValue(pitchN.getPath());
  model.getNode("roll-deg-prop", 1).setValue(rollN.getPath());
  model.getNode("callsign-prop", 1).setValue(callsignN.getPath());
  model.getNode("description-prop", 1).setValue(descriptionN.getPath());
  model.getNode("weight-prop", 1).setValue(weightN.getPath());
  model.getNode("height-prop", 1).setValue(heightN.getPath());
  model.getNode("harness-prop", 1).setValue(harnessN.getPath());
  model.getNode("stack-prop", 1).setValue(stackN.getPath());
  model.getNode("load", 1).remove();

  return model;
}

#################### cargo hauling ####################

props.Node.new({ "controls/hook-assist":0 });
props.globals.initNode("controls/hook-assist", 0, "BOOL" );
props.Node.new({ "controls/cargo-release":0 });
props.globals.initNode("controls/cargo-release", 0, "BOOL" );
props.Node.new({ "sim/cargo/cargo-hook":0, "sim/cargo/cargo-auto-hook":0, "sim/cargo/cargo-on-hook":0, "sim/cargo/cargo-offset":0 });
props.globals.initNode("sim/cargo/cargo-hook", 0, "BOOL" );
props.globals.initNode("sim/cargo/cargo-auto-hook", 0, "BOOL" );
props.globals.initNode("sim/cargo/cargo-on-hook", 0, "BOOL" );
props.globals.initNode("sim/cargo/cargo-offset", 0, "DOUBLE" );

var AircraftCargo = {};
var parents = [AircraftCargo];
var cargoParent = "";
var cargoName = "";
#hookHeight (in meters)
var hookHeight = 15;
var hooked = 0;
var cargoReleased = 0;
#var interval = .025;
var interval = 0;
var currentYaw = 0;
var originalYaw = 0;
var dist = 0;
var ropeLength = 12.2;
var cargoHeight = 0;
var cargoWeight = 0;
var cargoHarness = 0;
var haulable = 0;

var currentLat = 0;
var currentLon = 0;

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
  var lonNode = getprop("/position/longitude-deg");
  var latNode = getprop("/position/latitude-deg");
  #can't use because of collision
  #var altNode = getprop("/position/altitude-agl-ft");
  var groundNode = getprop("/position/gear-agl-m");
  var groundElevFt = getprop("/position/ground-elev-ft");
  var headNode = getprop("/orientation/heading-deg");
  var pitchNode = getprop("/orientation/pitch-deg");
  var rollNode = getprop("/orientation/roll-deg");
  var onGround = getprop("gear/gear/wow") * getprop("gear/gear[1]/wow") * getprop("gear/gear[2]/wow");
  var longline = getprop("/sim/gui/dialogs/aicargo-dialog/connection");
  #var cable = getprop("/sim/gui/dialogs/aicargo-dialog/longline");
  var cargoOnGround = getprop("/sim/cargo/hitsground");
  var harnessPos = getprop("sim/cargo/harnessalt");
  var aircraft_alt_ft = getprop("/position/altitude-ft") -13.8;
  var true_grnd_elev_ft = geo.elevation(latNode, lonNode) * 3.28;           
  var true_agl_ft =  aircraft_alt_ft - true_grnd_elev_ft;
  setprop("position/true-agl-ft", true_agl_ft);
  var altNode = true_agl_ft;
  var elvPos = groundElevFt + getprop("/position/altitude-agl-ft");

  if (longline) {
    hookHeight = 55;
  } else {
    hookHeight = 15;
  }
  
  #needs work to make this check account for the height of the cargo to the hitch height 
  #of the connection point be it longline or harddocked
	if(onHookNode == 0 and cargoReleased == 0) {
    #gui.popupTip("In ranging", 1);
    foreach(var cargoN; props.globals.getNode("/models/cargo", 1).getChildren("cargo")) {

      cargoHeight = cargoN.getNode("height").getValue();

      if (altNode < (hookHeight + (cargoHeight * 3.28))) {
			  if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
          dist = checkDistance(latNode, lonNode, cargoN.getNode("latitude-deg").getValue(), cargoN.getNode("longitude-deg").getValue());

setprop("a-dist", dist);

          #0.022 needs to be variable for either hard docked distance or long line distance, 0.022 = long line
          if(dist <= 0.022) {
            #also needs a distance check between multiple visible cargos and connect only the one that is closest
            if (cargoN.getNode("elevation-ft").getValue() > -999 ) {
              gui.popupTip(cargoN.getNode("callsign").getValue()~" in range", 1);
					    if (hookNode == 1 or autoHookNode == 1) {

						    hooked = 1;

						    cargoParent = cargoN.getNode("callsign").getParent().getName() ~ "[" ~ cargoN.getNode("callsign").getParent().getIndex() ~ "]";
						    cargoName = cargoN.getNode("callsign").getValue();

                setprop("sim/cargo/cargo-on-hook", 1);
						    setprop("sim/cargo/"~cargoName~"-onhook", 1);

                #maybe condition to only if longline
                currentYaw = (headNode+(headNode-cargoN.getNode("heading-deg").getValue()))-headNode;
                originalYaw = cargoN.getNode("heading-deg").getValue();
                if (currentYaw > 360) currentYaw = currentYaw - 360;
                if (currentYaw < 0) currentYaw = currentYaw + 360;
                setprop("/sim/cargo/currentyaw", currentYaw);

                cargoWeight = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/weight").getValue();
                cargoHarness = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/harness").getValue();

                if (cargoHeight < 3.0)
                  haulable = 1;
                else
                  haulable = 0;

                if (longline or haulable) {
                  
                  longline_animation(1);

                  setprop("sim/cargo/cargoharness", -cargoHarness);
                  setprop("sim/cargo/cargoheight", -cargoHeight);

                  if (!longline)
                    {
                      props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/elevation-ft").setDoubleValue(elvPos);
                      props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/latitude-deg").setDoubleValue(latNode);
                      props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/longitude-deg").setDoubleValue(lonNode);
                      props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/heading-deg").setDoubleValue(headNode);
                      props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/pitch-deg").setDoubleValue(pitchNode);
                      props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/roll-deg").setDoubleValue(rollNode);
                    }

                  setprop("sim/cargo/cargoalt", (-groundNode) + ropeLength + cargoHeight);

                  setprop("sim/cargo/rope/flex-force", 0.01);
                  setprop("sim/cargo/rope/damping", 0.6);
                  setprop("/sim/cargo/rope/stiffness", 3);

setprop("A-altNode", altNode);
setprop("A-cargoHeight", cargoHeight);
setprop("A-hookHeight", hookHeight);
setprop("A-hookHeight-cargoHeight", hookHeight + (cargoHeight * 3.28));

                }
              }

					  }

				  }
			  }
      }
		}
	}
  if (hooked == 1) {
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
    } else
      if (longline and !cargoOnGround) {

        setprop("sim/cargo/roll-deg", 0);
        setprop("sim/cargo/pitch-deg", 0);

        currentYaw = (headNode+(headNode-originalYaw))-headNode;
        if (currentYaw > 360) currentYaw = currentYaw - 360;
        if (currentYaw < 0) currentYaw = currentYaw + 360;
        setprop("/sim/cargo/currentyaw", currentYaw);

        setprop("sim/cargo/cargoalt", -cargoHarness);
        setprop("sim/cargo/harnessalt", -cargoHarness);

        setprop("sim/weight[3]/weight-lb", cargoWeight);

        #this needs to be possibly attached to rope movement too
        currentLat = latNode;
        currentLon = lonNode;
        setprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg", currentLat);
        setprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg", currentLon);

        var stack = getprop("/models/cargo/"~cargoParent~"/stack");
        if (stack) {
          dist = checkDistance(currentLat, currentLon, getprop("/models/cargo/cargo[" ~ stack ~ "]/latitude-deg"), getprop("/models/cargo/cargo[" ~ stack ~ "]/longitude-deg"));
          if (dist <= 0.002) gui.popupTip(cargoName~" Connected", 1);
        }

      } else {

        setprop("sim/cargo/roll-deg", 0);
        setprop("sim/cargo/pitch-deg", 0);

        #TODO calculate distance from aircraft hitch to cargo hitch (including rope length + harness and height)

        dist = checkDistance(latNode, lonNode, getprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg"), getprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg"));
setprop("a-dist", dist);
        if (dist <= .016) {

          #gui.popupTip("in on ground not moving", 1);

          currentYaw = (headNode+(headNode-originalYaw))-headNode;
          if (currentYaw > 360) currentYaw = currentYaw - 360;
          if (currentYaw < 0) currentYaw = currentYaw + 360;
          setprop("/sim/cargo/currentyaw", currentYaw);

          var elevoffset = getprop("/models/cargo/"~cargoParent~"/elev-offset");
          setprop("/models/cargo/"~cargoParent~"/elevation-ft", geo.elevation(latNode, lonNode) * 3.2808 + elevoffset);
          
          setprop("sim/weight[3]/weight-lb", 0);

        } else {

          #gui.popupTip("on ground moving", 1);

          currentYaw = (headNode+(headNode-originalYaw))-headNode;
          if (currentYaw > 359) currentYaw = currentYaw - 360;
          if (currentYaw < 0) currentYaw = currentYaw + 360;
          setprop("/sim/cargo/currentyaw", currentYaw);

          setprop("sim/cargo/harnessalt", -cargoHarness - .1);

          setprop("sim/weight[3]/weight-lb", cargoWeight);

          #TODO: 
          #add x and y transformation to move cargo (incrementally) towards aircrane as rope is taut and pulling cargo
          #this needs to be calculated precisely
          currentLat = currentLat - ((currentLat-latNode)*.011);
          currentLon = currentLon - ((currentLon-lonNode)*.011);

          #θ=arctan(11)=45˚
          #ϕ=arctan(2–√1)≈55˚

          var elevoffset = getprop("/models/cargo/"~cargoParent~"/elev-offset");
          setprop("/models/cargo/"~cargoParent~"/elevation-ft", geo.elevation(currentLat, currentLon) * 3.2808 + elevoffset);
          setprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg", currentLat);
          setprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg", currentLon);
           
          #add pitch and roll to rope and cargo to match dirction of pulling transformation
          var bearing = bearing(currentLat, currentLon, latNode, lonNode);
setprop("a-bearing", bearing);

        }
      }

    #gui.popupTip(cargoName~" in tow", 1);
		if (releaseNode == 1 and onHookNode == 1) {
      if (onGround or (longline and cargoOnGround)) {
        setprop("sim/cargo/cargo-on-hook", 0);
        setprop("controls/cargo-release", 0);
			  hooked = 0;
        setprop("sim/cargo/cargo-hook", 0);
			  cargoReleased = 1;
			  gui.popupTip("Cargo released", 3);
			  setprop("sim/cargo/"~cargoName~"-onhook", 0);
			  setprop("controls/release-"~cargoName, 1);
      } else {
        gui.popupTip("Cargo not on ground", 1);
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
      gui.popupTip(cargoName~" released", 1);

      setprop("sim/weight[3]/weight-lb", 0);

      #TODO: needs a listener condition for (stiff) cable VS (flexible) rope 
      #setprop("/sim/cargo/rope/factor", 0.19);
      #setprop("/sim/cargo/rope/offset", -1.1);
      #setprop("/sim/cargo/rope/bendforce", 50);
      #setprop("/sim/cargo/rope/correction", -.01);
      setprop("/sim/cargo/rope/flex-force", 0.09);
      setprop("/sim/cargo/rope/damping", 0.6);
      setprop("/sim/cargo/rope/stiffness", 9);
      
      #use to offset cargo behind aircraft
      #var x = math.cos((headNode+90)*0.0174533);
      #var y = math.sin((headNode+90)*0.0174533);
      #y = y * -1;
      #x = x * .0000239;
      #y = y * .0000239;

      if (!longline) {
        var elevoffset = getprop("/models/cargo/"~cargoParent~"/elev-offset");
        setprop("/models/cargo/"~cargoParent~"/elevation-ft", geo.elevation(latNode, lonNode) * 3.2808 + elevoffset);
        setprop("/models/cargo/"~cargoParent~"/heading-deg", headNode);
        setprop("/models/cargo/"~cargoParent~"/latitude-deg", latNode);
        setprop("/models/cargo/"~cargoParent~"/longitude-deg", lonNode);
      } else
        setprop("/models/cargo/"~cargoParent~"/heading-deg", originalYaw);

      if (getprop("/sim/model/aircrane/"~cargoName~"/saved")) {
        gui.popupTip(cargoName~" position saved", 1);
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

      #TODO: Make this to update GUI correctly 
      #var aic = getprop("/sim/gui/dialogs/aicargo-dialog/ai-path");
      #if (aic != nil and aic == cargoParent) {
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lat", getprop("/models/cargo" ~ cargoParent ~ "/position/latitude-deg"));#new location not AI
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lon", getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg"));
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_alt", getprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft"));
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head", getprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg"));
      #}
	}	

  longline_animation(0);
	settimer(cargo_tow, interval);

}

#bearing from coordinate point to coordinate point
var bearing = func (lat1, lon1, lat2, lon2) {
    var dLon = (lon2 - lon1);

    var y = math.sin(dLon) * math.cos(lat2);
    var x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1)
            * math.cos(lat2) * math.cos(dLon);

    var brng = math.atan2(y, x);

    brng = brng * 57.295779513;
    #brng = math.todegrees(brng);
    brng = math.fmod(brng + 360, 360);
    #brng = (brng + 360) % 360;
    brng = 360 - brng; # count degrees counter-clockwise - remove to make clockwise

    return brng;
}

#distance between coordinate points
var checkDistance = func (seclat, seclon, baselat, baselon) {
	#coordinate difference
	var dlat = deg2rad(baselat) - deg2rad(seclat);
	var dlon = deg2rad(baselon) - deg2rad(seclon);

	#calc distance
	var a  = math.pow(math.sin(dlat/2),2) + math.cos(deg2rad(seclat)) * math.cos(deg2rad(baselat)) * math.pow(math.sin(dlon/2),2);
	var c  = 2 * math.atan2(math.sqrt(a),math.sqrt(1-a));
	var dist_m = c * 3961; #earth mean radius at 39 degrees (miles)
	var dist_k = c * 6373; #earth mean radius at 39 degrees (kilometers)
	
	return round(dist_m);
	#return round(dist_k);
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