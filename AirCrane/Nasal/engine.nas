
# =============================== Hobbs meter =======================================

# goes here


# ========== rotor brake ======================

# Toggles the state of rotor brake pressure
var pumpRotorBrake = func {
    var push = getprop("/controls/rotorbrake/rotorbrake-handle") or 0;
    var brake = getprop("systems/electrical/outputs/rotorbrake");

    if (push) {
        var pump = getprop("/controls/rotorbrake/rotorbrake") or 0;
        if (pump < 10)
          setprop("/controls/rotorbrake/rotorbrake", pump + 1);
        setprop("/controls/rotorbrake/rotorbrake-handle", 0);
    }
    else {
        setprop("/controls/rotorbrake/rotorbrake-handle", 1);
    }
    if(brake == -1) {
        setprop("controls/rotor/brake", pump * .1);
    }
};

# Toggles the state of N1 or N2 start button
var cycleN1Start = func (x){
    setprop("/controls/switches/"~x, 1);
    settimer(func {
            setprop("/controls/switches/"~x, 0);
        }, 3);
};
