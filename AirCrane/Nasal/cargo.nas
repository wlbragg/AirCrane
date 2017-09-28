props.Node.new({ "controls/hook-assist":0 });
props.globals.initNode("controls/hook-assist", 0, "BOOL" );
props.Node.new({ "controls/cargo-release":0 });
props.globals.initNode("controls/cargo-release", 0, "BOOL" );
props.Node.new({ "sim/model/cargo-hook":0, "sim/model/cargo-auto-hook":0, "sim/model/cargo-on-hook":0, "sim/model/cargo-height":0 });
props.globals.initNode("sim/model/cargo-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-auto-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-on-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-height", 0, "DOUBLE" );

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
var reset = 0;

var originalLat = 0;
var originalLon = 0;
var new_x = 0;
var new_y = 0;

var cargo_create = func () {

  var ct=0;
	foreach(var cargoN; props.globals.getNode("/ai/models", 1).getChildren("aircraft")){
		if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
			ct+=.001;
			
			setprop("sim/model/"~cargoN.getNode("callsign").getValue()~"-onhook", 0);
			setprop("controls/release-"~cargoN.getNode("callsign").getValue(), 0);

      if (getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/saved") == 1) {
        cargoN.getNode("position/latitude-deg").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/latitude-deg"));
		    cargoN.getNode("position/longitude-deg").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/longitude-deg"));	
	      cargoN.getNode("position/altitude-ft").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/position/altitude-ft"));
        cargoN.getNode("orientation/true-heading-deg").setDoubleValue(getprop("/sim/model/aircrane/"~cargoN.getNode("callsign").getValue()~"/orientation/true-heading-deg"));
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
		      cargoN.getNode("position/latitude-deg").setDoubleValue(getprop("position/latitude-deg")+y);
		      cargoN.getNode("position/longitude-deg").setDoubleValue(getprop("position/longitude-deg")+x);
		      cargoN.getNode("orientation/true-heading-deg").setDoubleValue(rand()*360);
		      var elev_m = geo.elevation(cargoN.getNode("position/latitude-deg").getValue(), cargoN.getNode("position/longitude-deg").getValue());
	        cargoN.getNode("position/altitude-ft").setDoubleValue(elev_m * 3.2808);
        }

	    print( "Cargo Created:" ~ 
	        cargoN.getNode("callsign").getValue() ~ "\n" ~ 
	        cargoN.getNode("position/latitude-deg").getValue() ~ "/" ~ 
	        cargoN.getNode("position/longitude-deg").getValue() ~ "\nElev-ft:" ~ 
	        cargoN.getNode("position/altitude-ft").getValue() ~ "\nHead:" ~ 
	        cargoN.getNode("orientation/true-heading-deg").getValue() ~ "\n");
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
  setprop("/a1-minDist", minDist);
  return dist; 
}

var rope_distanceNEW = func (dlat, dlon) {
  var sdist = dlat * dlat + dlon * dlon;
  var ndist = math.sqrt(sdist);
  if(ndist < minDistNEW) {
    minDistNEW = ndist;
  }
  setprop("/a1-minDistNEW", minDistNEW);
  return ndist;
}

var cargo_tow = func () {

  var hookNode = getprop("sim/model/cargo-hook");
  var autoHookNode = getprop("sim/model/cargo-auto-hook");
  var onHookNode = getprop("sim/model/cargo-on-hook");
  var releaseNode = getprop("controls/cargo-release");
  var lonNode = getprop("/position/longitude-deg");
  var latNode = getprop("/position/latitude-deg");
  var altNode = getprop("/position/altitude-agl-ft");
  var groundNode = getprop("/position/gear-agl-m");
  var groundElevFt = getprop("/position/ground-elev-ft");
  var headNode = getprop("/orientation/heading-deg");
  var onGround = getprop("gear/gear/wow") * getprop("gear/gear[1]/wow") * getprop("gear/gear[2]/wow");
  var longline = getprop("/sim/gui/dialogs/aicargo-dialog/rope");
  var ropeOnGround = getprop("/sim/model/cargo/rope/ropehitsground");
  var cargoWeight = 0;
 
  hookDistance = getprop("/a1-hookDistAdd");

  if (longline) {
    hookHeight = 43;
    hookDistance = 2.5e-8
  } else {
    hookHeight = 15;
    hookDistance = 1e-9;
  }

	if(onHookNode == 0 and (altNode < hookHeight) and cargoReleased == 0) {
    #gui.popupTip("In Ranging", 1);
		foreach(var cargoN; props.globals.getNode("/ai/models", 1).getChildren("aircraft")) {
			if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
        dist = rope_distance(cargoN.getNode("position/latitude-deg").getValue() - latNode, cargoN.getNode("position/longitude-deg").getValue() - lonNode);
        var distNEW = rope_distanceNEW(cargoN.getNode("position/latitude-deg").getValue() - latNode, cargoN.getNode("position/longitude-deg").getValue() - lonNode);

setprop("/a1-dist", dist);
setprop("/a1-distNEW", distNEW);
setprop("/a2-hookdist", hookDistance);
setprop("/a3-altNode", altNode);
setprop("/a4-hookHeight", hookHeight);

        if(dist <= hookDistance) {
					gui.popupTip(cargoN.getNode("callsign").getValue()~" in Range", 1);
					if (hookNode == 1 or autoHookNode == 1) {
						hooked = 1;
						cargoParent = cargoN.getNode("callsign").getParent().getName() ~ "[" ~ cargoN.getNode("callsign").getParent().getIndex() ~ "]";
						cargoName = cargoN.getNode("callsign").getValue();

            setprop("sim/model/cargo-on-hook", 1);
						setprop("sim/model/"~cargoName~"-onhook", 1);

            #TODO: is this the approprate place and method to do this?
            if ((cargoName == "cargo1") or (cargoName == "cargo2") or (cargoName == "cargo3"))
              setprop("sim/model/cargo-height", -2.7);
            else
              setprop("sim/model/cargo-height", 0);

            #maybe condition to only if longline
            currentYaw = (headNode+(headNode-cargoN.getNode("orientation/true-heading-deg").getValue()))-headNode;
            originalYaw = cargoN.getNode("orientation/true-heading-deg").getValue();
            if (currentYaw > 360) currentYaw = currentYaw - 360;
            if (currentYaw < 0) currentYaw = currentYaw + 360;
            setprop("/sim/model/cargo/currentyaw", currentYaw);

            originalLat = latNode;
            originalLon = lonNode;

            if (cargoName == "cargo1")
              cargoWeight = 8377;
            if (cargoName == "cargo2")
              cargoWeight = 5070;
            if (cargoName == "cargo3")
              cargoWeight = 2000;
            if (cargoName == "cargo4")
              cargoWeight = 1200;

            setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", -999);
            setprop("/sim/model/cargo/currentalt", (-groundNode) + 14.8 + getprop("/xfactor"));

            setprop("/sim/model/cargo/rope/damping", 0.6);
            setprop("/sim/model/cargo/rope/flex-force", 0.01);
            #setprop("/sim/model/cargo/rope/stiffness", 3);
					} 
				}
			}
		}
	}
  if (hooked == 1) {

setprop("/a1-dist", dist);
setprop("/a2-hookdist", hookDistance);
setprop("/a3-altNode", altNode);
setprop("/a4-hookHeight", hookHeight);

    if ((longline and !ropeOnGround) or !longline) {
      # TODO: -optimize- some of this this may need to only happen once, each time the condition becomes true VS every loop

      currentYaw = (headNode+(headNode-originalYaw))-headNode;
      if (currentYaw > 360) currentYaw = currentYaw - 360;
      if (currentYaw < 0) currentYaw = currentYaw + 360;
      setprop("/sim/model/cargo/currentyaw", currentYaw);

      setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", -999);
      setprop("/sim/model/cargo/currentalt", 0);

      setprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg", latNode);
      setprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg", lonNode);
      #reset = 1;

      setprop("sim/weight[3]/weight-lb", cargoWeight);
      
      #originalLat = latNode;
      #originalLon = lonNode;
      #setprop("/sim/model/cargo/currentposx", 0);
      #setprop("/sim/model/cargo/currentposy", 0);
      
    } else {
      dist = rope_distance(getprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg") - latNode, getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg") - lonNode);
      if(dist <= hookDistance and ropeOnGround) {
        
        #reset = 0;

        currentYaw = (headNode+(headNode-originalYaw))-headNode;
        if (currentYaw > 360) currentYaw = currentYaw - 360;
        if (currentYaw < 0) currentYaw = currentYaw + 360;
        setprop("/sim/model/cargo/currentyaw", currentYaw);

        #setprop("/sim/model/cargo/currentalt", -100);
        #setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", groundElevFt);
        setprop("/sim/model/cargo/currentalt", (-groundNode) + 14.8 + getprop("/xfactor"));

        setprop("sim/weight[3]/weight-lb", 0);

        #setprop("/sim/model/cargo/currentalt", (-groundNode) + 14.8 + getprop("/xfactor"));
        #111,111 meters (111.111 km) in the y direction is 1 degree (of latitude) 
        #111,111 * cos(latitude) meters in the x direction is 1 degree (of longitude).
        #(90-lat)/90
        #new_x = (originalLon - lonNode) * 111320 * math.cos(latNode);
        #new_y = (originalLat - latNode) * 111320;
        #setprop("/sim/model/cargo/currentposx", new_x);
        #setprop("/sim/model/cargo/currentposy", new_y);

      } else {

        #TODO: add x and y transformation to move cargo (incrementally) towards aircrane as rope is taut and pulling cargo 

        currentYaw = (headNode+(headNode-originalYaw))-headNode;
        if (currentYaw > 359) currentYaw = currentYaw - 360;
        if (currentYaw < 0) currentYaw = currentYaw + 360;
        setprop("/sim/model/cargo/currentyaw", currentYaw);

        setprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg", latNode);
        setprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg", lonNode);
        #reset = 1;

        setprop("sim/weight[3]/weight-lb", cargoWeight);

        #originalLat = latNode;
        #originalLon = lonNode;
        #setprop("/sim/model/cargo/currentposx", 0);
        #setprop("/sim/model/cargo/currentposy", 0);

setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", -999);
setprop("/sim/model/cargo/currentalt", (-groundNode) + 14.8 + getprop("/xfactor"));
       
      }
    }

    #gui.popupTip(cargoName~" in Tow", 1);
		if (releaseNode == 1 and onHookNode == 1) {
      if (onGround or (longline and ropeOnGround)) {
        setprop("sim/model/cargo-on-hook", 0);
        setprop("controls/cargo-release", 0);
			  hooked = 0;
        setprop("sim/model/cargo-hook", 0);
			  cargoReleased = 1;
			  #gui.popupTip("Cargo Released", 3);
			  setprop("sim/model/"~cargoName~"-onhook", 0);
			  setprop("controls/release-"~cargoName, 1);
      } else {
        gui.popupTip("Cargo Not On Ground", 1);
        setprop("controls/cargo-release", cargoReleased = 0);
      }
		}
	} else {
		if (autoHookNode == 1) {
			gui.popupTip("Auto Hook Engaged", 1);
		}
		#release auto.hook by pressing hook
		if (hookNode == 1 and autoHookNode == 1) {
      setprop("sim/model/cargo-auto-hook", 0);
      setprop("sim/model/cargo-hook", 0);
		}
	}
	if (cargoReleased == 1) {
      gui.popupTip(cargoName~" Released", 1);

      setprop("sim/weight[3]/weight-lb", 0);

      setprop("/sim/model/cargo/rope/damping", 0.6);
      setprop("/sim/model/cargo/rope/flex-force", 0.09);
      #setprop("/sim/model/cargo/rope/stiffness", 3);

      var x = math.cos((headNode+90)*0.0174533);
      var y = math.sin((headNode+90)*0.0174533);
      y = y * -1;
      x = x * .0000239;
      y = y * .0000239;

      setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", groundElevFt);
      #setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", geo.elevation(latNode-y, lonNode-x) * 3.2808);
      if (!longline)
        setprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg", headNode);
      else
        setprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg", originalYaw);
      #if (reset or !longline) {
        setprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg", latNode-y);
        setprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg", lonNode-x);
      #}

      if (getprop("/sim/model/aircrane/"~cargoName~"/saved")) {
        gui.popupTip(cargoName~" position saved", 1);
        setprop("/sim/model/aircrane/"~cargoName~"/position/latitude-deg", getprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg"));
        setprop("/sim/model/aircrane/"~cargoName~"/position/longitude-deg", getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg"));
        setprop("/sim/model/aircrane/"~cargoName~"/position/altitude-ft", getprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft"));
        setprop("/sim/model/aircrane/"~cargoName~"/orientation/true-heading-deg", getprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg"));
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
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lat", getprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg"));
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lon", getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg"));
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_alt", getprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft"));
      #  setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head", getprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg"));
      #}
	}	

	settimer(cargo_tow, interval);

}

setlistener("/sim/signals/fdm-initialized", cargo_create);