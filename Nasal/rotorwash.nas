var rotor_wash_loop = func {

##### water and grass shader effect
var vpos = geo.viewer_position();
var apos = geo.aircraft_position();

var lat_to_m = 110952.0;
var lon_to_m = math.cos(apos.lat()*math.pi/180.0) * lat_to_m;

var alt = getprop("/position/altitude-agl-ft");

var delta_x = (apos.lat() - vpos.lat()) * lat_to_m;
var delta_y = -(apos.lon() - vpos.lon()) * lon_to_m;

setprop("/environment/aircraft-effects/wash-x", delta_x);
setprop("/environment/aircraft-effects/wash-y", delta_y);

var rpm_factor = getprop("rotors/main/rpm")/400.0;

var strength = 20.0/alt;
if (strength > 1.0) {strength = 1.0;}
strength = strength * rpm_factor;

setprop("/environment/aircraft-effects/wash-strength", strength);

##### land or water particle effect
var terrain = getprop("gear/gear/ground-is-solid");
if (terrain == 1) 
	{
		setprop("sim/model/effects/particle/startcolor", .3);
		setprop("sim/model/effects/particle/endcolor", .5);
		setprop("sim/model/effects/particle/startalphfactor", 0.00004);
		setprop("sim/model/effects/particle/endalphfactor", 0.0002);
	} 
	else 
	{
		setprop("sim/model/effects/particle/startcolor", .5);
		setprop("sim/model/effects/particle/endcolor", .8);
		setprop("sim/model/effects/particle/startalphfactor", 0.00002);
		setprop("sim/model/effects/particle/endalphfactor", 0.0001);
	}
}