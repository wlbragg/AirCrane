# 1 Gallon = 8.345404 lbs * 2500 = 20863 lbs

var capacity = 0.0;

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

    #if (!hopperweight and ((payload and cannon and cannonvalveopen) or (payload and tankdooropen))) {
    #    logger.screen.white("Hopper is empty");
        #return;
    #}
    if (cannonvalveopen and hopperweight and payload and cannon) {
		#300 * 8.345 weight per gal = 2503.5 weight per minute / 60 = 41.72 per second / 4 (.25 seconds timer cycle) = 10.43 capacity per cycle
 		#300 gal per minute / 60 = 5 per second / 4 (.25 seconds timer cycle) = 1.25 per cycle * 8.345 weight per gallon = 10.43 capacity per cycle
        capacity = 10.43; 
		if (hopperweight > 0)
        	hopperweight = hopperweight - capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
    }
	if (tankdooropen and hopperweight and payload) {
		#2500 gal * 8.345 weight per gal = 20862.5 / 3 sec dump = 6954.17 per sec / 4 (.25 seconds timer cycle) = 1738.54 capacity per cycle
		#2500 gal / 3 sec dump = 833.33 per second / 4 (.25 seconds timer cycle) = 208.33 * 8.345 weight per gallon = 1738.51 capacity per cycle
        capacity = 1738.53; #will be one of 9 modes, currenty dump load in three seconds
		if (hopperweight > 0) 
        	hopperweight = hopperweight - capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
    }

	if (!overland and scoopdown == 1 and altitude < 26.5 and airspeed > 25) {
		#2500 gal * 8.345 weight per gal = 20862.5 / 40 second fill = 521.56 per sec / 4 (.25 seconds timer cycle) = 130.39 capacity per cycle
		#2500 gal / 40 sec = 62.5 per sec / 4 (.25 seconds timer cycle) = 15.62 * 8.345 weight per gallon = 130.35 capacity per cycle
		capacity = 130.37;
		if (hopperweight < 20000) 
        	hopperweight = hopperweight + capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
	}
	if (!overland and !sniffer and altitude < 27.5 and airspeed < 35) {
		#2500 gal * 8.345 weight per gal = 20862.5 / 45 second fill = 463.61 per sec / 4 (.25 seconds timer cycle) = 115.90 capacity per cycle
		#2500 gal / 45 sec = 55.55 per second / 4 (.25 seconds timer cycle) = 13.89 * 8.345 weight per gallon = 115.91 capacity per cycle
		capacity = 115.91;
		if (hopperweight < 20000) 
        	hopperweight = hopperweight + capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
	}

	if (hopperweight < 0) {
		hopperweight = 0;
		setprop("sim/weight[3]/weight-lb", hopperweight);
	}
}