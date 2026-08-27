setlistener("/sim/signals/fdm-initialized", func {
    autostart();
});

var autostart = func (msg=1) {
    # if (getprop("/engines/active-engine/running")) {
    #   if (msg) {
    #     gui.popupTip("Engine already running", 5);
    #   }
    #   return;
    # }
    start_delay = 3;

    setprop("/controls/electric/external_power", 1);
    setprop("/controls/electric/battery-isol", 1);
    setprop("/controls/electric/rotor_brake-sw", 0);
    setprop("/controls/electric/tank_fwd_pump-1-sw", 1);
    setprop("/controls/electric/tank_fwd_pump-2-sw", 1);
    setprop("/controls/electric/tank_aft_pump-1-sw", 1);
    setprop("/controls/electric/tank_aft_pump-2-sw", 1);

    settimer(func {

        setprop("/consumables/fuel/tank[3]/level-gal_us", 250);
        setprop("/consumables/fuel/tank[4]/level-gal_us", 250);
        setprop("/consumables/fuel/tank[5]/level-gal_us", 100);
        setprop("/controls/engines/engine[3]/cutoff", 0);
        setprop("/controls/engines/engine[4]/cutoff", 0);
        setprop("/controls/electric/engine[3]/starter-sw", 1);
        setprop("/controls/electric/engine[4]/starter-sw", 1);
        setprop("/controls/engines/engine[3]/indent", 1);
        setprop("/controls/engines/engine[4]/indent", 1);
        setprop("/controls/engines/engine[3]/starter", 1);
        setprop("/controls/engines/engine[4]/starter", 1);
        setprop("/fdm/jsbsim/propulsion/engine[3]/governor/n1-lever", .64);
        setprop("/fdm/jsbsim/propulsion/engine[4]/governor/n1-lever", .64);
        setprop("/fdm/jsbsim/propulsion/engine[3]/fuel-cock", 1);
        setprop("/fdm/jsbsim/propulsion/engine[4]/fuel-cock", 1);

    }, start_delay);

    settimer(func {

        if (msg) {
            setprop("/fdm/jsbsim/propulsion/engine[3]/governor/n1-lever", 1);
            setprop("/fdm/jsbsim/propulsion/engine[4]/governor/n1-lever", 1);
            setprop("/controls/electric/engine[3]/generator-sw", 1);
            setprop("/controls/electric/engine[4]/generator-sw", 1);
            setprop("/controls/electric/engine[3]/rectifier", 1);
            setprop("/controls/electric/engine[4]/rectifier", 1);
            setprop("/controls/electric/afcs-sw", 1);
        }
       
    }, start_delay+2);

    settimer(func {

        if (msg) {

            setprop("/controls/electric/external_power", 0);
        }
       
    }, start_delay+60); 
	
    # === lighting ===
    #setprop("controls/lighting/beaconfwd-light-switch", 1);
    #setprop("controls/lighting/beaconaft-light-switch", 1);
    #setprop("controls/lighting/nav-light-switch", 1);
    #setprop("controls/lighting/strobe-light-switch", 1);
    # Landing light if needed
    #var light_level = 1-getprop("/rendering/scene/diffuse/red");
    #if (light_level > .6) {
    #  setprop("controls/lighting/landing-light-switch", 1);
    #}
};
