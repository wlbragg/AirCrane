##########################################
# Positional Click Sound Helper
##########################################

var click = func (name, xpos=-12.21132, ypos=-0.03679, zpos=-0.83401, timeout=0.1, delay=0.) {

  var sound_prop = "/sim/model/aircrane/sound/click-" ~ name;

  setprop("/sim/model/aircrane/sound/click-pos-x", xpos);
  setprop("/sim/model/aircrane/sound/click-pos-y", ypos);
  setprop("/sim/model/aircrane/sound/click-pos-z", zpos);

  settimer(func {
    # Play the sound
    setprop(sound_prop, 1);

    # Reset the property after "timeout" so that the sound can be played again.
    settimer(func {
      setprop(sound_prop, 0);
    }, timeout);
  }, delay);
};
