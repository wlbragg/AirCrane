# 1 Gallon = 8.345404 lbs * 2650 = 22115 lbs

var capacity = 0.0;
var weight = 8.34;

var tank_operations = func {

	var payload = getprop("sim/model/firetank/enabled");
	var cannon = getprop("sim/model/watercannon/enabled");
	var cannonvalveopen = getprop("sim/model/firetank/opencannonvalve");
	var tankdooropen = getprop("sim/model/firetank/opentankdoors");

	var hopperweight = getprop("sim/weight[3]/weight-lb");

	var scoopdown = getprop("sim/model/firetank/deployramscoop/position-norm");
	var sniffer = getprop("sim/model/firetank/deployflexhose");
	var overland = getprop("gear/gear/ground-is-solid");
	var altitude = getprop("position/altitude-agl-ft");
	var airspeed = getprop("velocities/airspeed-kt");

    if ((!hopperweight or hopperweight < 5) and ((payload and cannon and cannonvalveopen) or (payload and tankdooropen))) {
        logger.screen.white("Hopper is empty");
        #return;
    }
    if (cannonvalveopen and hopperweight and payload and cannon) {
        capacity = 5;
		if (hopperweight > 0) {
        	hopperweight = hopperweight - capacity * weight;
        	setprop("sim/weight[3]/weight-lb", hopperweight);
		}
    }
	if (tankdooropen and hopperweight and payload) {
        capacity = 883; #will be one of 9 modes ,currenty dump load in three seconds
		if (hopperweight > 0) {
        	hopperweight = hopperweight - capacity * weight;
        	setprop("sim/weight[3]/weight-lb", hopperweight);
		}
    }


	if (!overland and scoopdown == 1 and altitude < 26.5 and airspeed > 25) {
		capacity = 66.25;
		if (hopperweight < 22115) {
        	hopperweight = hopperweight + capacity * weight;
			setprop("sim/weight[3]/weight-lb", hopperweight);
		}
	}
	if (!overland and !sniffer and altitude < 27.5 and airspeed < 35) {
		capacity = 55.25;
		if (hopperweight < 22115) {
        	hopperweight = hopperweight + capacity*weight;
			setprop("sim/weight[3]/weight-lb", hopperweight);
		}
	}
}