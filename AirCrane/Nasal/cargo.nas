props.Node.new({ "controls/hook-assist":0 });
props.globals.initNode("controls/hook-assist", 0, "BOOL" );
props.Node.new({ "controls/cargo-release":0 });
props.globals.initNode("controls/cargo-release", 0, "BOOL" );
props.Node.new({ "sim/model/cargo-hook":0, "sim/model/cargo-auto-hook":0, "sim/model/cargo-on-hook":0 });
props.globals.initNode("sim/model/cargo-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-auto-hook", 0, "BOOL" );
props.globals.initNode("sim/model/cargo-on-hook", 0, "BOOL" );

var AircraftCargo = {};
var parents = [AircraftCargo];
var cargoParent = "";
var cargoName = "";
var hookDistance = 1e-8;
#var hookDistance = 1e-9;
#hardDock (meters)
var hookHeight = 15;
#ropeTow (meters)
#var hookHeight = 110;
var hooked = 0;
var cargoReleased = 0;
var minDist = 999;
#var interval = .025;
var interval = 0;

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

var cargo_tow = func () {

  var hookNode = getprop("sim/model/cargo-hook");
  var autoHookNode = getprop("sim/model/cargo-auto-hook");
  var onHookNode = getprop("sim/model/cargo-on-hook");
  var releaseNode = getprop("controls/cargo-release");
  var lonNode = getprop("/position/longitude-deg");
  var latNode = getprop("/position/latitude-deg");
  var altNode = getprop("/position/altitude-agl-ft");
  var headNode = getprop("/orientation/heading-deg");
  var onGround = getprop("gear/gear/wow") * getprop("gear/gear[1]/wow") * getprop("gear/gear[2]/wow");

	if(onHookNode == 0 and (altNode < hookHeight) and cargoReleased == 0) {
    #gui.popupTip("In Ranging", 1);
		foreach(var cargoN; props.globals.getNode("/ai/models", 1).getChildren("aircraft")) {
			if (string.match(cargoN.getNode("callsign").getValue(), "cargo*")){
				if(hooked == 0) {
					var dlat = cargoN.getNode("position/latitude-deg").getValue() - latNode;
					var dlon = cargoN.getNode("position/longitude-deg").getValue() - lonNode;
					var dist = dlat * dlat + dlon * dlon;
					if(dist < minDist) {
						minDist = dist;
					}
					#hardDock
					if(dist <= hookDistance) { 
					#towRope in meters 103
					#if(dist <= hookDistance and altNode > 103) {
						gui.popupTip(cargoN.getNode("callsign").getValue()~" in Range", 1);
						if (hookNode == 1 or autoHookNode == 1) {
							hooked = 1;
							cargoParent = cargoN.getNode("callsign").getParent().getName() ~ "[" ~ cargoN.getNode("callsign").getParent().getIndex() ~ "]";
							cargoName = cargoN.getNode("callsign").getValue();
              setprop("sim/model/cargo-on-hook", 1);
							setprop("sim/model/"~cargoName~"-onhook", 1);
							cargoN.getNode("position/altitude-ft").setDoubleValue(-999);
						} 
					}
				}
			}
		}
	}
  if (hooked == 1) {
    #gui.popupTip(cargoName~" in Tow", 1);
		if (releaseNode == 1 and onHookNode == 1) {
      if (onGround) {
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
		  var x = math.cos((headNode+90)*0.0174533);
		  var y = math.sin((headNode+90)*0.0174533);
      y = y * -1;
		  x = x * .0000239;
		  y = y * .0000239;

      setprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg", latNode-y);
      setprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg", lonNode-x);
      setprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg", headNode);
      setprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft", geo.elevation(latNode-y, lonNode-x) * 3.2808);
   
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
      var aic = getprop("/sim/gui/dialogs/aicargo-dialog/ai-path");
      if (aic != nil and aic == cargoParent) {
        setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lat", getprop("/ai/models/" ~ cargoParent ~ "/position/latitude-deg"));
        setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lon", getprop("/ai/models/" ~ cargoParent ~ "/position/longitude-deg"));
        setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_alt", getprop("/ai/models/" ~ cargoParent ~ "/position/altitude-ft"));
        setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head", getprop("/ai/models/" ~ cargoParent ~ "/orientation/true-heading-deg"));

        fgcommand("dialog-close", props.Node.new({"dialog-name": "aicargo-dialog"}));
        fgcommand("dialog-show", props.Node.new({"dialog-name": "aicargo-dialog"}));
      }
	}	

	settimer(cargo_tow, interval);

}

setlistener("/sim/signals/fdm-initialized", cargo_create);