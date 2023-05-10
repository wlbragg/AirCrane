####    AirCrane electrical system      ####
####    adapted from the Citation II   ####
####    jet engine electrical system    ####

### buses are supplied with voltage ###
var bus_battery_hot       = props.globals.initNode("systems/electrical/buses/battery-hot",0,"DOUBLE");
var bus_battery           = props.globals.initNode("systems/electrical/buses/battery",0,"DOUBLE");
var bus_emer              = props.globals.initNode("systems/electrical/buses/emer",0,"DOUBLE");
var bus_isol_left         = props.globals.initNode("systems/electrical/buses/isolated-left",0,"DOUBLE");
var bus_main_left         = props.globals.initNode("systems/electrical/buses/main-left",0,"DOUBLE");
var bus_main_left_xover   = props.globals.initNode("systems/electrical/buses/main-left-xover",0,"DOUBLE");
var bus_isol_right        = props.globals.initNode("systems/electrical/buses/isolated-right",0,"DOUBLE");
var bus_main_right        = props.globals.initNode("systems/electrical/buses/main-right",0,"DOUBLE");
var bus_main_right_xover  = props.globals.initNode("systems/electrical/buses/main-right-xover",0,"DOUBLE");
var bus_external          = props.globals.initNode("systems/electrical/buses/external",0,"DOUBLE");
var bus_ac_115v           = props.globals.initNode("systems/electrical/buses/AC-115V",0,"DOUBLE");
var bus_ac_26v            = props.globals.initNode("systems/electrical/buses/AC-26V",0,"DOUBLE");

### load are added from all users on the bus ###
var load_battery_hot      = props.globals.initNode("systems/electrical/loads/battery-hot",0,"DOUBLE");
var load_battery          = props.globals.initNode("systems/electrical/loads/battery",0,"DOUBLE");
var load_emer             = props.globals.initNode("systems/electrical/loads/emer",0,"DOUBLE");
var load_isol_left        = props.globals.initNode("systems/electrical/loads/isolated-left",0,"DOUBLE");
var load_main_left        = props.globals.initNode("systems/electrical/loads/main-left",0,"DOUBLE");
var load_main_left_xover  = props.globals.initNode("systems/electrical/loads/main-left_xover",0,"DOUBLE");
var load_isol_right       = props.globals.initNode("systems/electrical/loads/isolated-right",0,"DOUBLE");
var load_main_right       = props.globals.initNode("systems/electrical/loads/main-right",0,"DOUBLE");
var load_main_right_xover = props.globals.initNode("systems/electrical/loads/main-right_xover",0,"DOUBLE");
var load_external         = props.globals.initNode("systems/electrical/loads/external",0,"DOUBLE");
var load_ac_115v          = props.globals.initNode("systems/electrical/loads/AC-115V",0,"DOUBLE");
var load_ac_26v           = props.globals.initNode("systems/electrical/loads/AC-26V",0,"DOUBLE");
var load_ballance         = props.globals.initNode("systems/electrical/supplier/ballance",0,"DOUBLE");

# switches and relays
var switch_batt           = props.globals.getNode("controls/electric/battery-bus-switch",0);
var switch_av             = props.globals.getNode("controls/electric/avionics-switch",0);
var switch_inv            = props.globals.getNode("controls/electric/inverter-switch",0);
var gen1_ready            = props.globals.getNode("controls/electric/engine[0]/generator",0);
var gen1_switch           = props.globals.getNode("controls/electric/engine[0]/generator-sw",0);
var gen1_start            = props.globals.getNode("controls/engines/engine[0]/starter",0);
var gen2_ready            = props.globals.getNode("controls/electric/engine[1]/generator",0);
var gen2_switch           = props.globals.getNode("controls/electric/engine[1]/generator-sw",0);
var gen2_start            = props.globals.getNode("controls/engines/engine[1]/starter",0);

#Use for APP
var app1_ready            = props.globals.getNode("controls/electric/engine[2]/app-ready",0);
var app1_switch           = props.globals.getNode("controls/electric/engine[2]/app-sw",0);
var app1_start            = props.globals.getNode("controls/engines/engine[2]/starter",0);

var rect1_switch          = props.globals.getNode("controls/switches/rect-1",0);
var rect2_switch          = props.globals.getNode("controls/switches/rect-2",0);

### arrays for circuit-breakers
var cbs_battery_hot=[];
var cbs_battery=[];
var cbs_emer=[];
var cbs_isol_left=[];
var cbs_main_left=[];
var cbs_main_left_xover=[];
var cbs_isol_right=[];
var cbs_main_right=[];
var cbs_main_right_xover=[];
var cbs_ac_115v=[];
var amp_ac_115v=[];
var cbs_ac_26v=[];
var amp_ac_26v=[];

# Lights
var lights_state=[];
var lights_factor=[];
var lights_bus=[];
var lights_input=[];
var lights_output=[];
var lights_power=[];

####################################################

var Battery = {
    new : func(num, vlt, amp, hr, cha){
        m = { parents : [Battery] };
        m.voltage = props.globals.initNode("systems/electrical/supplier/battery["~num~"]/voltage",0,"DOUBLE");
        m.load = props.globals.initNode("systems/electrical/supplier/battery["~num~"]/load",0,"DOUBLE");
        m.amp_hours = props.globals.initNode("systems/electrical/supplier/battery["~num~"]/amp_hours",0,"DOUBLE");
        m.percent = props.globals.initNode("systems/electrical/supplier/battery["~num~"]/percent",0,"DOUBLE");
        m.charge = props.globals.initNode("systems/electrical/supplier/battery["~num~"]/charge",0,"DOUBLE");

        m.voltage.setValue(0);
        m.load.setValue(0);
        m.amp_hours.setValue(hr);
        m.percent.setValue(1.0);
        m.charge.setValue(cha);
        m.ideal_volts = vlt;
        m.ideal_amps = amp;
        return m;
    },

    apply_load : func(load, dt) {
        var amphrs_used = load * dt / 3600.0;
        var percent_used = amphrs_used / me.amp_hours.getValue();
        var percent_rest = me.percent.getValue();

        percent_rest -= percent_used;
        if ( percent_rest < 0.0 ) {
            percent_rest = 0.0;
        } elsif ( percent_rest > 1.0 ) {
            percent_rest = 1.0;
        }
        var output = me.amp_hours.getValue() * percent_rest;

        me.percent.setValue(percent_rest);
        me.load.setValue(output);
        return output;
    },

    get_output_volts : func {
        var x = 1.0 - me.percent.getValue();
        var tmp = -(3.0 * x - 1.0);
        var factor = (tmp * tmp * tmp * tmp * tmp + 32) / 32;
        var output = me.ideal_volts * factor;
        me.voltage.setValue(output);
        return output;
    },

    get_output_amps : func {
        var x = 1.0 - me.percent.getValue();
        var tmp = -(3.0 * x - 1.0);
        var factor = (tmp * tmp * tmp * tmp * tmp + 32) / 32;
        var output = me.ideal_amps * factor;
        me.load.setValue(output);
        return output;
    }
};

########################################################

# var alternator = Alternator.new(num,switch,rpm_source,rpm_threshold,volts,amps);
# also used as generator or APP
var Alternator = {
    new : func (num,switch,src,thr,vlt,amp){
        m = { parents : [Alternator] };

        m.switch = props.globals.getNode(switch,1);
        #m.running = props.globals.getNode("engines/engine["~num~"]/started",1);
        m.running = props.globals.getNode("controls/engines/engine["~num~"]/starter",1);
        m.rpm_source = props.globals.getNode(src,1);
        m.rpm_threshold = thr;
        m.voltage = props.globals.getNode("systems/electrical/supplier/generator["~num~"]/voltage",1);
        m.voltage.setDoubleValue(0);
        m.load = props.globals.getNode("systems/electrical/supplier/generator["~num~"]/load",1);
        m.load.setDoubleValue(0);
        m.ideal_volts = vlt;
        m.ideal_amps = amp;
        return m;
    },

    apply_load : func(load) {
        me.load.setValue(load);
    },

    get_output_volts : func {
        var out = 0;
        if(me.switch.getBoolValue() and me.running.getBoolValue()){
            var factor = me.rpm_source.getValue() / me.rpm_threshold or 0;
            if ( factor > 1.0 ) factor = 1.0;
            out = (me.ideal_volts * factor);
        }
        me.voltage.setValue(out);
        return out;
    },

    get_output_amps : func {
        var ampout = 0;
        if(me.switch.getBoolValue() and me.running.getBoolValue()){
            var factor = me.rpm_source.getValue() / me.rpm_threshold or 0;
            if ( factor > 1.0 ) factor = 1.0;
            ampout = me.ideal_amps * factor;
        }
        me.load.setValue(ampout);
        return ampout;
    }
};

#####################################################

# var external = External.new(switch,volt,amp);
var External = {
    new : func (switch,vlt,amp){
        m = { parents : [External] };
        m.switch = props.globals.initNode(switch,1);
        m.voltage = props.globals.initNode("systems/electrical/supplier/external/voltage",1);
        m.voltage.setDoubleValue(0);
        m.load = props.globals.initNode("systems/electrical/supplier/external/load",1);
        m.load.setDoubleValue(0);
        m.volts = vlt;
        m.amps = amp;
        return m;
    },

    apply_load : func(load) {
        me.load.setValue(load);
    },

    get_output_volts : func {
        var out = 0;
        if(me.switch.getBoolValue()){
            out = me.volts;
        }
        me.voltage.setValue(out);
        return out;
    },

    get_output_amps : func {
        var ampout = 0;
        if(me.switch.getBoolValue()){
            ampout = me.amps;
        }
        me.load.setValue(ampout);
        return ampout;
    }
};

#####################################################

var battery = Battery.new(0,24,80,40,7.0);
var alternator1 = Alternator.new(0,"controls/electric/engine[0]/generator","rotors/main/rpm",45.0,28.0,400.0);
var alternator2 = Alternator.new(1,"controls/electric/engine[1]/generator","rotors/main/rpm",45.0,28.0,400.0);
var alternator3 = Alternator.new(2,"controls/electric/engine[2]/app-ready","rotors/main/rpm",45.0,28.0,400.0); #APP
var external = External.new("controls/electric/external-power",26.0,1200.0);

setlistener("/sim/signals/fdm-initialized", func {
    init_electrical();
    settimer(update_electrical,5);
    print("Electrical System ... ok");
});

var prop_alias = func (sorce, dest) {
    var src_node = props.globals.getNode (sorce);
    var dst_node = props.globals.getNode (dest);
    dst_node.unalias ();
    dst_node.alias (src_node);
}

var init_electrical = func{

    append(cbs_battery_hot, "light-comp");
    append(cbs_battery_hot, "light-emer");
    append(cbs_battery_hot, "ignition");
    append(cbs_battery_hot, "emer-power");

    append(cbs_battery, "batt-voltage");

    append(cbs_isol_left, "gen-ammeter-left");
    append(cbs_isol_left, "gen-sense-left");
    append(cbs_isol_left, "light-start-left");
    append(cbs_isol_left, "gen-voltage-left");

    append(cbs_isol_right, "gen-ammeter-right");
    append(cbs_isol_right, "gen-sense-right");
    append(cbs_isol_right, "light-start-right");
    append(cbs_isol_right, "gen-voltage-right");

    append(cbs_main_left, "left-sense");
    append(cbs_main_left, "annun-genoff-left");
    append(cbs_main_left, "light-recog-left");
    append(cbs_main_left, "light-advisory");
    append(cbs_main_left, "light-indirect");
    append(cbs_main_left, "entertainment");
#   append(cbs_main_left, "light-tail"); ### not installed (also known as logo-light)
    append(cbs_main_left, "engine-fan-left");
    append(cbs_main_left, "engine-turbine-left");
    append(cbs_main_left, "light-panel-left");
    append(cbs_main_left, "left-inverter");
    append(cbs_main_left, "sys-aoa");
    append(cbs_main_left, "warn-batt");
    append(cbs_main_left, "env-fan");
    append(cbs_main_left, "rec-voice");
    append(cbs_main_left, "inst-clock-left");
    append(cbs_main_left, "light-panel-el");
    append(cbs_main_left, "sys-engine-sync");
    append(cbs_main_left, "engine-fire-left");
    append(cbs_main_left, "engine-shutoff-left");
    append(cbs_main_left, "sys-flap-ctrl");
    append(cbs_main_left, "rec-flight");
    append(cbs_main_left, "engine-fuelflow-left");
    append(cbs_main_left, "engine-qty-left");
    append(cbs_main_left, "engine-ign-right");
    append(cbs_main_left, "engine-itt-left");
    append(cbs_main_left, "sys-gear-ctrl");
    append(cbs_main_left, "warn-gear");
    append(cbs_main_left, "left-starter");
    append(cbs_main_left, "light-winginsp");
    append(cbs_main_left, "sys-nose-wheel-rpm");
    append(cbs_main_left, "inst-oat");
    append(cbs_main_left, "engine-oilp-left");
    append(cbs_main_left, "engine-oilt-left");
    append(cbs_main_left, "sys-pitch-trim");
    append(cbs_main_left, "sys-skid-ctrl");
    append(cbs_main_left, "env-normalp");
    append(cbs_main_left, "left-xover");
    append(cbs_main_left, "inst-gyro-standby");
    append(cbs_main_left, "env-temp");
    append(cbs_main_left, "sys-thrustrev-left");
    append(cbs_main_left, "warn-lts1");
    append(cbs_main_left, "sys-flap-motor");

    append(cbs_main_left, "anti-ice-engine-left");
    append(cbs_main_left, "anti-ice-aoa");
    append(cbs_main_left, "anti-ice-pitot-left");
    append(cbs_main_left, "anti-ice-bleedair-ws");
    append(cbs_main_left, "anti-ice-bleedair-ws-temp");

    # Windshield wipers

    append(cbs_main_left, "afcs1");
    append(cbs_main_left, "afcs2");
    append(cbs_main_left, "afcs-servo");
    append(cbs_main_left, "afcs-fault");
    append(cbs_main_left, "bar-alt");
    append(cbs_main_left, "stick-trim");
    append(cbs_main_left, "yaw");
    append(cbs_main_left, "cws");
    append(cbs_main_left, "app-cont");
    append(cbs_main_left, "fuel-heat-eng1");
    append(cbs_main_left, "fuel-heat-eng2");
    append(cbs_main_left, "fuel-heat");
    append(cbs_main_left, "interior-dome");
    append(cbs_main_left, "fuel-boost-pump1-eng1");
    append(cbs_main_left, "fuel-boost-pump2-eng1");
    append(cbs_main_left, "fuel-boost-pump1-eng2");
    append(cbs_main_left, "fuel-boost-pump2-eng2");
    append(cbs_main_left, "firetank-system");
    append(cbs_main_left, "tank-qty");
    append(cbs_main_left, "rotor-brake");

######## USING ##########
    append(cbs_main_left, "landing-light");
    append(cbs_main_left, "spot-light");
    append(cbs_main_left, "beaconfwd-light");
    append(cbs_main_left, "beaconaft-light");
    append(cbs_main_left, "nav-lights");
    append(cbs_main_left, "strobe-light");

    append(cbs_main_left_xover, "dc-nav1");
    append(cbs_main_left_xover, "dc-adf1");
    append(cbs_main_left_xover, "dc-audio1");
    append(cbs_main_left_xover, "dc-dme1");
    append(cbs_main_left_xover, "dc-efis-adi");
    append(cbs_main_left_xover, "dc-efis-disp");
    append(cbs_main_left_xover, "dc-efis-efis");
    append(cbs_main_left_xover, "dc-efis-hsi");
    append(cbs_main_left_xover, "dc-fd1");
    append(cbs_main_left_xover, "dc-radalt");
    append(cbs_main_left_xover, "dc-rmi1");
    append(cbs_main_left_xover, "dc-xpdr1");
    append(cbs_main_left_xover, "dc-comm2");
    append(cbs_main_left_xover, "dc-dg1");
    append(cbs_main_left_xover, "dc-ap");
    append(cbs_main_left_xover, "dc-phone");
    append(cbs_main_left_xover, "dc-voice-adv");

    append(cbs_main_right, "right-sense");
    append(cbs_main_right, "fuel-boost-right");
    append(cbs_main_right, "annun-genoff-right");
    append(cbs_main_right, "light-recog-right");
    append(cbs_main_right, "light-cabin");
    append(cbs_main_right, "light-toilet");
    append(cbs_main_right, "engine-fan-right");
    append(cbs_main_right, "engine-turbine-right");
    append(cbs_main_right, "right-inverter");
    append(cbs_main_right, "engine-fuelflow-right");
    append(cbs_main_right, "engine-qty-right");
    append(cbs_main_right, "engine-itt-right");
    append(cbs_main_right, "right-xover");
    append(cbs_main_right, "engine-oilp-right");
    append(cbs_main_right, "engine-oilt-right");
    append(cbs_main_right, "right-starter");
    append(cbs_main_right, "dc-dme2");
    append(cbs_main_right, "dc-xpdr2");
    append(cbs_main_right, "dc-adf2");
    append(cbs_main_right, "dc-comm3");
    append(cbs_main_right, "dc-audio2");
    append(cbs_main_right, "dc-warn");
    append(cbs_main_right, "dc-nav-area");
    append(cbs_main_right, "dc-gpws");
    append(cbs_main_right, "dc-tas-htr");
    append(cbs_main_right, "dc-nav-vlf");
    append(cbs_main_right, "dc-nav-db");
    append(cbs_main_right, "dc-fms");
    append(cbs_main_right, "dc-radar");
    append(cbs_main_right, "dc-fd2");
    append(cbs_main_right, "dc-rmi2");

######## USING ##########

    append(cbs_main_right, "afcs1");
    append(cbs_main_right, "afcs2");
    append(cbs_main_right, "afcs-servo");
    append(cbs_main_right, "afcs-fault");
    append(cbs_main_right, "bar-alt");
    append(cbs_main_right, "stick-trim");
    append(cbs_main_right, "yaw");
    append(cbs_main_right, "cws");
    append(cbs_main_right, "app-cont");
    append(cbs_main_right, "fuel-heat-eng1");
    append(cbs_main_right, "fuel-heat-eng2");
    append(cbs_main_right, "fuel-heat");
    append(cbs_main_right, "interior-dome");
    append(cbs_main_right, "fuel-boost-pump1-eng1");
    append(cbs_main_right, "fuel-boost-pump2-eng1");
    append(cbs_main_right, "fuel-boost-pump1-eng2");
    append(cbs_main_right, "fuel-boost-pump2-eng2");
    append(cbs_main_right, "firetank-system");
    append(cbs_main_right, "tank-qty");
    append(cbs_main_right, "rotor-brake");

    append(cbs_main_right_xover, "light-panel-center");
    append(cbs_main_right_xover, "light-panel-right");
    append(cbs_main_right_xover, "inst-ralt");
    append(cbs_main_right_xover, "inst-clock-right");
    append(cbs_main_right_xover, "env-emerp");
    append(cbs_main_right_xover, "engine-fire-right");
    append(cbs_main_right_xover, "engine-shutoff-right");
    append(cbs_main_right_xover, "inst-flt-hr");
    append(cbs_main_right_xover, "engine-ign-left");
    append(cbs_main_right_xover, "warn-speed");
    append(cbs_main_right_xover, "sys-thrustrev-right");
    append(cbs_main_right_xover, "warn-lts2");
    append(cbs_main_right_xover, "fuel-boost-left");
    append(cbs_main_right_xover, "sys-equip-cool");

    append(cbs_main_right_xover, "anti-ice-pitot-right");
    append(cbs_main_right_xover, "anti-ice-surface");
    append(cbs_main_right_xover, "anti-ice-alcohol");
    append(cbs_main_right_xover, "anti-ice-engine-right");

    append(cbs_ac_115v, "ac-ap");
    append(amp_ac_115v, 1);
    append(cbs_ac_115v, "ac-fd1");
    append(amp_ac_115v, 1);
    append(cbs_ac_115v, "ac-air-data");
    append(amp_ac_115v, 2);
    append(cbs_ac_115v, "ac-vgyro1");
    append(amp_ac_115v, 1);
    append(cbs_ac_115v, "ac-radar");
    append(amp_ac_115v, 1);
    append(cbs_ac_115v, "ac-fd2");
    append(amp_ac_115v, 1);
    append(cbs_ac_115v, "ac-vgyro2");
    append(amp_ac_115v, 1);

    append(cbs_ac_26v, "ac-nav1");
    append(amp_ac_26v, 1);
    append(cbs_ac_26v, "ac-rmi-adf1");
    append(amp_ac_26v, 2);
    append(cbs_ac_26v, "ac-hsi1");
    append(amp_ac_26v, 2);
    append(cbs_ac_26v, "ac-adi1");
    append(amp_ac_26v, 1);
    append(cbs_ac_26v, "ac-gpws");
    append(amp_ac_26v, 1);
    append(cbs_ac_26v, "ac-nav2");
    append(amp_ac_26v, 1);
    append(cbs_ac_26v, "ac-rmi-adf2");
    append(amp_ac_26v, 2);
    append(cbs_ac_26v, "ac-hsi2");
    append(amp_ac_26v, 2);
    append(cbs_ac_26v, "ac-adi2");
    append(amp_ac_26v, 1);
    append(cbs_ac_26v, "ac-efis");
    append(amp_ac_26v, 1);

    append(cbs_emer, "dc-nav2");
    append(cbs_emer, "dc-comm1");
    append(cbs_emer, "dc-dg2");
    append(cbs_emer, "light-flood");

    append(lights_state,props.globals.initNode("controls/lighting/landing-light-switch",0,"BOOL"));
    append(lights_factor, 1.0);
    append(lights_bus,"main-left");
    append(lights_input,"landing-light");
    append(lights_output,props.globals.initNode("systems/electrical/outputs/landing-light",0,"DOUBLE"));
    append(lights_power, 15.0);

    append(lights_state,props.globals.initNode("controls/lighting/spot-light-switch",0,"BOOL"));
    append(lights_factor, 1.0);
    append(lights_bus,"main-left");
    append(lights_input,"spot-light");
    append(lights_output,props.globals.initNode("systems/electrical/outputs/spot-light",0,"DOUBLE"));
    append(lights_power, 5.0);

    append(lights_state,props.globals.initNode("controls/lighting/nav-light-switch",0,"BOOL"));
    append(lights_factor, 1.0);
    append(lights_bus,"main-left");
    append(lights_input,"nav-lights");
    append(lights_output,props.globals.initNode("systems/electrical/outputs/nav-lights",0,"DOUBLE"));
    append(lights_power, 5.0);

    append(lights_state,props.globals.initNode("controls/lighting/beaconfwd-light-switch",0,"BOOL"));
    append(lights_factor, 1.0);
    append(lights_bus,"main-left");
    append(lights_input,"beaconfwd-light");
    append(lights_output,props.globals.initNode("systems/electrical/outputs/beaconfwd-light",0,"DOUBLE"));
    append(lights_power, 5.0);

    append(lights_state,props.globals.initNode("controls/lighting/beaconaft-light-switch",0,"BOOL"));
    append(lights_factor, 1.0);
    append(lights_bus,"main-left");
    append(lights_input,"beaconaft-light");
    append(lights_output,props.globals.initNode("systems/electrical/outputs/beaconaft-light",0,"DOUBLE"));
    append(lights_power, 5.0);

    append(lights_state,props.globals.initNode("controls/lighting/strobe-light-switch",0,"BOOL"));
    append(lights_factor, 1.0);
    append(lights_bus,"main-left");
    append(lights_input,"strobe-light");
    append(lights_output,props.globals.initNode("systems/electrical/outputs/strobe-light",0,"DOUBLE"));
    append(lights_power, 7.5);

### cockpit lights

    #append(lights_state, props.globals.getNode("controls/lighting/panel-lights-switch",0,"BOOL"));
    #append(lights_factor, props.globals.initNode("controls/lighting/instrument-lights-norm",0,"DOUBLE"));
    #append(lights_bus,"main-left");
    #append(lights_input,"light-panel-el");
    #append(lights_output,"");
    #append(lights_power, 1.0);

    #append(lights_state, props.globals.getNode("controls/lighting/panel-lights-switch",0,"BOOL"));
    #append(lights_factor, props.globals.initNode("controls/lighting/left-panel-norm",0,"DOUBLE"));
    #append(lights_bus,"main-left");
    #append(lights_input,"light-panel-left");
    #append(lights_output,"");
    #append(lights_power, 5.0);

    #append(lights_state, props.globals.getNode("controls/lighting/panel-lights-switch",0,"BOOL"));
    #append(lights_factor, props.globals.initNode("controls/lighting/center-panel-norm",0,"DOUBLE"));
    #append(lights_bus,"main-right-xover");
    #append(lights_input,"light-panel-center");
    #append(lights_output,"");
    #append(lights_power, 5.0);

    #append(lights_state, props.globals.getNode("controls/lighting/panel-lights-switch",0,"BOOL"));
    #append(lights_factor, props.globals.initNode("controls/lighting/right-panel-norm",0,"DOUBLE"));
    #append(lights_bus,"main-right-xover");
    #append(lights_input,"light-panel-right");
    #append(lights_output,"");
    #append(lights_power, 5.0);

#    append(lights_state, props.globals.initNode("controls/lighting/map-lights",0,"BOOL"));
#    append(lights_factor, 1.0);
#    append(lights_bus,"main-right-xover");
#    append(lights_input,"light-panel-right");
#    append(lights_output,"");
#    append(lights_power, 0.0);

### cabin lights

    #append(lights_state, 1);
    #append(lights_factor, props.globals.initNode("controls/lighting/cabin-lights-norm",0,"DOUBLE"));
    #append(lights_bus, "main-left");
    #append(lights_input, "light-indirect");
    #append(lights_output, "");
    #append(lights_power, 7.5);

    #append(lights_state, 1);
    #append(lights_factor, props.globals.initNode("controls/lighting/cabin-lights-norm",0,"DOUBLE"));
    #append(lights_bus, "main-right");
    #append(lights_input, "light-cabin");
    #append(lights_output, "");
    #append(lights_power, 7.5);

    for (var i = 0 ; i < size(cbs_battery_hot) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/battery-hot/"~cbs_battery_hot[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_battery) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/battery/"~cbs_battery[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_emer) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/emer/"~cbs_emer[i],0,"DOUBLE");
    }

    for (var i = 0 ; i < size(cbs_isol_left) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/isolated-left/"~cbs_isol_left[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_main_left) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/main-left/"~cbs_main_left[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_main_left_xover) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/main-left-xover/"~cbs_main_left_xover[i],0,"DOUBLE");
    }

    for (var i = 0 ; i < size(cbs_isol_right) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/isolated-right/"~cbs_isol_right[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_main_right) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/main-right/"~cbs_main_right[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_main_right_xover) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/main-right-xover/"~cbs_main_right_xover[i],0,"DOUBLE");
    }

    for (var i = 0 ; i < size(cbs_ac_115v) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/AC-115V/"~cbs_ac_115v[i],0,"DOUBLE");
    }
    for (var i = 0 ; i < size(cbs_ac_26v) ; i += 1) {
        props.globals.initNode("/systems/electrical/users/AC-26V/"~cbs_ac_26v[i],0,"DOUBLE");
    }

}

update_buses = func(dt) {

    var batt_hot         = battery.get_output_volts();
    var batt             = 0.0;
    var emer             = 0.0;
    var isol_left        = alternator1.get_output_volts();
    var main_left        = 0.0;
    var main_left_xover  = 0.0;
    var isol_right       = alternator2.get_output_volts();
    var main_right       = 0.0;
    var main_right_xover = 0.0;
    var ext              = external.get_output_volts();
    var ac_115v          = 0.0;
    var ac_26v           = 0.0;

    var batt_charge = 0;
    var batt_online = 0;
    var gen1_online = 0;
    var gen2_online = 0;
    var ext_online  = 0;

    bus_isol_left.setValue(isol_left);
    bus_isol_right.setValue(isol_right);

# supported engine start if the opposite generator is running and external isn't available
    if (gen1_ready.getBoolValue() and gen2_start.getBoolValue() and isol_left > batt_hot and ext < batt_hot) {
        batt_hot = isol_left;
    }
    if (gen2_ready.getBoolValue() and gen1_start.getBoolValue() and isol_right > batt_hot and ext < batt_hot) {
        batt_hot = isol_right;
    }

# battery is online
    if (switch_batt.getValue() == 1 and batt_hot > 17.0) {
        batt_online = 1;
    }

# generator 1 is online
    if (gen1_ready.getBoolValue() and gen1_switch.getValue() == -1) {
        gen1_online = 1;
    }

# generator 2 is online
    if (gen2_ready.getBoolValue() and gen2_switch.getValue() == -1) {
        gen2_online = 1;
    }

# rectifier 1 is online
    if (gen1_online and rect1_switch.getValue() == -1) {
        rect1_online = 1;
    }

# rectifier 2 is online
    if (gen2_online and rect2_switch.getValue() == -1) {
        rect2_online = 1;
    }

# generator 3 is online
#    if (gen3_ready.getBoolValue() and gen3_switch.getValue() == -1) {
#        gen3_online = 1;
#    }

# external is online
    if (ext > batt_hot and ext < 31.0) {
        ext_online = 1;
    }

# battery and one or both generator is online -> cutoff external
    if (batt_online and (gen1_online or gen2_online)) {
        ext_online = 0;
    }

    if (ext_online and ext > batt_hot) { batt_hot = ext; }

    if (gen1_online and isol_left  > batt) { batt = isol_left;  }
    if (gen2_online and isol_right > batt) { batt = isol_right; }
    if (batt_online and batt_hot   > batt) { batt = batt_hot;   }

    if (batt > batt_hot) { batt_hot = batt; }
    if (switch_batt.getValue() and batt_hot > 17.0) { emer = batt_hot; }

    if (batt_hot > battery.get_output_volts() and battery.percent.getValue() < 1.0) {
        batt_charge = 1;
    }

    bus_battery_hot.setValue(batt_hot);
    bus_battery.setValue(batt);
    bus_emer.setValue(emer);
    if (ext_online) {
        bus_external.setValue(ext);
    } else {
        bus_external.setValue(0.0);
    }

    if (getprop("controls/electric/circuit-breakers/cb-main-left-1") or
        getprop("controls/electric/circuit-breakers/cb-main-left-2") or
        getprop("controls/electric/circuit-breakers/cb-main-left-3"))
    {
        main_left = batt;
    } else { main_left = 0.0; }

    if (getprop("controls/electric/circuit-breakers/main-left/cb-left-xover")) {
        main_left_xover = main_left;
    } else { main_left_xover = 0.0; }

    bus_main_left.setValue(main_left);
    bus_main_left_xover.setValue(main_left_xover);

    if (getprop("controls/electric/circuit-breakers/cb-main-right-1") or
        getprop("controls/electric/circuit-breakers/cb-main-right-2") or
        getprop("controls/electric/circuit-breakers/cb-main-right-3"))
    {
        main_right = batt;
    } else { main_right = 0.0; }

    if (getprop("controls/electric/circuit-breakers/main-right/cb-right-xover")) {
        main_right_xover = main_right;
    } else { main_right_xover = 0.0; }

    bus_main_right.setValue(main_right);
    bus_main_right_xover.setValue(main_right_xover);

### power distribution DC buses

    for (var i = 0 ; i < size(cbs_battery_hot) ; i += 1) {
        if (getprop("controls/electric/circuit-breakers/battery-hot/cb-"~cbs_battery_hot[i])) {
            setprop("systems/electrical/outputs/battery-hot/"~cbs_battery_hot[i], batt_hot);
        } else {
            setprop("systems/electrical/outputs/battery-hot/"~cbs_battery_hot[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_battery) ; i += 1) {
        if (getprop("controls/electric/circuit-breakers/battery/cb-"~cbs_battery[i])) {
            setprop("systems/electrical/outputs/battery/"~cbs_battery[i], batt);
        } else {
            setprop("systems/electrical/outputs/battery/"~cbs_battery[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_emer) ; i += 1) {
        var avionic = string.match(cbs_emer[i], "dc-*");
        if (((avionic and switch_av.getBoolValue()) or !avionic) and getprop("controls/electric/circuit-breakers/emer/cb-"~cbs_emer[i])) {
            setprop("systems/electrical/outputs/emer/"~cbs_emer[i], emer);
        } else {
            setprop("systems/electrical/outputs/emer/"~cbs_emer[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_isol_left) ; i += 1) {
        if (getprop("controls/electric/circuit-breakers/isolated-left/cb-"~cbs_isol_left[i])) {
            setprop("systems/electrical/outputs/isolated-left/"~cbs_isol_left[i], isol_left);
        } else {
            setprop("systems/electrical/outputs/isolated-left/"~cbs_isol_left[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_main_left) ; i += 1) {
        var avionic = string.match(cbs_main_left[i], "dc-*");
        if (((avionic and switch_av.getBoolValue()) or !avionic) and getprop("controls/electric/circuit-breakers/main-left/cb-"~cbs_main_left[i])) {
            setprop("systems/electrical/outputs/main-left/"~cbs_main_left[i], main_left);
        } else {
            setprop("systems/electrical/outputs/main-left/"~cbs_main_left[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_main_left_xover) ; i += 1) {
        var avionic = string.match(cbs_main_left_xover[i], "dc-*");
        if (((avionic and switch_av.getBoolValue()) or !avionic) and getprop("/controls/electric/circuit-breakers/main-left-xover/cb-"~cbs_main_left_xover[i])) {
            setprop("/systems/electrical/outputs/main-left-xover/"~cbs_main_left_xover[i], main_left_xover);
        } else {
            setprop("/systems/electrical/outputs/main-left-xover/"~cbs_main_left_xover[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_isol_right) ; i += 1) {
        if (getprop("/controls/electric/circuit-breakers/isolated-right/cb-"~cbs_isol_right[i])) {
            setprop("/systems/electrical/outputs/isolated-right/"~cbs_isol_right[i], isol_right);
        } else {
            setprop("/systems/electrical/outputs/isolated-right/"~cbs_isol_right[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_main_right) ; i += 1) {
        var avionic = string.match(cbs_main_right[i], "dc-*");
        if (((avionic and switch_av.getBoolValue()) or !avionic) and getprop("/controls/electric/circuit-breakers/main-right/cb-"~cbs_main_right[i])) {
            setprop("/systems/electrical/outputs/main-right/"~cbs_main_right[i], main_right);
        } else {
            setprop("/systems/electrical/outputs/main-right/"~cbs_main_right[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_main_right_xover) ; i += 1) {
        var avionic = string.match(cbs_main_right_xover[i], "dc-*");
        if (((avionic and switch_av.getBoolValue()) or !avionic) and getprop("/controls/electric/circuit-breakers/main-right-xover/cb-"~cbs_main_right_xover[i])) {
            setprop("/systems/electrical/outputs/main-right-xover/"~cbs_main_right_xover[i], main_right_xover);
        } else {
            setprop("/systems/electrical/outputs/main-right-xover/"~cbs_main_right_xover[i], 0.0);
        }
    }

### special for ignition lights
    if (getprop("controls/engines/engine[0]/starter") and getprop("/controls/electric/circuit-breakers/isolated-left/cb-light-start-left")) {
        setprop("systems/electrical/outputs/isolated-left/light-start-left", batt_hot);
    }
    if (getprop("controls/engines/engine[1]/starter") and getprop("/controls/electric/circuit-breakers/isolated-right/cb-light-start-right")) {
        setprop("systems/electrical/outputs/isolated-right/light-start-right", batt_hot);
    }

### power distribution AC buses

    if (switch_inv.getBoolValue()) {
        ac_115v = getprop("/systems/electrical/outputs/main-left/left-inverter") * 4.43;
        ac_26v = getprop("/systems/electrical/outputs/main-left/left-inverter");
    }
    else {
        ac_115v = getprop("/systems/electrical/outputs/main-right/right-inverter") * 4.43;
        ac_26v = getprop("/systems/electrical/outputs/main-right/right-inverter");
    }

    bus_ac_115v.setValue(ac_115v);
    bus_ac_26v.setValue(ac_26v);

    for (var i = 0 ; i < size(cbs_ac_115v) ; i += 1) {
        if (getprop("/controls/electric/circuit-breakers/AC-115V/cb-"~cbs_ac_115v[i])) {
            setprop("/systems/electrical/outputs/AC-115V/"~cbs_ac_115v[i], ac_115v);
            if (cbs_ac_115v[i] != "ac-ap") {
                var use = (amp_ac_115v[i] / 115.0) * ac_115v;
                setprop("/systems/electrical/users/AC-115V/"~cbs_ac_115v[i], use);
            }
        } else {
            setprop("/systems/electrical/outputs/AC-115V/"~cbs_ac_115v[i], 0.0);
            setprop("/systems/electrical/users/AC-115V/"~cbs_ac_115v[i], 0.0);
        }
    }

    for (var i = 0 ; i < size(cbs_ac_26v) ; i += 1) {
        if (getprop("/controls/electric/circuit-breakers/AC-26V/cb-"~cbs_ac_26v[i])) {
            setprop("/systems/electrical/outputs/AC-26V/"~cbs_ac_26v[i], ac_26v);
            var use = (amp_ac_26v[i] / 26.0) * ac_26v;
            setprop("/systems/electrical/users/AC-115V/"~cbs_ac_26v[i], use);
        } else {
            setprop("/systems/electrical/outputs/AC-26V/"~cbs_ac_26v[i], 0.0);
            setprop("/systems/electrical/users/AC-115V/"~cbs_ac_26v[i], 0.0);
        }
    }

    lighting();

    var users = 0.0;
    for (var i = 0 ; i < size(cbs_battery_hot) ; i += 1) {
        users += getprop("/systems/electrical/users/battery-hot/"~cbs_battery_hot[i]);
    }
    load_battery_hot.setValue(users);

    var users = 0.0;
    for (var i = 0 ; i < size(cbs_emer) ; i += 1) {
        users += getprop("/systems/electrical/users/emer/"~cbs_emer[i]);
    }
    load_emer.setValue(users);

    var users = 0.0;
    for (var i = 0 ; i < size(cbs_ac_115v) ; i += 1) {
        users += getprop("/systems/electrical/users/AC-115V/"~cbs_ac_115v[i]);
    }
    load_ac_115v.setValue(users);

    var users = 0.0;
    for (var i = 0 ; i < size(cbs_ac_26v) ; i += 1) {
        users += getprop("/systems/electrical/users/AC-26V/"~cbs_ac_26v[i]);
    }
    load_ac_26v.setValue(users);

    var users = 0.0;
    for (var i = 0 ; i < size(cbs_isol_left) ; i += 1) {
        users += getprop("/systems/electrical/users/isolated-left/"~cbs_isol_left[i]);
    }
    load_isol_left.setValue(users);

    var users = 0.0;
    for (var i = 0 ; i < size(cbs_isol_right) ; i += 1) {
        users += getprop("/systems/electrical/users/isolated-right/"~cbs_isol_right[i]);
    }
    load_isol_right.setValue(users);

# left-xover goes to main-left; also AC buses if inverter set to left (1) [boolean set]
    var users = 0.0;
    for (var i = 0 ; i < size(cbs_main_left_xover) ; i += 1) {
        users += getprop("/systems/electrical/users/main-left-xover/"~cbs_main_left_xover[i]);
    }
    load_main_left_xover.setValue(users);
    for (var i = 0 ; i < size(cbs_main_left) ; i += 1) {
        users += getprop("/systems/electrical/users/main-left/"~cbs_main_left[i]);
    }
    if (switch_inv.getBoolValue()) {
        users += load_ac_115v.getValue() * 4.43;
        users += load_ac_26v.getValue();
    }
    load_main_left.setValue(users);

# right-xover goes to main-right; also AC buses if inverter set to right (2) [boolean unset]
    var users = 0.0;
    for (var i = 0 ; i < size(cbs_main_right_xover) ; i += 1) {
        users += getprop("/systems/electrical/users/main-right-xover/"~cbs_main_right_xover[i]);
    }
    load_main_right_xover.setValue(users);
    for (var i = 0 ; i < size(cbs_main_right) ; i += 1) {
        users += getprop("/systems/electrical/users/main-right/"~cbs_main_right[i]);
    }
    if (!switch_inv.getBoolValue()) {
        users += load_ac_115v.getValue() * 4.43;
        users += load_ac_26v.getValue();
    }
    load_main_right.setValue(users);

# check what supplier deliver the power to the buses

    var load0 = 0.0; # battery bus
    var load1 = load_isol_left.getValue();
    var load2 = load_isol_right.getValue();
    var load3 = 0.0; # external

    if (gen1_online) {
        load1 += load_main_left.getValue();
    } else {
        load0 += load_main_left.getValue();
    }

    if (gen2_online) {
        load2 += load_main_right.getValue();
    } else {
        load0 += load_main_right.getValue();
    }

    if (ext_online) {
        load3 += load_battery_hot.getValue();
        if (switch_batt.getValue()) {
            load3 += load_emer.getValue();
        }
    }

    if (load0 > 0.0) {
        if (gen1_online) {
            load1 += load0;
            load0 = 0.0;
        }
        else if (gen2_online) {
            load2 += load0;
            load0 = 0.0;
        }
        else if (batt_online) {
            if (ext_online) {
                load3 += load0;
                load0 = 0.0;
            }
        }
        else {
            print("power consumtion without suppliers? error!");
        }
    }

    if (batt_charge) {
        if (gen1_online and gen2_online) {
            load1 += battery.charge.getValue() / 2;
            load2 += battery.charge.getValue() / 2;
        }
        else if (gen1_online) {
            load1 += battery.charge.getValue();
        }
        else if (gen2_online) {
            load2 += battery.charge.getValue();
        }
        else if (ext_online) {
            load3 += battery.charge.getValue();
        }
        battery.apply_load(-(battery.charge.getValue()), dt);
    } else {
        battery.apply_load(load0, dt);
    }

### load ballancing generators if the difference is more than 20 amps

    if (gen1_online and gen2_online) {
        var ballance = load_ballance.getValue();
        if ((load1 + ballance) < 0.0 or (load2 - ballance) < 0.0) {
            ballance = 0.0;
        }
        var diff_load = (load1 + ballance) - (load2 - ballance);
        if (diff_load < -20.0 or diff_load > 20.0) {
            var step = 0.0;
            step = (load1 + load2) * 0.01;
            if ((load1 + ballance) > (load2 - ballance)) {
                ballance -= step;
            } else {
                ballance += step;
            }
            load_ballance.setValue(ballance);
        }
        load1 += ballance;
        load2 -= ballance;
    }

    alternator1.apply_load(load1);
    alternator2.apply_load(load2);
    external.apply_load(load3);
    load_external.setValue(load3);

    return 0;
}

### set outputs under 'systems/electrical/outputs/'
lighting = func() {
    for(var i = 0 ; i < size(lights_state) ; i += 1) {
        var input = getprop("systems/electrical/outputs/"~lights_bus[i]~"/"~lights_input[i]);
        var state = 1;
        var load = 0.0;
        if (lights_state[i] != 1) {
            state = lights_state[i].getValue();
        }

        if (state and input > 0.0) {
            var factor = 1.0;
            if (lights_factor[i] != 1.0) {
                factor = lights_factor[i].getValue();
            }
            load = (input / 26.0) * factor * lights_power[i];
        } else {
            input = 0.0;
        }

        if (lights_output[i] != "") {
            lights_output[i].setValue(input);
        }
        setprop("systems/electrical/users/"~lights_bus[i]~"/"~lights_input[i], load);
    }
}

update_electrical = func {
    var scnd = getprop("sim/time/delta-sec");
    update_buses( scnd );
    settimer(update_electrical, 0);
}
