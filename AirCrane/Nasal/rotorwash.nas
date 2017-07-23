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

	#particle effect colors
	var land = getprop("/gear/gear/ground-is-solid");

	if (land) {
		setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedstart", getprop("/rendering/scene/diffuse/red")*.4);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedstart", getprop("/rendering/scene/diffuse/green")*.4);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedstart", getprop("/rendering/scene/diffuse/blue")*.4);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedend", getprop("/rendering/scene/diffuse/red")*.7);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedend", getprop("/rendering/scene/diffuse/green")*.7);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedend", getprop("/rendering/scene/diffuse/blue")*.7);
	} else {
		setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedstart", getprop("/rendering/scene/diffuse/red")*.5);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedstart", getprop("/rendering/scene/diffuse/green")*.7);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedstart", getprop("/rendering/scene/diffuse/blue")*.8);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedend", getprop("/rendering/scene/diffuse/red")*.6);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedend", getprop("/rendering/scene/diffuse/green")*.8);
		setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedend", getprop("/rendering/scene/diffuse/blue")*.9);
	}
}