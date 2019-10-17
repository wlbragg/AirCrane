
# =============================== Hobbs meter =======================================

# goes here


# ========== rotor brake ======================

# Toggles the state of rotor brake pressure
var pumpRotorBrake = func {
    var push = getprop("/controls/rotorbrake/rotorbrake-handle") or 0;

    if (push) {
        var pump = getprop("/controls/rotorbrake/rotorbrake") or 0;
        setprop("/controls/rotorbrake/rotorbrake", pump + 1);
        setprop("/controls/rotorbrake/rotorbrake-handle", 0);
    }
    else {
        setprop("/controls/rotorbrake/rotorbrake-handle", 1);
    }
};

# Applies the rotorbrake automatically. This function takes several seconds
var autoPump = func {
    var p = getprop("/controls/rotorbrake/rotorbrake") or 0;
    if (p < 3) {
        pumpRotorBrake();
        settimer(autoPump, 1);
    }
};
