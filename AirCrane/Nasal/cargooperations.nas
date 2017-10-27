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

setlistener("/sim/signals/fdm-initialized", func (n) {

  #set initial position of the cargo models out of site and out of range
  var lat = getprop("/position/latitude-deg")-.0002;
  var lon = getprop("/position/longitude-deg")-.0002;
  var alt = -999;

  #property tree location of cargo models
  var model_path = "Aircraft/AirCrane/Models/Cargo-Hauling/";

  #altitude offset of cargo objects
  #container-big  -3.879 m 12.72 ft
  #cub-ground     -3.231 m 10.60 ft
  #ground-tank    -3.737 m 12.26 ft
  #tank-stand     -3.562 m 11.68 ft
  #pine-tree      -3.334 m 10.93 ft

  #inject new cargo models into the scene
  cargo1 =  place_model( "1",  0, "container-big",    model_path~"cargo1.xml", 5000, 2.5, 6.10, lat, lon, alt, 12.72, 0, 0, 0);
  cargo2 =  place_model( "2",  1, "container-big",    model_path~"cargo2.xml", 1500, 2.5, 6.10, lat, lon, alt, 12.72, 0, 0, 0);
  cargo3 =  place_model( "3",  2, "container-big",    model_path~"cargo3.xml", 1000, 2.5, 6.10, lat, lon, alt, 12.72, 0, 0, 0);
  cargo4 =  place_model( "4",  3, "cub-ground",       model_path~"cargo4.xml", 1200, 1.83, 5.98, lat, lon, alt, 10.60, 0, 0, 0);
  cargo5 =  place_model( "5",  4, "ground-tank",      model_path~"cargo5.xml", 2000, 2.42, 6.44, lat, lon, alt, 12.26, 0, 0, 0);
  cargo6 =  place_model( "6",  5, "ground-tank-lg",   model_path~"cargo6.xml", 4200, 4.18, 6.02, lat, lon, alt-90, 0,  0, 0, 0);
  cargo7 =  place_model( "7",  6, "ground-tank-tall", model_path~"cargo7.xml", 3000, 3.69, 6.02, lat, lon, alt-90, 0,  0, 0, 0);
  cargo8 =  place_model( "8",  7, "tank-stand",       model_path~"cargo8.xml", 600, 2.12, 6.08, lat, lon, alt, 11.68, 0, 0, 0);
  cargo9 =  place_model( "9",  8, "pine-tree",        model_path~"cargo9.xml", 350, 2.08, 6.12, lat, lon, alt, 10.93, 0, 0, 0);
  cargo10 = place_model("10",  9, "pine-tree",        model_path~"cargo10.xml", 350, 2.08, 6.12, lat, lon, alt, 10.93, 0, 0, 0);
  cargo11 = place_model("11", 10, "pine-tree",        model_path~"cargo11.xml", 350, 2.08, 6.12, lat, lon, alt, 10.93, 0, 0, 0);
  cargo12 = place_model("12", 11, "pine-tree",        model_path~"cargo12.xml", 350, 2.08, 6.12, lat, lon, alt, 10.93, 0, 0, 0);
  cargo13 = place_model("13", 12, "pine-tree",        model_path~"cargo13.xml", 350, 2.08, 6.12, lat, lon, alt, 10.93, 0, 0, 0);
  cargo14 = place_model("14", 13, "dump-truck",       model_path~"cargo14.xml", 18000, 9.3, 10.59, lat, lon, alt-90, 0,  0, 0, 0);

  cargo_init();
});

#################### inject cargo models into the scene (helper) ####################

var place_model = func(string, position, desc, path, weight, height, harness, lat, lon, alt, offset, heading, pitch, roll) {

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
  setprop("/models/cargo/cargo["~position~"]/callsign", "cargo"~string);
  setprop("/models/cargo/cargo["~position~"]/description", desc);
  setprop("/models/cargo/cargo["~position~"]/weight", weight);
  setprop("/models/cargo/cargo["~position~"]/height", height);
  setprop("/models/cargo/cargo["~position~"]/harness", harness);

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

  model.getNode("path", 1).setValue(path);
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
var hookDistance = 1e-8;
#hookHeight (in meters)
var hookHeight = 15;
var hooked = 0;
var cargoReleased = 0;
var minDist = 999;
var minDistNEW = 999;
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

var rope_distance = func (dlat, dlon) {
  var dist = dlat * dlat + dlon * dlon;
  if(dist < minDist) {
    minDist = dist;
  }
  return dist; 
}

var cargo_tow = func () {

  var hookNode = getprop("sim/cargo/cargo-hook");
  var autoHookNode = getprop("sim/cargo/cargo-auto-hook");
  var onHookNode = getprop("sim/cargo/cargo-on-hook");
  var releaseNode = getprop("controls/cargo-release");
  var lonNode = getprop("/position/longitude-deg");
  var latNode = getprop("/position/latitude-deg");
  var altNode = getprop("/position/altitude-agl-ft");
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

var elvPos = groundElevFt + altNode;

  if (longline) {
    hookHeight = 43;
    hookDistance = 2.5e-8
  } else {
    hookHeight = 15;
    hookDistance = 1e-9;
  }

	if(onHookNode == 0 and (altNode < hookHeight) and cargoReleased == 0) {
    #gui.popupTip("In ranging", 1);
    foreach(var cargoN; props.globals.getNode("/models/cargo", 1).getChildren("cargo")) {
			if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
        dist = rope_distance(cargoN.getNode("latitude-deg").getValue() - latNode, cargoN.getNode("longitude-deg").getValue() - lonNode);
        if(dist <= hookDistance) {
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
            cargoHeight = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/height").getValue();
            cargoHarness = props.globals.getNode("/models/cargo/" ~ cargoParent ~ "/harness").getValue();

            if (cargoHeight < 3.0)
              haulable = 1;
            else
              haulable = 0;

            if (longline or haulable) {

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
              #setprop("sim/cargo/harnessalt", groundNode + ropeLength + cargoHeight - cargoHarness);

              setprop("sim/cargo/rope/flex-force", 0.01);
              setprop("sim/cargo/rope/damping", 0.6);
              setprop("/sim/cargo/rope/stiffness", 3);

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
        currentYaw = (headNode+(headNode-originalYaw))-headNode;
        if (currentYaw > 360) currentYaw = currentYaw - 360;
        if (currentYaw < 0) currentYaw = currentYaw + 360;
        setprop("/sim/cargo/currentyaw", currentYaw);

        setprop("sim/cargo/cargoalt", -cargoHarness);
        setprop("sim/cargo/harnessalt", -cargoHarness - .1);

        setprop("sim/weight[3]/weight-lb", cargoWeight);
      } else {
        dist = rope_distance(getprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg") - latNode, getprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg") - lonNode);
        if(dist <= hookDistance and cargoOnGround) {
          #TODO: add x and y transformation to move cargo (incrementally) as to appear to not move
          currentYaw = (headNode+(headNode-originalYaw))-headNode;
          if (currentYaw > 360) currentYaw = currentYaw - 360;
          if (currentYaw < 0) currentYaw = currentYaw + 360;
          setprop("/sim/cargo/currentyaw", currentYaw);

          setprop("sim/cargo/cargoalt", (-groundNode) + ropeLength + cargoHeight);
          #setprop("sim/cargo/harnessalt", ropeLength + cargoHeight - cargoHarness);

          setprop("sim/weight[3]/weight-lb", 0);
        } else {
          #TODO: add x and y transformation to move cargo (incrementally) towards aircrane as rope is taut and pulling cargo 

          currentYaw = (headNode+(headNode-originalYaw))-headNode;
          if (currentYaw > 359) currentYaw = currentYaw - 360;
          if (currentYaw < 0) currentYaw = currentYaw + 360;
          setprop("/sim/cargo/currentyaw", currentYaw);

          setprop("sim/cargo/cargoalt", (-groundNode) + ropeLength + cargoHeight);
          setprop("sim/cargo/harnessalt", -cargoHarness - .1);

          setprop("sim/weight[3]/weight-lb", cargoWeight);
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

      var elevoffset = getprop("/models/cargo/"~cargoParent~"/elev-offset");
      setprop("/models/cargo/"~cargoParent~"/elevation-ft", geo.elevation(latNode, lonNode) * 3.2808 + elevoffset);

      if (!longline)
        setprop("/models/cargo/"~cargoParent~"/heading-deg", headNode);
      else
        setprop("/models/cargo/"~cargoParent~"/heading-deg", originalYaw);

        setprop("/models/cargo/"~cargoParent~"/latitude-deg", latNode);
        setprop("/models/cargo/"~cargoParent~"/longitude-deg", lonNode);

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

	settimer(cargo_tow, interval);

}
