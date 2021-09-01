props.globals.initNode("/disintegration/spinSpeed", 0, "DOUBLE");
props.globals.initNode("/disintegration/crashTime", 0, "DOUBLE");
props.globals.initNode("/disintegration/negAGL", 0, "DOUBLE");
props.globals.initNode("/disintegration/severity", 1, "DOUBLE");

props.globals.initNode("/disintegration/parts");
var partsNode = props.globals.getNode("/disintegration/parts");

var degToRad = 3.141592654/180;
var kt2mps = 0.51444;
var ft2m = 0.3048;
var maxSpin = 36; #0.6 rev/s
var baseSpin = 4;
var g = 9.81;

var crashSlow = 0.3; #factor by which is fwd movement slowed after crash

#function for initializing parts
var initPart = func(name, dX, dY, dZ, vX=0, vY=0, vZ=0) {
  #geometrical center of the element
  props.globals.initNode("/disintegration/parts/"~name~"/dX", dX, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/dY", dY, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/dZ", dZ, "DOUBLE");
  #initial velocities, in local coords
  props.globals.initNode("/disintegration/parts/"~name~"/vX", vX, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/vX-base", vX, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/vY", vY, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/vY-base", vY, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/vZ", vZ, "DOUBLE");
  props.globals.initNode("/disintegration/parts/"~name~"/vZ-base", vZ, "DOUBLE");
  #stops the animation after part specific fall time
  props.globals.initNode("/disintegration/parts/"~name~"/falling", 0, "BOOL");
  props.globals.initNode("/disintegration/parts/"~name~"/dropped", 0, "BOOL");
}

setprop("/disX", 0);
setprop("/disY", 0);
setprop("/disZ", 0);

var disX = 0;
var disY = 0;
var disZ = 0;

#calls of previous function to initialize parts

initPart("gearN", -8.67077, 3.07897,-3.27622,-1.35, 0.13,-0.62);
#initPart("gearL", -1.05087,-3.0711 ,-0.70136,-0.1,  0.42,-0.14);
initPart("gearL", -1.05087,-3.0711 ,-0.70136, disX, disY, disZ);
initPart("gearR", -1.05268, 3.07898,-2.3245, -0.12,-0.31,-0.09);

var partsList = partsNode.getChildren();

#function for computing part specific stuff
  var setPart = func(name, AGL, groundspeed, severity, ground) {
  var pitch = degToRad * getprop("/orientation/pitch-deg");
  var roll = degToRad * getprop("/orientation/roll-deg");

  var globalVZ = ground * (2 * severity + 2 * severity * math.abs(math.sin(pitch)) + 0.04 * crashSlow * groundspeed * severity * math.abs(math.sin(pitch) * math.cos(pitch)));


  var heightX = (getprop("/disintegration/parts/"~name~"/dX")) * math.sin(pitch);
  var heightY = (getprop("/disintegration/parts/"~name~"/dY")) * math.cos(pitch) * math.sin(roll);
  var heightZ = (getprop("/disintegration/parts/"~name~"/dZ")) * math.cos(pitch) * math.cos(roll);

  var height = AGL + heightX + heightY + heightZ;

  setprop("/disintegration/parts/"~name~"/vX",
    severity * getprop("/disintegration/parts/"~name~"/vX-base") +
    groundspeed * kt2mps * crashSlow +
    globalVZ * math.sin(pitch)
  );

  setprop("/disintegration/parts/"~name~"/vY", severity * getprop("/disintegration/parts/"~name~"/vY-base") + globalVZ * math.cos(pitch) * math.sin(roll) );
  setprop("/disintegration/parts/"~name~"/vZ", severity * getprop("/disintegration/parts/"~name~"/vZ-base") + globalVZ * math.cos(pitch) * math.cos(roll) );

  var velX = getprop("/disintegration/parts/"~name~"/vX") * math.sin(pitch);
  var velY = getprop("/disintegration/parts/"~name~"/vY") * math.cos(pitch) * math.sin(roll);
  var velZ = getprop("/disintegration/parts/"~name~"/vZ") * math.cos(pitch) * math.cos(roll);

  var upV = velX + velY + velZ;

  var fallTime = (upV*upV + 2*g*height)>0 ? (upV + math.sqrt(upV*upV + 2*g*height))/g : upV/g;

  #print("name:"~name~" height:"~height~" fallTime:"~fallTime);

  setprop("/disintegration/parts/"~name~"/falling", 1);
  settimer(func{setprop("/disintegration/parts/"~name~"/falling", 0);}, fallTime>0 ? fallTime : 0);
  setprop("/disintegration/parts/"~name~"/dropped", 1);
}

var getSeverity = func {
  uBody = getprop("velocities/uBody-fps");
  vBody = getprop("velocities/vBody-fps");
  wBody = getprop("velocities/wBody-fps");
  var speed = ft2m * math.sqrt(uBody*uBody + vBody*vBody + wBody*wBody);
  return 10 - (1000/(speed + 100));
}

#fwd is based on groundspeed, side and up on impact severity

var disintegrated = 0;
var disintegrate = func(override=0, gr=nil, sev=nil) {
  if(disintegrated == 0 and (getprop("/sim/crashed") or override)) {
    disintegrated = 1;
    setprop("/sim/crashed", 1);
    setprop("/disintegration/crashTime", getprop("/sim/time/elapsed-sec"));

    var groundspeed = getprop("/velocities/groundspeed-kt");
    var negAGL = -0.3048 * getprop("/position/altitude-agl-ft");
    setprop("/disintegration/negAGL", negAGL);

    var severity = 0;
    if(sev==nil) {
      severity = getSeverity();
    } else {
      severity = sev;
    }

    var ground = 0;
    if(gr==nil) {
      if(negAGL < -15) {
        ground = 0;
      } else {
        ground = 1;
      }
    } else {
      ground = gr;
    }

    if(severity>5) {
      #explosion.explode(ground);
    }

    setprop("/disintegration/severity", severity);
    setprop("/disintegration/spinSpeed", 0);
    interpolate("/disintegration/spinSpeed", (severity*baseSpin)>maxSpin ? maxSpin : severity*baseSpin, 0.15);
    settimer(func{interpolate("/disintegration/spinSpeed", baseSpin, 3);}, 0.15);

    #loop over all parts and prepare them for animation
    foreach(var p; partsList) {
      setPart(p.getName(), -negAGL, groundspeed, severity, ground);
    }

  } else {
    if(getprop("/sim/crashed") == 0 and disintegrated == 1) {
      disintegrated = 0;
      #explosion.stopFire();
      #set all falling to 1 briefly to enable position reset
      foreach(var p; partsList) {
        var nameStr = p.getName();
        setprop("/disintegration/parts/"~nameStr~"/falling", 1);
        settimer(func{setprop("/disintegration/parts/"~nameStr~"/falling", 0);}, 0.3);
        setprop("/disintegration/parts/"~nameStr~"/dropped", 0);
      }
    }
  }
}

setlistener("/sim/crashed", func{

  if (getprop("/sim/crashed")) {
    disX = getprop("/disX");
    disY = getprop("/disY");
    disZ = getprop("/disZ");
    initPart("gearL", -1.05087,-3.0711 ,-0.70136, disX, disY, disZ);
  }

  disintegrate();

});
