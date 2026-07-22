#
# AirCrane Mouse Override
# FINAL VERSION — tuned collective, correct clamp, throttle disabled via XML
#

var MODE = "/devices/status/mice/mouse[0]/mode";
var COLLECTIVE = "fdm/jsbsim/fcs/collective-cmd-pos";

# Tune this to adjust mouse sensitivity
var COLLECTIVE_SCALE = 0.002;

var in_mode = func {
    return getprop(MODE) == 1;
};

#
# --- COLLECTIVE (middle mouse drag = button[1]) ---
#
var collective_handler = func {

    if (!in_mode()) return;

    # Middle mouse is button[1] on your hardware
    if (getprop("/devices/status/mice/mouse[0]/button[1]") != 1) return;

    # Your system updates accel-x / accel-y
    var dx = getprop("/devices/status/mice/mouse[0]/accel-x");
    var dy = getprop("/devices/status/mice/mouse[0]/accel-y");

    # Tuned, small increments
    var delta = (dx + dy) * COLLECTIVE_SCALE;

    var node = props.globals.getNode(COLLECTIVE);
    var val  = node.getValue() + delta;

    # Correct clamp: collective-pos-norm must stay between 0 and 1
    if (val < 0) val = 0;
    if (val > 1) val = 1;

    node.setDoubleValue(val);
};

controls.throttleMouse = func {
    return;
}

#
# Register listeners
#
setlistener("/devices/status/mice/mouse[0]/accel-x", collective_handler);
setlistener("/devices/status/mice/mouse[0]/accel-y", collective_handler);

print("AirCrane mouse override LOADED (final tuned version)");

