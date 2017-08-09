# 1 Gallon = 8.345404 lbs * 2500 = 20863 lbs

var capacity = 0.0;
var flex_angle_v_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var flex_angle_vr_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var flex_angle_r_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var onground_flag = 0;
var drop_flag = 0;

var tank_operations = func {
			

	var payload = getprop("sim/model/firetank/enabled");
	var paused = getprop("sim/freeze/clock");
	var crashed = getprop("sim/crashed");

  if (!payload or crashed or paused) {
    setprop("sim/model/firetank/waterdropparticlectrl", 0);
    setprop("sim/model/firetank/waterdropretardantctrl", 0);
    setprop("sim/model/firetank/watercannonparticlectrl", 0);
    setprop("sim/model/firetank/watercannonretardantctrl", 0);
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
	var particles = getprop("sim/model/aircrane/effects/particles/enabled");
	var normalized = 1-(altitude-0)/(60-0);

	setprop("/sim/model/aircrane/effects/particles/redcombined", getprop("/rendering/scene/diffuse/red")*.95);
	setprop("/sim/model/aircrane/effects/particles/greencombined", getprop("/rendering/scene/diffuse/red")*.98);
	setprop("/sim/model/aircrane/effects/particles/bluecombined", getprop("/rendering/scene/diffuse/red")*1);

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

	#################### flexhose ####################

	var alt_agl = altitude * 0.3048 + getprop("/sim/model/firetank/flexhose/offset");
	var n_segments = 31;
	var segment_length = getprop("/sim/model/firetank/flexhose/factor");

	if (overland)
		{
			if (alt_agl - n_segments * segment_length < 0.0)
			   {
				  onground_flag = 1;
			   }
			else
				  onground_flag = 0;
		} 
	else
		{
		   onground_flag = 0;
		}

	setprop("/sim/model/firetank/flexhose/hosehitsground", onground_flag);

	if (sniffer == 1) 
		{
			drop_flag = 50;
			return;
		}
	else
		if (drop_flag > 1 and !onground_flag)
			drop_flag -= 1;
		else
			{
				#setprop("sim/model/firetank/deployflexhose/position-norm", 0);
				#sniffer = 0;
				drop_flag = 0;
			}

	var flex_force = getprop("/sim/model/firetank/flexhose/flex-force");
	var damping = getprop("/sim/model/firetank/flexhose/damping");
	var stiffness = getprop("/sim/model/firetank/flexhose/stiffness");
	var sum_angle = 0.0;
	var dt = getprop("/sim/time/delta-sec");
	var bend_force = getprop("/sim/model/firetank/flexhose/bendforce");
	var angle_correction = getprop("/sim/model/firetank/flexhose/correction");

	if (onground_flag == 0)
		{
			if (drop_flag and overland) 
				{
					var ax = drop_flag;
					var ay = 0;
					var az = -60;
				}
			else
				{
					var ax = getprop("/accelerations/pilot/x-accel-fps_sec");
					var ay = getprop("/accelerations/pilot/y-accel-fps_sec");
					var az = getprop("/accelerations/pilot/z-accel-fps_sec");
				}
		}
	else
		{
			var ax = 0;
			var ay = 0;
			var az = 0;
		}

	var a = math.sqrt(ax* ax + ay*ay + az*az);

	if (a==0.0) {a=1.0;}

	var ref_ang1 = math.asin(ax/a) * 180.0/math.pi;
	var ref_ang2 = math.asin(ay/a) * 180.0/math.pi;

	var damping_factor = math.pow(damping, dt);

	if (onground_flag == 0)
	   {

	   var current_angle = getprop("/sim/model/firetank/flexhose/pitch1");
	   var ang_error = ref_ang1 - current_angle;

	   flex_angle_v_array[0] += ang_error * stiffness * dt;
	   flex_angle_v_array[0] *= damping_factor;

	   var ang_speed = flex_angle_v_array[0];

	   setprop("/sim/model/firetank/flexhose/pitch1", current_angle + dt * ang_speed);

	   var current_roll = getprop("/sim/model/firetank/flexhose/roll1");
	   ang_error = ref_ang2 - current_roll;


	   flex_angle_vr_array[0] +=  ang_error * stiffness * dt;
	   flex_angle_vr_array[0] *= damping_factor;

	   ang_speed = flex_angle_vr_array[0];

	   var next_roll =  current_roll + dt * ang_speed;
	   setprop("/sim/model/firetank/flexhose/roll1", next_roll);

	   # kink excitation
	   
	   var kink =  -(next_roll - flex_angle_r_array[0]);
	   
	   setprop("/sim/model/firetank/flexhose/roll2",  kink) ;
	   flex_angle_r_array[1] = kink;

	   }
	else
	   {

	   setprop("/sim/model/firetank/flexhose/pitch1", ref_ang1);
	   setprop("/sim/model/firetank/flexhose/roll1", ref_ang2);

	   }

	var roll_target = 0.0;

	for (var i = 1; i< n_segments; i=i+1)
	   	{

	   	var gravity = n_segments - i;

		var velocity = getprop("/velocities/equivalent-kt") - (drop_flag*2);

		if (velocity == nil) {velocity = 0;}
		if (velocity > 500.0) {velocity = 500.0;}

		var dist_above_ground = alt_agl - (i+1) * segment_length;

		var force = flex_force * math.cos(sum_angle * math.pi/180.0) * 0.05 * velocity;

		if (overland)
		{
		   if (dist_above_ground < 0.0)
			  {
			  force = force + bend_force * math.cos(sum_angle * math.pi/180.0);
			  }
		}

		if (force > 1.0 * gravity) {force = 1.0 * gravity;}

		var angle = - 180.0 /math.pi * math.atan2(force, gravity);#(force/gravity);
		sum_angle += angle;

		if (onground_flag == 0)
		  {
		  current_angle = getprop("/sim/model/firetank/flexhose/pitch"~(i+1));
		  ang_error = angle - current_angle;


		  flex_angle_v_array[i] += ang_error * stiffness * dt;
		  flex_angle_v_array[i] *= damping_factor;

		  ang_speed = flex_angle_v_array[i];

		  setprop("/sim/model/firetank/flexhose/pitch"~(i+1), current_angle + dt * ang_speed);

		  # the transverse dynamics is largely waves excited by the helicopter

		  if (i==1) # this is set by the kink excitation
			 {
			 continue;
			 }   
		  else
			 {
			 roll_target =  flex_angle_r_array[i-1];
			 }

		  ang_error = roll_target - flex_angle_r_array[i];

		  flex_angle_vr_array[i] += ang_error * stiffness * dt;
		  flex_angle_vr_array[i] *= damping_factor;

		  ang_speed = flex_angle_vr_array[i];

		  setprop("/sim/model/firetank/flexhose/roll"~(i+1), roll_target);

		  }
		else
		  {
		  setprop("/sim/model/firetank/flexhose/pitch"~(i+1), angle + angle_correction);
		  setprop("/sim/model/firetank/flexhose/roll"~(i+1), 0.0);
		  }

		}

	# copy the current values into the last step array

	for (var i = 0; i< n_segments; i=i+1)
	   {
	   flex_angle_r_array[i] = getprop("/sim/model/firetank/flexhose/roll"~(i+1));
	   }

}