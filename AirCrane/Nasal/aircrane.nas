# Maik Justus < fg # mjustus : de >, based on bo105.nas by Melchior FRANZ, < mfranz # aon : at >

if (!contains(globals, "cprint")) {
  globals.cprint = func {};
}

var optarg = aircraft.optarg;
var makeNode = aircraft.makeNode;

var sin = func(a) { math.sin(a * math.pi / 180.0) }
var cos = func(a) { math.cos(a * math.pi / 180.0) }
var pow = func(v, w) { math.exp(math.ln(v) * w) }
var npow = func(v, w) { math.exp(math.ln(abs(v)) * w) * (v < 0 ? -1 : 1) }
var clamp = func(v, min = 0, max = 1) { v < min ? min : v > max ? max : v }
var normatan = func(x) { math.atan2(x, 1) * 2 / math.pi }

# timers ============================================================
var turbine_timer = aircraft.timer.new("/sim/time/hobbs/turbines", 10);
aircraft.timer.new("/sim/time/hobbs/helicopter", nil).start();

# engines/rotor =====================================================
var state = props.globals.getNode("sim/model/aircrane/state");
var engine = props.globals.getNode("sim/model/aircrane/engine");
var rotor = props.globals.getNode("controls/engines/engine/magnetos");
var rotor_rpm = props.globals.getNode("rotors/main/rpm");
var tail_rpm = props.globals.getNode("rotors/tail/rpm");
var torque = props.globals.getNode("rotors/gear/total-torque", 1);
var collective = props.globals.getNode("controls/engines/engine[0]/throttle");
var turbine = props.globals.getNode("sim/model/aircrane/turbine-rpm-pct", 1);
var torque_pct = props.globals.getNode("sim/model/aircrane/torque-pct", 1);
var stall = props.globals.getNode("rotors/main/stall", 1);
var stall_filtered = props.globals.getNode("rotors/main/stall-filtered", 1);
var torque_sound_filtered = props.globals.getNode("rotors/gear/torque-sound-filtered", 1);

var engine_one = props.globals.getNode("sim/model/aircrane/engines/one/n1", 1);
var engine_two = props.globals.getNode("sim/model/aircrane/engines/two/n1", 1);
var ignition_one = props.globals.getNode("controls/switches/ignition-1", 1);
var ignition_two = props.globals.getNode("controls/switches/ignition-2", 1);
var eng1_start = props.globals.getNode("controls/switches/eng1-n1-start", 1);
var eng2_start = props.globals.getNode("controls/switches/eng2-n1-start", 1);
var eng1_underspeed = props.globals.getNode("systems/electrical/outputs/eng1-underspeed", 1);
var eng2_underspeed = props.globals.getNode("systems/electrical/outputs/eng2-underspeed", 1);
var eng1_running = props.globals.getNode("controls/engines/engine[0]/running", 1);
var eng2_running = props.globals.getNode("controls/engines/engine[1]/running", 1);
var eng1_starting = props.globals.getNode("controls/engines/engine[0]/starting", 1);
var eng2_starting = props.globals.getNode("controls/engines/engine[1]/starting", 1);
var eng1_shutdown = props.globals.getNode("controls/engines/engine[0]/shutdown", 1);
var eng2_shutdown = props.globals.getNode("controls/engines/engine[1]/shutdown", 1);

var app_master = props.globals.getNode("controls/switches/app-master", 1);
var app_fuel = props.globals.getNode("controls/switches/app-fuel", 1);
var app_start_20 = props.globals.getNode("controls/switches/app-start-20", 1);
var app_start = props.globals.getNode("controls/switches/app-start", 1);
var app_running = props.globals.getNode("controls/engines/engine[2]/running", 1);
var app_starting = props.globals.getNode("controls/engines/engine[2]/starting", 1);
var app_shutdown = props.globals.getNode("controls/engines/engine[2]/shutdown", 1);

var target_rel_rpm = props.globals.getNode("controls/rotor/reltarget", 1);
var max_rel_torque = props.globals.getNode("controls/rotor/maxreltorque", 1);
var cone = props.globals.getNode("rotors/main/cone-deg", 1);
var cone1 = props.globals.getNode("rotors/main/cone1-deg", 1);
var cone2 = props.globals.getNode("rotors/main/cone2-deg", 1);
var cone3 = props.globals.getNode("rotors/main/cone3-deg", 1);
var cone4 = props.globals.getNode("rotors/main/cone4-deg", 1);
var main_rpm_pct = props.globals.getNode("sim/model/aircrane/main-rpm-pct", 1);
var tail_rpm_pct = props.globals.getNode("sim/model/aircrane/tail-rpm-pct", 1);
#fuel =====================================================
var tank1_level_lbs = props.globals.getNode("consumables/fuel/tank[0]/level-lbs", 1);
var tank2_level_lbs = props.globals.getNode("consumables/fuel/tank[1]/level-lbs", 1);
var tank3_level_lbs = props.globals.getNode("consumables/fuel/tank[2]/level-lbs", 1);
var tank4_level_lbs = props.globals.getNode("consumables/fuel/tank[3]/level-lbs", 1);
var tank5_level_lbs = props.globals.getNode("consumables/fuel/tank[4]/level-lbs", 1);
var fwd_level_lbs = props.globals.getNode("consumables/fuel/fwd/level-lbs", 1);
var aft_level_lbs = props.globals.getNode("consumables/fuel/aft/level-lbs", 1);
var aux_level_lbs = props.globals.getNode("consumables/fuel/aux/level-lbs", 1);
var fuel_shutoff_left = props.globals.getNode("consumables/fuel/shutoff/lever/left", 1);
var fuel_shutoff_right = props.globals.getNode("consumables/fuel/shutoff/lever/right", 1);
#power =====================================================
var master_bat = props.globals.getNode("controls/electric/battery-bus-switch", 1);
var generator_1 = props.globals.getNode("controls/electric/engine[0]/generator-sw", 1);
var generator_2 = props.globals.getNode("controls/electric/engine[1]/generator-sw", 1);

var rectifier_1 = props.globals.getNode("controls/switches/rect-1", 1);
var rectifier_2 = props.globals.getNode("controls/switches/rect-2", 1);

var autostart = func (msg=1) {
    #if (getprop("/engines/active-engine/running")) {
      #if (msg)
        #gui.popupTip("Engine already running", 5);
        #return;
    #}
    fwd_level_lbs.setValue(100);
    aft_level_lbs.setValue(100);
    ignition_one.setValue(-1);
    ignition_two.setValue(-1);
    fuel_shutoff_left.setValue(1);
    fuel_shutoff_right.setValue(1);
    engine_one.setValue(.5);
    engine_two.setValue(.5);
    master_bat.setValue(0);
    generator_1.setValue(-1);
    generator_2.setValue(-1);
    eng1_running.setValue(1);
    eng2_running.setValue(1);
    rectifier_1.setValue(1);
    rectifier_2.setValue(1);
    state.setValue(0);
    engines(1);
};

var app_startup = func {
    var app_start_condition = app_start.getBoolValue() * app_master.getBoolValue() * master_bat.getValue();
    if (app_start_condition) {
        app_starting.setValue(1);
        settimer(func {
          #if (!app_fuel.getValue() or app_rpm_percent.getValue() < 20) {
          if (!app_fuel.getValue()) {
            app_running.setValue(0);
            app_stop();  
          } else {
            app_running.setValue(1);
          }
          app_start.setValue(0);
          app_starting.setValue(0);
        }, 20);  
    }
}

var app_stop = func {
    if (app_running.getValue() or app_starting.getValue()) {
        app_running.setValue(0);
        app_start.setValue(0);
        app_starting.setValue(0);
        app_shutdown.setValue(1);
        settimer(func {app_shutdown.setValue(0);}, 20);
    }
}

var update_rpm_percents = func {
    #185
    #850
    main_rpm_pct.setValue(196/rotor_rpm.getValue());
    tail_rpm_pct.setValue(892/tail_rpm.getValue());
}

var update_fuel_lbs = func {
    fwd_level_lbs.setValue(tank1_level_lbs.getValue()+tank2_level_lbs.getValue());
    aft_level_lbs.setValue(tank3_level_lbs.getValue()+tank4_level_lbs.getValue());
    aux_level_lbs.setValue(tank4_level_lbs.getValue());
#var total_fuel_level_lbs = fwd_level_lbs + aft_level_lbs + aux_level_lbs;
}

# state:
# 0 off
# 1 engine startup
# 2 engine startup with small torque on rotor
# 3 engine idle
# 4 engine accel
# 5 engine sound loop

var update_state = func {
  var s = state.getValue();
  var new_state = arg[0];
  if (new_state == (s+1)) {
    state.setValue(new_state);
    if (new_state == (1)) { 
      settimer(func { update_state(2) }, 2);
      interpolate(engine, 0.03, 0.1, 0.002, 0.3, 0.02, 0.1, 0.003, 0.7, 0.03, 0.1, 0.01, 0.7);
    } else {
      if (new_state == (2)) {
        settimer(func { update_state(3) }, 3);
        rotor.setValue(1);
        max_rel_torque.setValue(0.01);
        target_rel_rpm.setValue(0.002);
        interpolate(engine, 0.05, 0.2, 0.03, 1, 0.07, 0.1, 0.04, 0.9, 0.02, 0.5);
      } else { 
        if (new_state == (3)) {
          if (rotor_rpm.getValue() > 100) {
            #rotor is running at high rpm, so accel. engine faster
            max_rel_torque.setValue(1);
            target_rel_rpm.setValue(1.03);
            state.setValue(5);
            interpolate(engine, 1.03, 10);
          } else {
            settimer(func { update_state(4) }, 7);
            max_rel_torque.setValue(0.05);
            target_rel_rpm.setValue(0.02);
            interpolate(engine, 0.07, 0.1, 0.03, 0.25, 0.075, 0.2, 0.08, 1, 0.06,2);
          }
        } else {
          if (new_state == (4)) {
            settimer(func { update_state(5) }, 30);
            max_rel_torque.setValue(0.25);
            target_rel_rpm.setValue(0.8);
          } else {
              if (new_state == (5)) {
              max_rel_torque.setValue(1);
              target_rel_rpm.setValue(1.03);
            }
          }
        }
      }
    }
  }
}

var engines_configured = func(x) {
    var configuration = 0;
    var fuel = fwd_level_lbs.getValue() + aft_level_lbs.getValue() + aux_level_lbs.getValue();
    var fuel_levers = fuel_shutoff_left.getValue() + fuel_shutoff_right.getValue();
    var ignition = 0;

    if (x == 0)
      ignition = ignition_one.getValue();
    if (x == 1)
      ignition = ignition_two.getValue();
    if (x == 2)
      ignition = ignition_one.getValue() + ignition_two.getValue();

    configuration = fuel_levers * ignition * fuel;

    return configuration;
}

var engines = func {
  if (props.globals.getNode("sim/crashed",1).getBoolValue()) {return; }
  var s = state.getValue();
  if (arg[0] == 1) {
    if (s == 0) {
      update_state(1);
    }
  } else {
    rotor.setValue(0); # engines stopped
    state.setValue(0);
    eng1_running.setValue(0);
    eng2_running.setValue(0);
    interpolate(engine, 0, 4);
  }
}

var update_engine = func {

  if (state.getValue() == -2) return;

  #engine starting up
  if (eng1_starting.getValue() == 1) {
    #if (n1_percentage(0) < 5 and ignition_one.getValue()) pop();
      if ((n1_percentage(0) > 29 and n1_percentage(0) < 45 ) and ignition_one.getValue() and app_running.getValue()) {
        eng1_running.setValue(1);
        eng1_starting.setValue(0);
      } else return;
  }
  if (eng2_starting.getValue() == 1) {
    #if (n1_percentage(1) < 5 and ignition_two.getValue()) pop();
      if ((n1_percentage(1) > 29 and n1_percentage(1) < 45 ) and ignition_two.getValue() and app_running.getValue()) {
        eng2_running.setValue(1);
        eng2_starting.setValue(0);
      } else return;
  }

  #engine not configured shutdown
  if (!engines_configured(0)) {
    eng1_shutdown.setValue(1);
    settimer(func {eng1_shutdown.setValue(0);}, 20);
    eng1_running.setValue(0);
  }
  if (!engines_configured(1)) {
    eng2_shutdown.setValue(1);
    settimer(func {eng2_shutdown.setValue(0);}, 20);
    eng2_running.setValue(0); 
  }

  var engines_online = n1_percentage(2);
  if ((engines_configured(0) and eng1_running.getValue()) or (engines_configured(1) and eng2_running.getValue())) {
    if (state.getValue() > 3 ) { 
        #max_rel_torque.setValue(1*engines_online);
        target_rel_rpm.setValue(1.03*engines_online);
        interpolate (engine,  clamp( rotor_rpm.getValue() / 235 , 0.05, target_rel_rpm.getValue() ), 0.25 );
    } else {
          state.setValue(1);
          update_state(2);
    }
  } else { 
      engines(0);
  }
}

var n1_percentage = func(x) {
    var percentage = 0;
    if (x == 2)
      percentage = engine_one.getValue() * eng1_running.getValue() + engine_two.getValue() * eng2_running.getValue();
    if (x == 0)
      percentage = engine_one.getValue()*200;
    if (x == 1)
      percentage = engine_two.getValue()*200;

    return percentage;
}

var update_engparams = func {
  eng1_underspeed.setValue(0);
  eng2_underspeed.setValue(0);
  if (n1_percentage(0) < 60 and eng1_running.getValue() == 1) 
    eng1_underspeed.setValue(1);
  if (n1_percentage(1) < 60 and eng2_running.getValue() == 1) 
    eng2_underspeed.setValue(1);
}

var update_rotor_cone_angle = func {
  r = rotor_rpm.getValue();
        #print("r  = ", r);

  var f = r / 186;
        #print("f1 = ", f);

  f = clamp (f, 0 , 1);
        #print("f2 = ", f);

  c = cone.getValue();
        #print("c  = ", c);

  cone1.setDoubleValue( (c * 1.00) + (f * c));
  cone2.setDoubleValue( (c * 0.10) + (f * c));
  cone3.setDoubleValue( (c * 0.15) + (f * c));
  cone4.setDoubleValue( (c * 0.20) + (f * c));
}

# torquemeter
var torque_val = 0;
torque.setDoubleValue(0);

var update_torque = func(dt) {
  var f = dt / (0.2 + dt);
  torque_val = torque.getValue() * f + torque_val * (1 - f);
  torque_pct.setDoubleValue(torque_val / 5300);
}

# sound =============================================================
# stall sound
var stall_val = 0;
stall.setDoubleValue(0);

var update_stall = func(dt) {
  var s = stall.getValue();
  if (s < stall_val) {
    var f = dt / (0.3 + dt);
    stall_val = s * f + stall_val * (1 - f);
  } else {
    stall_val = s;
  }
  var c = collective.getValue();
  stall_filtered.setDoubleValue(stall_val + 0.006 * (1 - c));
}

# modify sound by torque
var torque_val = 0;

var update_torque_sound_filtered = func(dt) {
  var t = torque.getValue();
  t = clamp(t * 0.000001);
  t = t*0.25 + 0.75;
  var r = clamp(rotor_rpm.getValue()*0.02-1);
  torque_sound_filtered.setDoubleValue(t*r);
}

# skid slide sound
var Skid = {
  new : func(n) {
    var m = { parents : [Skid] };
    var soundN = props.globals.getNode("sim/sound", 1).getChild("slide", n, 1);
    var gearN = props.globals.getNode("gear", 1).getChild("gear", n, 1);

    m.compressionN = gearN.getNode("compression-norm", 1);
    m.rollspeedN = gearN.getNode("rollspeed-ms", 1);
    m.frictionN = gearN.getNode("ground-friction-factor", 1);
    m.wowN = gearN.getNode("wow", 1);
    m.volumeN = soundN.getNode("volume", 1);
    m.pitchN = soundN.getNode("pitch", 1);

    m.compressionN.setDoubleValue(0);
    m.rollspeedN.setDoubleValue(0);
    m.frictionN.setDoubleValue(0);
    m.volumeN.setDoubleValue(0);
    m.pitchN.setDoubleValue(0);
    m.wowN.setBoolValue(1);
    m.self = n;
    return m;
  },
  update : func {
    me.wowN.getBoolValue() or return;
    var rollspeed = abs(me.rollspeedN.getValue());
    me.pitchN.setDoubleValue(rollspeed * 0.6);

    var s = normatan(20 * rollspeed);
    var f = clamp((me.frictionN.getValue() - 0.5) * 2);
    var c = clamp(me.compressionN.getValue() * 2);
    me.volumeN.setDoubleValue(s * f * c * 2);
    #if (!me.self) {
    # cprint("33;1", sprintf("S=%0.3f  F=%0.3f  C=%0.3f  >>  %0.3f", s, f, c, s * f * c));
    #}
  },
};

var skid = [];
for (var i = 0; i < 3; i += 1) {
  append(skid, Skid.new(i));
}

var update_slide = func {
  forindex (var i; skid) {
    skid[i].update();
  }
}

var click = func (name, timeout=0.1, delay=0) {
    var sound_prop = "/sim/model/aircrane/sound/click-" ~ name;

    settimer(func {
        # Play the sound
        setprop(sound_prop, 1);

        # Reset the property after "timeout" seconds so that the sound can be
        # played again.
        settimer(func {
            setprop(sound_prop, 0);
        }, timeout);
    }, delay);
};

# crash handler =====================================================
#var load = nil;
var crash = func {
  if (arg[0]) {
    # crash
    setprop("rotors/main/rpm", 0);
    setprop("rotors/main/blade[0]/flap-deg", -60);
    setprop("rotors/main/blade[1]/flap-deg", -50);
    setprop("rotors/main/blade[2]/flap-deg", -40);
    setprop("rotors/main/blade[3]/flap-deg", -30);
    setprop("rotors/main/blade[4]/flap-deg", -20);
    setprop("rotors/main/blade[5]/flap-deg", -10);
    setprop("rotors/main/blade[0]/incidence-deg", -30);
    setprop("rotors/main/blade[1]/incidence-deg", -20);
    setprop("rotors/main/blade[2]/incidence-deg", -50);
    setprop("rotors/main/blade[3]/incidence-deg", -55);
    setprop("rotors/main/blade[4]/incidence-deg", -60);
    setprop("rotors/main/blade[5]/incidence-deg", -65);
    setprop("rotors/tail/rpm", 0);
    strobe_switch.setValue(0);
    beacon_switch.setValue(0);
    nav_light_switch.setValue(0);
    rotor.setValue(0);
    torque_pct.setValue(torque_val = 0);
    stall_filtered.setValue(stall_val = 0);
    state.setValue(0);

  } else {
    # uncrash (for replay)
    setprop("rotors/tail/rpm", 1500);
    setprop("rotors/main/rpm", 235);
    for (i = 0; i < 4; i += 1) {
      setprop("rotors/main/blade[" ~ i ~ "]/flap-deg", 0);
      setprop("rotors/main/blade[" ~ i ~ "]/incidence-deg", 0);
    }
    strobe_switch.setValue(1);
    beacon_switch.setValue(1);
    rotor.setValue(1);
    state.setValue(5);
  }
}

# "manual" rotor animation for flight data recorder replay ============
var rotor_step = props.globals.getNode("sim/model/aircrane/rotor-step-deg");
var blade1_pos = props.globals.getNode("rotors/main/blade[0]/position-deg", 1);
var blade2_pos = props.globals.getNode("rotors/main/blade[1]/position-deg", 1);
var blade3_pos = props.globals.getNode("rotors/main/blade[2]/position-deg", 1);
var blade4_pos = props.globals.getNode("rotors/main/blade[3]/position-deg", 1);
var blade5_pos = props.globals.getNode("rotors/main/blade[4]/position-deg", 1);
var blade6_pos = props.globals.getNode("rotors/main/blade[5]/position-deg", 1);
var rotorangle = 0;

var rotoranim_loop = func {
  i = rotor_step.getValue();
  if (i >= 0.0) {
    blade1_pos.setValue(rotorangle);
    blade2_pos.setValue(rotorangle + 60);
    blade3_pos.setValue(rotorangle + 120);
    blade4_pos.setValue(rotorangle + 180);
    blade5_pos.setValue(rotorangle + 240);
    blade6_pos.setValue(rotorangle + 300);
    rotorangle += i;
    settimer(rotoranim_loop, 0.1);
  }
}

var init_rotoranim = func {
  if (rotor_step.getValue() >= 0.0) {
    settimer(rotoranim_loop, 0.1);
  }
}

# view management ===================================================

var elapsedN = props.globals.getNode("/sim/time/elapsed-sec", 1);
var flap_mode = 0;
var down_time = 0;
controls.flapsDown = func(v) {
  if (!flap_mode) {
    if (v < 0) {
      down_time = elapsedN.getValue();
      flap_mode = 1;
      dynamic_view.lookat(
          5,     # heading left
          -20,   # pitch up
          0,     # roll right
          0.2,   # right
          0.6,   # up
          0.85,  # back
          0.2,   # time
          55,    # field of view
      );
    } elsif (v > 0) {
      flap_mode = 2;
      var p = "/sim/view/dynamic/enabled";
      setprop(p, !getprop(p));
    }

  } else {
    if (flap_mode == 1) {
      if (elapsedN.getValue() < down_time + 0.2) {
        return;
      }
      dynamic_view.resume();
    }
    flap_mode = 0;
  }
}

# register function that may set me.heading_offset, me.pitch_offset, me.roll_offset,
# me.x_offset, me.y_offset, me.z_offset, and me.fov_offset
#
dynamic_view.register(func {
  var lowspeed = 1 - normatan(me.speedN.getValue() / 50);
  var r = sin(me.roll) * cos(me.pitch);

  me.heading_offset =           # heading change due to
    (me.roll < 0 ? -50 : -30) * r * abs(r);     #    roll left/right

  me.pitch_offset =           # pitch change due to
    (me.pitch < 0 ? -50 : -50) * sin(me.pitch) * lowspeed #    pitch down/up
    + 15 * sin(me.roll) * sin(me.roll);     #    roll

  me.roll_offset =            # roll change due to
    -15 * r * lowspeed;         #    roll
});

# main() ============================================================
var delta_time = props.globals.getNode("/sim/time/delta-realtime-sec", 1);
var adf_rotation = props.globals.getNode("/instrumentation/adf/rotation-deg", 1);
var hi_heading = props.globals.getNode("/instrumentation/heading-indicator/indicated-heading-deg", 1);

var main_loop = func {

  # adf_rotation.setDoubleValue(hi_heading.getValue());

  var dt = delta_time.getValue();

  update_slide();
  update_rotor_cone_angle();
  update_torque(dt);
  update_stall(dt);
  update_torque_sound_filtered(dt);

  update_engine();

  update_rpm_percents();
  update_fuel_lbs();
  update_engparams();

  rotor_wash_loop();
  flexhose_animation();

  settimer(main_loop, 0);
}

var crashed = 0;
var variant = nil;
var doors = nil;
var config_dialog = nil;

# initialization
setlistener("/sim/signals/fdm-initialized", func {

  init_rotoranim();
  collective.setDoubleValue(1);

  var tankop_timer = maketimer(0.25, func{tank_operations()});

  if (getprop("/sim/model/firetank/enabled"))
      tankop_timer.start();
    else
      setlistener("/sim/model/firetank/enabled", func {
        if (getprop("/sim/model/firetank/enabled"))
          tankop_timer.start();
        else {
          tankop_timer.stop();
          setprop("sim/model/firetank/opencannonvalve", 0);
          setprop("sim/model/firetank/opentankdoors", 0);
        }
      });

  # the attitude indicator needs pressure
  # settimer(func { setprop("engines/engine/rpm", 3000) }, 8);

  if (getprop("/sim/gui/show-range")) {
        fgcommand("dialog-show", props.Node.new({"dialog-name": "range-dialog"}));
  } else {
      fgcommand("dialog-close", props.Node.new({"dialog-name": "range-dialog"}));
  }


  main_loop();
});

setlistener("/sim/signals/reinit", func {
  cmdarg().getBoolValue() and return;
  cprint("32;1", "reinit");
  turbine_timer.stop();
  tankop_timer.stop();
  collective.setDoubleValue(1);
  variant.scan();
  crashed = 0;
});

#setlistener("sim/crashed", func {
#  cprint("31;1", "crashed ", cmdarg().getValue());
#  turbine_timer.stop();
#  if (cmdarg().getBoolValue()) {
#    crash(crashed = 1);
#  }
#});

setlistener("/sim/freeze/replay-state", func {
  cprint("33;1", cmdarg().getValue() ? "replay" : "pause");
  if (crashed) {
    crash(!cmdarg().getBoolValue())
  }
});

# firebug fire starter ctrl+shift+leftmouseclick
setlistener("/sim/signals/click", func {
  if (__kbd.shift.getBoolValue()) {
	  var click_pos = geo.click_position();
	  if (__kbd.ctrl.getBoolValue()) {
		  wildfire.ignite(click_pos);
	  } else {
		  #wildfire.resolve_foam_drop(click_pos, 50, 1);
          var aic = getprop("/sim/gui/dialogs/aicargo-dialog/ai-path");
          if (aic != nil) {
            var pos_lat = click_pos.lat();
            var pos_lon = click_pos.lon();
            var click_alt = geo.elevation(click_pos.lat(), click_pos.lon());
            var alt_offset = getprop("/models/cargo/"~aic~"/height");
            setprop("/models/cargo/"~aic~"/latitude-deg", pos_lat);
            setprop("/models/cargo/"~aic~"/longitude-deg", pos_lon);
            setprop("/models/cargo/"~aic~"/elevation-ft/", (click_alt + alt_offset) * 3.28);
            setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lat", pos_lat);
            setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lon", pos_lon);
            setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_alt", (click_alt + alt_offset) * 3.28);
            setprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head", getprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head"));

            if (getprop("/sim/gui/dialogs/aicargo-dialog/save")) {
              var cargo = getprop("/sim/gui/dialogs/aicargo-dialog/selected-cargo");
              setprop("/sim/model/aircrane/"~cargo~"/saved", 1);
              setprop("/sim/model/aircrane/"~cargo~"/position/latitude-deg", getprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lat"));
              setprop("/sim/model/aircrane/"~cargo~"/position/longitude-deg", getprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_lon"));
              setprop("/sim/model/aircrane/"~cargo~"/position/altitude-ft", getprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_alt"));
              setprop("/sim/model/aircrane/"~cargo~"/orientation/true-heading-deg", getprop("/sim/gui/dialogs/aicargo-dialog/selected_cargo_head"));
              aircraft.data.add("/sim/model/aircrane/"~cargo~"/position/latitude-deg",
                                "/sim/model/aircrane/"~cargo~"/position/longitude-deg",
                                "/sim/model/aircrane/"~cargo~"/position/altitude-ft",
                                "/sim/model/aircrane/"~cargo~"/orientation/true-heading-deg");
              aircraft.data.save();
            }
          } else {
            gui.popupTip("No Cargo Selected, first select cargo to move in the AirCrane's Cargo Menu", 3);
          }
	  }
  }
});

# Listen for impact of released payload
setlistener("/sim/ai/aircraft/impact/retardant", func (n) {
  #print("Retardant impact!");
  var node = props.globals.getNode(n.getValue());
  var pos  = geo.Coord.new().set_latlon
                 (node.getNode("impact/latitude-deg").getValue(),
                  node.getNode("impact/longitude-deg").getValue(),
                  node.getNode("impact/elevation-m").getValue());
  # The arguments are: position, radius and volume (currently unused).
  wildfire.resolve_foam_drop(pos, 10, 0);
  #wildfire.resolve_retardant_drop(pos, 10, 0);
});

setlistener("/sim/gui/show-range", func (node) {      
    if (node.getBoolValue()) {
        fgcommand("dialog-show", props.Node.new({"dialog-name": "range-dialog"}));
    } else {
        fgcommand("dialog-close", props.Node.new({"dialog-name": "range-dialog"}));
    }
}, 0, 0);

setlistener("/sim/model/aircrane/cockpit/rotorbrake-handle-animation", func (node) {      
    if (node.getValue() == 1) {
        aircrane.pumpRotorBrake();
    }
}, 0, 0);

setlistener("controls/switches/eng1-n1-start", func (node) {
    if (node.getValue() and engine_one.getValue() == 0 and app_running.getValue()) {
        state.setValue(-1);
        eng1_starting.setValue(1);
        settimer(func {
          eng1_starting.setValue(0);
          if (!eng1_running.getValue()) {
              state.setValue(0);
              eng1_shutdown.setValue(1);
              settimer(func {eng1_shutdown.setValue(0);}, 20);
          }
        }, 20);   
    }
}, 0, 0);

setlistener("controls/switches/eng2-n1-start", func (node) {
    if (node.getValue() and engine_two.getValue() == 0 and app_running.getValue()) {
        state.setValue(-1);
        eng2_starting.setValue(1);
        settimer(func {
          eng2_starting.setValue(0);
          if (!eng2_running.getValue()) {
              state.setValue(0);
              eng2_shutdown.setValue(1);
              settimer(func {eng2_shutdown.setValue(0);}, 20);
          }
        }, 20);   
    }
}, 0, 0);

setlistener("controls/switches/app-start-20", func (node) {
    if (node.getValue()) {
        if (!app_starting.getValue() or !app_running.getValue())
            app_startup();
    }
}, 0, 0);

setlistener("controls/switches/app-stop", func (node) {
    app_stop();
}, 0, 0);

#controls/switches/app-start

###############################################################################
# On-screen displays
var enableOSD = func {
  var left  = screen.display.new(20, 10);
  var right = screen.display.new(-300, 10);

  left.add("/sim/model/aircrane/state");
  left.add("/sim/model/aircrane/engine");
  left.add("/controls/engines/engine/magnetos");
  left.add("/controls/engines/engine[0]/throttle");
  left.add("/sim/model/aircrane/engines/one/n1");
  left.add("/sim/model/aircrane/engines/two/n1");
  left.add("/controls/switches/ignition-1");
  left.add("/controls/switches/ignition-2");
  left.add("/controls/switches/eng1-n1-start");
  left.add("/controls/switches/eng2-n1-start");
  left.add("/systems/electrical/outputs/eng1-underspeed");
  left.add("/systems/electrical/outputs/eng2-underspeed");
  left.add("/controls/engines/engine[0]/starter");
  left.add("/controls/engines/engine[1]/starter");
  left.add("/sim/model/aircrane/engines/one/starting");
  left.add("/sim/model/aircrane/engines/two/starting");

  left.add("/rotors/main/rpm");
  left.add("/rotors/tail/rpm");
  left.add("/sim/model/aircrane/turbine-rpm-pct");
  left.add("/sim/model/aircrane/torque-pct");
  left.add("/rotors/main/stall");
  left.add("/rotors/main/stall-filtered");
  left.add("/controls/rotor/reltarget");
  left.add("/controls/rotor/maxreltorque");
  left.add("/sim/model/aircrane/main-rpm-pct");
  left.add("/sim/model/aircrane/tail-rpm-pct");

  right.add("/controls/switches/app-master");
  right.add("/controls/switches/app-fuel");
  right.add("/controls/switches/app-start-20");
  right.add("/controls/switches/app-start");
  right.add("/sim/model/aircrane/app/running");
  right.add("/sim/model/aircrane/app/starting");

  right.add("/consumables/fuel/tank[0]/level-lbs");
  right.add("/consumables/fuel/tank[1]/level-lbs");
  right.add("/consumables/fuel/tank[2]/level-lbs");
  right.add("/consumables/fuel/tank[3]/level-lbs");
  right.add("/consumables/fuel/tank[4]/level-lbs");
  right.add("/consumables/fuel/fwd/level-lbs");
  right.add("/consumables/fuel/aft/level-lbs");
  right.add("/consumables/fuel/aux/level-lbs");
  right.add("/consumables/fuel/shutoff/lever/left");
  right.add("/consumables/fuel/shutoff/lever/right");
}
#enableOSD();