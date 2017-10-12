#################### long line ####################

var rope_angle_v_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var rope_angle_vr_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var rope_angle_r_array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

var longline_animation = func {

	var overland = getprop("gear/gear/ground-is-solid");
	var altitude = getprop("position/altitude-agl-ft");
	var alt_agl = altitude * 0.3048 + getprop("/sim/model/cargo/rope/offset");
	var n_segments = 90;
	var segment_length = getprop("/sim/model/cargo/rope/factor");
  var cargo_on_hook = getprop("sim/model/cargo-on-hook");
  var cargo_height = getprop("/sim/model/cargo/cargoheight");
  var cargo_harness = getprop("/sim/model/cargo/cargoharness");

  if (overland)
    {
      if (((alt_agl - (n_segments * segment_length)) + cargo_harness + cargo_height) < 0.0)
        setprop("/sim/model/cargo/hitsground", 1);
      else
        setprop("/sim/model/cargo/hitsground", 0);

      if (((alt_agl - (n_segments * segment_length)) + cargo_harness) < 0.0)
			  onground_flag = 1;
		  else
			  onground_flag = 0;
    }
  else
	  {
      #TODO: decide how to handel this event, slowly allow to sink?
	    onground_flag = 0;
      setprop("/sim/model/cargo/hitsground", 0);
	  }

	var flex_force = getprop("/sim/model/cargo/rope/flex-force");
	var damping = getprop("/sim/model/cargo/rope/damping");
	var stiffness = getprop("/sim/model/cargo/rope/stiffness");
	var sum_angle = 0.0;
	var dt = getprop("/sim/time/delta-sec");
  var bend_force = getprop("/sim/model/cargo/rope/bendforce");
	var angle_correction = getprop("/sim/model/cargo/rope/correction");

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

	if (onground_flag == 0)
	  {
      var current_angle = getprop("/sim/model/cargo/rope/pitch1");
      var ang_error = ref_ang1 - current_angle;

      rope_angle_v_array[0] += ang_error * stiffness * dt;
      rope_angle_v_array[0] *= damping_factor;

      var ang_speed = rope_angle_v_array[0];

      setprop("/sim/model/cargo/rope/pitch1", current_angle + dt * ang_speed);

      var current_roll = getprop("/sim/model/cargo/rope/roll1");
      ang_error = ref_ang2 - current_roll;


      rope_angle_vr_array[0] +=  ang_error * stiffness * dt;
      rope_angle_vr_array[0] *= damping_factor;

      ang_speed = rope_angle_vr_array[0];

      var next_roll =  current_roll + dt * ang_speed;
      setprop("/sim/model/cargo/rope/roll1", next_roll);

      # kink excitation
      if (!cargo_on_hook)
        {
          var kink =  -(next_roll - rope_angle_r_array[0]);
          setprop("/sim/model/cargo/rope/roll2",  kink) ;
          rope_angle_r_array[1] = kink;
        }
    } 
  else
    #if (!cargo_on_hook) 
      {
        setprop("/sim/model/cargo/rope/pitch1", ref_ang1);
        setprop("/sim/model/cargo/rope/roll1", ref_ang2);
      }


	var roll_target = 0.0;

	for (var i = 1; i< n_segments; i=i+1)
    {
	    var gravity = n_segments - i;

		  var velocity = getprop("/velocities/equivalent-kt");

		  if (velocity == nil) {velocity = 0;}
		  if (velocity > 500.0) {velocity = 500.0;}

		  var dist_above_ground = alt_agl - (i+1) * segment_length;

		  var force = flex_force * math.cos(sum_angle * math.pi/180.0) * 0.05 * velocity;

      if (overland and !cargo_on_hook)
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
		      current_angle = getprop("/sim/model/cargo/rope/pitch"~(i+1));
		      ang_error = angle - current_angle;


		      rope_angle_v_array[i] += ang_error * stiffness * dt;
		      rope_angle_v_array[i] *= damping_factor;

		      ang_speed = rope_angle_v_array[i];

		      setprop("/sim/model/cargo/rope/pitch"~(i+1), current_angle + dt * ang_speed);

		      # the transverse dynamics is largely waves excited by the helicopter

		      if (i==1) # this is set by the kink excitation
            {
              continue;
            }   
          else
            {
              roll_target =  rope_angle_r_array[i-1];
            }

		      ang_error = roll_target - rope_angle_r_array[i];

		      rope_angle_vr_array[i] += ang_error * stiffness * dt;
		      rope_angle_vr_array[i] *= damping_factor;

		      ang_speed = rope_angle_vr_array[i];

		      setprop("/sim/model/cargo/rope/roll"~(i+1), roll_target);
		    }
      else
        if (!cargo_on_hook)
          {
            setprop("/sim/model/cargo/rope/pitch"~(i+1), angle + angle_correction);
            setprop("/sim/model/cargo/rope/roll"~(i+1), 0.0);
          }
  }

  # copy the current values into the last step array

  for (var i = 0; i< n_segments; i=i+1)
    {
      rope_angle_r_array[i] = getprop("/sim/model/cargo/rope/roll"~(i+1));
    }

}