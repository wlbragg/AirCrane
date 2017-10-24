setlistener("/sim/signals/fdm-initialized", func (n) {

  #set initial position of the cargo models
  var lat = getprop("/position/latitude-deg");
  var lon = getprop("/position/longitude-deg");  
  var alt = 0;

  #property tree location of cargo models
  var model_path = "Aircraft/AirCrane/Models/Cargo-Hauling/";

  #inject new cargo models into the scene
  cargo1 =  place_model( "1",  0, "container-big", model_path~"cargo1.xml", lat, lon, alt, 0, 0, 0);
  cargo2 =  place_model( "2",  1, "container-big", model_path~"cargo1.xml", lat, lon, alt, 0, 0, 0);
  cargo3 =  place_model( "3",  2, "container-big", model_path~"cargo1.xml", lat, lon, alt, 0, 0, 0);
  cargo4 =  place_model( "4",  3, "cub",           model_path~"cargo2.xml", lat, lon, alt, 0, 0, 0);
  cargo5 =  place_model( "5",  4, "tank",          model_path~"cargo3.xml", lat, lon, alt, 0, 0, 0);
  cargo6 =  place_model( "6",  5, "tank-large",    model_path~"cargo4.xml", lat, lon, alt, 0, 0, 0);
  cargo7 =  place_model( "7",  6, "tank-tall",     model_path~"cargo5.xml", lat, lon, alt, 0, 0, 0);
  cargo8 =  place_model( "8",  7, "tank-stand",    model_path~"cargo6.xml", lat, lon, alt, 0, 0, 0);
  cargo9 =  place_model( "9",  8, "pine-tree",     model_path~"cargo7.xml", lat, lon, alt, 0, 0, 0);
  cargo10 = place_model("10",  9, "pine-tree",     model_path~"cargo7.xml", lat, lon, alt, 0, 0, 0);
  cargo11 = place_model("11", 10, "pine-tree",     model_path~"cargo7.xml", lat, lon, alt, 0, 0, 0);
  cargo12 = place_model("12", 11, "pine-tree",     model_path~"cargo7.xml", lat, lon, alt, 0, 0, 0);
  cargo13 = place_model("13", 12, "pine-tree",     model_path~"cargo7.xml", lat, lon, alt, 0, 0, 0);
  cargo14 = place_model("14", 13, "dump-truck",    model_path~"cargo8.xml", lat, lon, alt, 0, 0, 0);

  cargo_init();
});

#################### inject model into scene helper ####################

var place_model = func(string, offset, desc, path, lat, lon, alt, heading, pitch, roll) {

  var m = props.globals.getNode("models", 1);
		  for (var i = 0; 1; i += 1)
			  if (m.getChild("model", i, 0) == nil)
				  break;
  var model = m.getChild("model", i, 1);

  setprop("/models/cargo/cargo["~offset~"]/latitude-deg", lat);
  setprop("/models/cargo/cargo["~offset~"]/longitude-deg", lon);
  setprop("/models/cargo/cargo["~offset~"]/elevation-ft", alt);
  setprop("/models/cargo/cargo["~offset~"]/heading-deg", heading);
  setprop("/models/cargo/cargo["~offset~"]/pitch-deg", pitch);
  setprop("/models/cargo/cargo["~offset~"]/roll-deg", roll);
  setprop("/models/cargo/cargo["~offset~"]/callsign", "cargo"~string);
  setprop("/models/cargo/cargo["~offset~"]/description", desc);

  var cargomodel = props.globals.getNode("/models/cargo/cargo["~offset~"]", 1);
  var latN = cargomodel.getNode("latitude-deg",1);
  var lonN = cargomodel.getNode("longitude-deg",1);
  var altN = cargomodel.getNode("elevation-ft",1);
  var headN = cargomodel.getNode("heading-deg",1);
  var pitchN = cargomodel.getNode("pitch-deg",1);
  var rollN = cargomodel.getNode("roll-deg",1);
  var callsignN = cargomodel.getNode("callsign",1);
  var descriptionN = cargomodel.getNode("description",1);

  model.getNode("path", 1).setValue(path);
  model.getNode("latitude-deg-prop", 1).setValue(latN.getPath());
  model.getNode("longitude-deg-prop", 1).setValue(lonN.getPath());
  model.getNode("elevation-ft-prop", 1).setValue(altN.getPath());
  model.getNode("heading-deg-prop", 1).setValue(headN.getPath());
  model.getNode("pitch-deg-prop", 1).setValue(pitchN.getPath());
  model.getNode("roll-deg-prop", 1).setValue(rollN.getPath());
  model.getNode("callsign-prop", 1).setValue(callsignN.getPath());
  model.getNode("description-prop", 1).setValue(descriptionN.getPath());
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
  var onGround = getprop("gear/gear/wow") * getprop("gear/gear[1]/wow") * getprop("gear/gear[2]/wow");
  var longline = getprop("/sim/gui/dialogs/aicargo-dialog/connection");
  #var cable = getprop("/sim/gui/dialogs/aicargo-dialog/longline");
  var cargoOnGround = getprop("/sim/cargo/hitsground");
  var harnessPos = getprop("sim/cargo/harnessalt");

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

            if (cargoName == "cargo1") {
              cargoWeight = 5000;
              cargoHeight = 2.5;
              cargoHarness = 6.10;
            } else
            if (cargoName == "cargo2") {
              cargoWeight = 1500;
              cargoHeight = 2.5;
              cargoHarness = 6.10;
            } else
            if (cargoName == "cargo3") {
              cargoWeight = 1000;
              cargoHeight = 2.5;
              cargoHarness = 6.10;
            } else
            if (cargoName == "cargo4") {
              cargoWeight = 1200;
              cargoHeight = 1.83;
              cargoHarness = 5.98;
            } else
            if (cargoName == "cargo5") {
              cargoWeight = 2000;
              cargoHeight = 2.42;
              cargoHarness = 6.44;
            } else
            if (cargoName == "cargo6") {
              cargoWeight = 4200;
              cargoHeight = 4.18;
              cargoHarness = 6.02;
            } else
            if (cargoName == "cargo7") {
              cargoWeight = 3000;
              cargoHeight = 3.69;
              cargoHarness = 6.02;
            } else
            if (cargoName == "cargo8") {
              cargoWeight = 600;
              cargoHeight = 2.12;
              cargoHarness = 6.08;
            } else
            if (cargoName == "cargo9" or cargoName == "cargo10" or cargoName == "cargo11" or cargoName == "cargo12" or cargoName == "cargo13") {
              cargoWeight = 250;
              cargoHeight = 2.08;
              cargoHarness = 6.12;
            } else
            if (cargoName == "cargo14") {
              cargoWeight = 4000;
              cargoHeight = 9.3;
              cargoHarness = 10.59;
            }

            if (cargoHeight < 3.0)
              haulable = 1;
            else
              haulable = 0;

            if (longline or haulable) {

              setprop("sim/cargo/cargoharness", -cargoHarness);
              setprop("sim/cargo/cargoheight", -cargoHeight);
              setprop("models/cargo/" ~ cargoParent ~ "/elevation-ft", -999);
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
      } else {
        gui.popupTip("Cargo too tall", 3);
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
        #dist = rope_distance(getprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg") - latNode, getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg") - lonNode);
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
      
      var x = math.cos((headNode+90)*0.0174533);
      var y = math.sin((headNode+90)*0.0174533);
      y = y * -1;
      x = x * .0000239;
      y = y * .0000239;

      setprop("/models/cargo/" ~ cargoParent ~ "/elevation-ft", geo.elevation(latNode-y, lonNode-x) * 3.2808);
      if (!longline)
        setprop("/models/cargo/" ~ cargoParent ~ "/heading-deg", headNode);
      else
        setprop("/models/cargo/" ~ cargoParent ~ "/heading-deg", originalYaw);
        setprop("/models/cargo/" ~ cargoParent ~ "/latitude-deg", latNode-y);
        setprop("/models/cargo/" ~ cargoParent ~ "/longitude-deg", lonNode-x);

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
