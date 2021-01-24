var autostart = func (msg=1) {
    aircrane.autostart();
};

#var slewProp = func(prop, delta) {
#    #delta *= getprop("/sim/time/delta-realtime-sec");
#    var limit = getprop("/sim/cargo/rope/segments-reeled-in") + delta;
#    if (0 <= limit and limit <= 86) {
#        setprop(prop, getprop(prop) + delta);
#        return getprop(prop); # must read again because of clamping
#    }
#}