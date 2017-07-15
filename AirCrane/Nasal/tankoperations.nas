# 1 Gallon = 8.345404 lbs * 2500 = 20863 lbs

var capacity = 0.0;

var tank_operations = func {
			

	var payload = getprop("sim/model/firetank/enabled");
	var paused = getprop("sim/freeze/clock");
	var crashed = getprop("sim/crashed");

	if (!payload or crashed or paused) {
		setprop("waterdropparticlectrl", 0);
		setprop("waterdropretardantctrl", 0);
		setprop("watercannonparticlectrl", 0);
		setprop("watercannonretardantctrl", 0);
        return;
    }

	var cannon = getprop("sim/model/watercannon/enabled");
	var cannonvalveopen = getprop("sim/model/firetank/opencannonvalve");
	var tankdooropen = getprop("sim/model/firetank/opentankdoors");
	var hopperweight = getprop("sim/weight[3]/weight-lb");
	var scoopdown = getprop("sim/model/firetank/deployramscoop/position-norm");
	var sniffer = getprop("sim/model/firetank/deployflexhose/position-norm");
	var overland = getprop("gear/gear/ground-is-solid");
	var altitude = getprop("position/altitude-agl-ft");
	var airspeed = getprop("velocities/airspeed-kt");
	var particles = getprop("sim/model/aircrane/particles/enabled");
	var normalized = 1-(altitude-0)/(55-0);

	setprop("sim/model/firetank/waterdropparticlectrl", tankdooropen*hopperweight*particles);
	setprop("sim/model/firetank/watercannonparticlectrl", cannonvalveopen*hopperweight*particles);

	if (!overland and particles and altitude < 27.5 and (sniffer > 0 and sniffer < 1) and sniffer < normalized)
		setprop("sim/model/firetank/snorkelsplashparticlectrl", 1);
	else
		setprop("sim/model/firetank/snorkelsplashparticlectrl", 0);

	if (hopperweight) {
		if (tankdooropen)
			setprop("sim/model/firetank/waterdropretardantctrl", 1);
		else
			setprop("sim/model/firetank/waterdropretardantctrl", 0);
		if (cannon and cannonvalveopen)
			setprop("sim/model/firetank/watercannonretardantctrl", 1);
		else
			setprop("sim/model/firetank/watercannonretardantctrl", 0);
	} else {
		setprop("sim/model/firetank/waterdropretardantctrl", 0);
		setprop("sim/model/firetank/watercannonretardantctrl", 0);
	}
		
    if (cannonvalveopen and hopperweight and cannon) {
		#300 * 8.345 weight per gal = 2503.5 weight per minute / 60 = 41.72 per second / 4 (.25 seconds timer cycle) = 10.43 capacity per cycle
 		#300 gal per minute / 60 = 5 per second / 4 (.25 seconds timer cycle) = 1.25 per cycle * 8.345 weight per gallon = 10.43 capacity per cycle
        capacity = 10.43; 
		if (hopperweight > 0)
        	hopperweight = hopperweight - capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
    }
	if (tankdooropen and hopperweight) {
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

var flex_hose = func {

	var deg_rot = sin(getprop("sim/model/firetank/deployflexhose/position-norm")*0.01745329252);
	var trans_factorX = getprop("sim/model/firetank/cradleX");
	var trans_factorY = getprop("sim/model/firetank/cradleY");
	var trans_factorZ = getprop("sim/model/firetank/cradleZ");

	setprop("sim/model/firetank/cradleX1", (.5*trans_factorX*deg_rot));
	setprop("sim/model/firetank/cradleX2", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX1"));
	setprop("sim/model/firetank/cradleX3", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX2"));
	setprop("sim/model/firetank/cradleX4", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX3"));
	setprop("sim/model/firetank/cradleX5", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX4"));
	setprop("sim/model/firetank/cradleX6", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX5"));
	setprop("sim/model/firetank/cradleX7", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX6"));
	setprop("sim/model/firetank/cradleX8", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX7"));
	setprop("sim/model/firetank/cradleX9", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX8"));
	setprop("sim/model/firetank/cradleX10", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX9"));
	setprop("sim/model/firetank/cradleX11", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX10"));
	setprop("sim/model/firetank/cradleX12", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX11"));
	setprop("sim/model/firetank/cradleX13", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX12"));
	setprop("sim/model/firetank/cradleX14", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX13"));
	setprop("sim/model/firetank/cradleX15", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX14"));
	setprop("sim/model/firetank/cradleX16", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX15"));
	setprop("sim/model/firetank/cradleX17", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX16"));
	setprop("sim/model/firetank/cradleX18", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX17"));

	#left/right offset
	setprop("sim/model/firetank/cradleY1", (.5*trans_factorY*deg_rot));
	setprop("sim/model/firetank/cradleY2", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY1"));
	setprop("sim/model/firetank/cradleY3", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY2"));
	setprop("sim/model/firetank/cradleY4", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY3"));
	setprop("sim/model/firetank/cradleY5", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY4"));
	setprop("sim/model/firetank/cradleY6", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY5"));
	setprop("sim/model/firetank/cradleY7", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY6"));
	setprop("sim/model/firetank/cradleY8", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY7"));
	setprop("sim/model/firetank/cradleY9", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY8"));
	setprop("sim/model/firetank/cradleY10", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY9"));
	setprop("sim/model/firetank/cradleY11", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY10"));
	setprop("sim/model/firetank/cradleY12", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY11"));
	setprop("sim/model/firetank/cradleY13", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY12"));
	setprop("sim/model/firetank/cradleY14", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY13"));
	setprop("sim/model/firetank/cradleY15", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY14"));
	setprop("sim/model/firetank/cradleY16", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY15"));
	setprop("sim/model/firetank/cradleY17", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY16"));
	setprop("sim/model/firetank/cradleY18", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY17"));

	#up/down offset
	setprop("sim/model/firetank/cradleZ1", (.5*trans_factorZ*deg_rot));
	setprop("sim/model/firetank/cradleZ2", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ1"));
	setprop("sim/model/firetank/cradleZ3", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ2"));
	setprop("sim/model/firetank/cradleZ4", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ3"));
	setprop("sim/model/firetank/cradleZ5", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ4"));
	setprop("sim/model/firetank/cradleZ6", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ5"));
	setprop("sim/model/firetank/cradleZ7", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ6"));
	setprop("sim/model/firetank/cradleZ8", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ7"));
	setprop("sim/model/firetank/cradleZ9", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ8"));
	setprop("sim/model/firetank/cradleZ10", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ9"));
	setprop("sim/model/firetank/cradleZ11", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ10"));
	setprop("sim/model/firetank/cradleZ12", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ11"));
	setprop("sim/model/firetank/cradleZ13", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ12"));
	setprop("sim/model/firetank/cradleZ14", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ13"));
	setprop("sim/model/firetank/cradleZ15", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ14"));
	setprop("sim/model/firetank/cradleZ16", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ15"));
	setprop("sim/model/firetank/cradleZ17", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ16"));
	setprop("sim/model/firetank/cradleZ18", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ17"));

}