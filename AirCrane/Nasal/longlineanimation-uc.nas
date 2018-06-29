#################### long line ####################

var rope_angle_v_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var rope_angle_vr_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var rope_angle_r_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

var onground_flag = 0;
var cargoOnGround_flag = 0;

var aircraft_roll_last = 0.0;

var pull_factor_pitch = 0;

var rope_pos = 0.0;
var ground_friction = 0.0;
var ground_contact = 0;
var n_segments_piled = 0; 
var n_segments_straight = 0;
var n_segments = 90;
var segment_length = getprop("/sim/cargo/rope/factor");

var longline_animation = func (reset) {

	var overland = getprop("gear/gear/ground-is-solid");
  if (getprop("sim/gui/dialogs/aicargo-dialog/alt-origin"))
    var altitude = getprop("/position/altitude-agl-ft") - 13.3;
  else
    var altitude = getprop("position/true-agl-ft");
	var alt_agl = altitude * 0.3048 + getprop("/sim/cargo/rope/offset");
  var cargo_on_hook = getprop("sim/cargo/cargo-on-hook");
  var cargo_height = getprop("/sim/cargo/cargoheight");
  var cargo_harness = getprop("/sim/cargo/cargoharness");

  var load_damping = getprop("/sim/cargo/rope/load-damping");
	var flex_force = getprop("/sim/cargo/rope/flex-force");
	var damping = getprop("/sim/cargo/rope/damping");
	var stiffness = getprop("/sim/cargo/rope/stiffness");
	var sum_angle = 0.0;
	var dt = getprop("/sim/time/delta-sec");
  var bend_force = getprop("/sim/cargo/rope/bendforce");
	var angle_correction = getprop("/sim/cargo/rope/correction");
  var cargoWeight = getprop("sim/weight[3]/weight-lb");

	var aircraft_pitch = getprop("/orientation/pitch-deg");
	var aircraft_roll = getprop("/orientation/roll-deg");

  var pulling = getprop("sim/cargo/rope/pulling");

  var coil_flag = getprop("/sim/cargo/rope/coil-flag"); 
  var coil_factor = getprop("/sim/cargo/rope/coil-factor");
  var i_segment_firstground = -1;
  var n_segments_reeled = getprop("/sim/cargo/rope/segments-reeled-in");

  var winch = getprop("sim/gui/dialogs/aicargo-dialog/connection");

  #var lonNode = getprop("/position/longitude-deg");
  #var latNode = getprop("/position/latitude-deg");

  if(getprop("sim/gui/dialogs/aicargo-dialog/longline")) 
    setprop("/sim/cargo/rope/stiffness", 20);
  else
    setprop("/sim/cargo/rope/stiffness", 10);

  if (!winch and n_segments_reeled > 0)
    {
      n_segments_reeled = 0;
      reset = 1;
      setprop("/sim/cargo/rope/segments-reeled-in", n_segments_reeled);
    }

  if (reset)
    {
      var ax = 0;
			var ay = 0;
			var az = 0;
      for (var i = 0; i < n_segments; i+=1)
        {
          setprop("/sim/cargo/rope/pitch"~i, 0.0);
          setprop("/sim/cargo/rope/roll"~i, 0.0);
          rope_angle_r_array[i] = 0.0;
        }
      reset = 0;
    }

  if (overland)
    {
      if ((((alt_agl+1.6) - ((n_segments - n_segments_reeled) * segment_length)) + cargo_harness + cargo_height) < 0.0)
        cargoOnGround_flag = 1;
      else
        cargoOnGround_flag = 0;

      setprop("/sim/cargo/hitsground", cargoOnGround_flag);

      if ((alt_agl+6.6) - ((n_segments - n_segments_reeled) * segment_length) < 0.0)
			  onground_flag = 1;
		  else
			  onground_flag = 0;
    }
  else
	  {
      #TODO: decide how to handel this event, slowly allow to sink?
	    onground_flag = 0;
      setprop("/sim/cargo/hitsground", 0);
	  }

	if (onground_flag == 0)
		{
			var ax = getprop("/accelerations/pilot/x-accel-fps_sec");
			var ay = getprop("/accelerations/pilot/y-accel-fps_sec");
			var az = getprop("/accelerations/pilot/z-accel-fps_sec");
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

  #########################

  if (cargo_on_hook and pulling) {
    pull_factor_pitch = getprop("/sim/cargo/rope/pull-factor-pitch");
    setprop("/sim/cargo/rope/pitch"~(1+n_segments_reeled), pull_factor_pitch);
  } else {
	if (onground_flag == 0)
	  {
      var current_angle = getprop("/sim/cargo/rope/pitch"~(1+n_segments_reeled));

      var ang_error = ref_ang1 - current_angle;

      rope_angle_v_array[n_segments_reeled] += ang_error * stiffness * dt;
      rope_angle_v_array[n_segments_reeled] *= damping_factor;

      var ang_speed = rope_angle_v_array[n_segments_reeled];

      setprop("/sim/cargo/rope/pitch"~(1+n_segments_reeled), current_angle + dt * ang_speed);

      var current_roll = getprop("/sim/cargo/rope/roll"~(1+n_segments_reeled));
      ang_error = ref_ang2 - current_roll;

      rope_angle_vr_array[n_segments_reeled] +=  ang_error * stiffness * dt;
      rope_angle_vr_array[n_segments_reeled] *= damping_factor;

      ang_speed = rope_angle_vr_array[n_segments_reeled];

      var next_roll =  current_roll + dt * ang_speed;
      setprop("/sim/cargo/rope/roll"~(1+n_segments_reeled), next_roll);

      # kink excitation
      var kink =  -(next_roll - rope_angle_r_array[n_segments_reeled]);

      kink = kink + aircraft_roll - aircraft_roll_last;
      aircraft_roll_last = aircraft_roll;

      setprop("/sim/cargo/rope/roll"~(2+n_segments_reeled),  kink) ;
      rope_angle_r_array[n_segments_reeled + 1] = kink;
    } 
  else
    ############################
    #if (!pulling)
      {
        #allows cargo align with parallel rope if not conditioned as above
        setprop("/sim/cargo/rope/pitch"~(1+n_segments_reeled), ref_ang1);
        setprop("/sim/cargo/rope/roll"~(1+n_segments_reeled), ref_ang2);
      }

  var pull_force = 0.05;

	var roll_target = 0.0;

	for (var i = 0; i < n_segments_reeled; i=i+1)
		{
      setprop("/sim/cargo/rope/pitch"~(i+1),0.0);
		  setprop("/sim/cargo/rope/roll"~(i+1), 0.0);
		  rope_angle_r_array[i] = 0.0;
		}

  #######################
  for (var i = n_segments_reeled; i < n_segments; i=i+1)
    {
	    var gravity = n_segments - i + cargoWeight;

		  var velocity = getprop("/velocities/equivalent-kt");

		  if (velocity == nil) {velocity = 0;}
		  if (velocity > 500.0) {velocity = 500.0;}

      var dist_above_ground = alt_agl - (i+1 - n_segments_reeled) * segment_length;

      var force = flex_force * math.cos(sum_angle * math.pi/180.0) * pull_force * velocity;

      ##################
      #if (overland and !pulling)
      if (overland)
        {
          if (dist_above_ground < 0.0)
            {
              force = force + bend_force * math.cos(sum_angle * math.pi/180.0);
            }
          else
            {
            force = force + ground_friction;
            }
        }

		  if (force > 1.0 * gravity) {force = 1.0 * gravity;}

		  var angle = - 180.0 /math.pi * math.atan2(force, gravity);#(force/gravity);

      # outside transition zone, make sure segments lie really flat
      if (dist_above_ground < -0.5 )
        {
          if (i_segment_firstground == -1)
	          {
	            i_segment_firstground = i;
	            #print ("On ground!");
	            #print ("setting: ", me.i_segment_firstground);
	            if (ground_contact == 0)
                {
                  ground_contact = 1;
                  rope_pos = geo.aircraft_position();
                }

	            var aircraft_heading = getprop("/orientation/heading-deg");
	            var aircraft_pos = geo.aircraft_position();

              var bearing = aircraft_pos.course_to(rope_pos);
	            var dist = aircraft_pos.distance_to (rope_pos);
	            var rel_bearing =  (aircraft_heading - 180.0) - bearing;

	            n_segments_straight = int(dist/segment_length);		
	            n_segments_piled = n_segments - i - n_segments_straight;

	            if (dist > 4.0) {dist = 4.0;}

	            ground_friction = 0.003 * dist * (n_segments_straight + n_segments_piled);

	            if (dist < 0.5) {rel_bearing = 0.0;}

	            setprop("/sim/cargo/rope/yaw1", rel_bearing);

	          }

            # decide whether to pile or straighed ground segments
            if ((i == n_segments - n_segments_piled + 1) or (coil_flag == 0))
	            {
	              angle = 270.0 - sum_angle - aircraft_pitch;
	            }
            else if (i > n_segments - n_segments_piled)
	            {
	              angle = 0.0;
	            }
            else	
	            {
	              angle = 270.0 - sum_angle - aircraft_pitch;
	            }
        }
       else
        {
          if ((i_segment_firstground == -1) and (i == n_segments -1) and (ground_contact == 1))
	          {
	            ground_contact = 0;
	            setprop("/sim/cargo/rope/yaw1", 0.0);
	            ground_friction = 0.0;
               rope_pos = 0.0;
	          }
        }

		  sum_angle += angle;

      #####################################
      #if (onground_flag == 0 and !pulling)
      if (onground_flag == 0)
		    {
		      current_angle = getprop("/sim/cargo/rope/pitch"~(i+1));

		      ang_error = angle - current_angle;

		      rope_angle_v_array[i] += ang_error * stiffness * dt;
		      rope_angle_v_array[i] *= damping_factor;

		      ang_speed = rope_angle_v_array[i];

          setprop("/sim/cargo/rope/pitch"~(i+1), current_angle + dt * ang_speed);

		      # the transverse dynamics is largely waves excited by the helicopter

		      if ((i== (n_segments_reeled + 1)) or (i == n_segments_reeled)) # this is set by the kink excitation
            {
              continue;
            }   
          else
            {
              roll_target =  rope_angle_r_array[i-1];
              roll_target = roll_target * load_damping;
            }

		      ang_error = roll_target - rope_angle_r_array[i];

		      rope_angle_vr_array[i] += ang_error * stiffness * dt;
		      rope_angle_vr_array[i] *= damping_factor;

		      ang_speed = rope_angle_vr_array[i];

          setprop("/sim/cargo/rope/roll"~(i+1), roll_target);
		    }
      else
        ###############
        #if (pulling != 2)
          {
            #rope sections to angle parallel to ground
            setprop("/sim/cargo/rope/pitch"~(i+1), angle);

            if ((i == i_segment_firstground + n_segments_straight) and (i_segment_firstground > -1))
              {
                #print ("i is now", i);
                #print ("Firstground is: ", i_segment_firstground, " straight: ", n_segments_straight);
              	setprop("/sim/cargo/rope/roll"~(i+1), 90.0 * coil_flag);
              }
            else if ((i > (i_segment_firstground + n_segments_straight)) and (i_segment_firstground > -1))
              {

                var coil = (math.mod(i,5) - 2.0) * coil_factor + 13.3;

                if (coil_flag == 0)
	                {
	                  coil = 2.0 * (math.mod(i,5) - 2.0) + 2.0 * (math.mod(i, 3) - 1.0);
	                }

                	setprop("/sim/cargo/rope/roll"~(i+1), coil);
              }
             else if ((i > i_segment_firstground) and (i_segment_firstground > -1))
              {
                var coil = 2.0 * (math.mod(i,5) - 2.0) + 2.0 * (math.mod(i, 3) - 1.0);
                setprop("/sim/cargo/rope/roll"~(i+1), coil);
              }
             else
              {
                setprop("/sim/cargo/rope/roll"~(i+1), 0.0);
              }
          }
  }

  # copy the current values into the last step array
  for (var i = 0; i< n_segments; i=i+1)
    {
      rope_angle_r_array[i] = getprop("/sim/cargo/rope/roll"~(i+1));
    }
  } ########if pulling
}

var normalize = func (x, min, max) {
  return (x - min) / (max - min);
}

var normalize_r = func (x, minI, maxI, minO, maxO) {
  var r = maxO - minO;
  var t = normalize(x, minI, maxI);
  return (minO + (r * t));
}
