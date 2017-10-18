var digital_display =
  {

    new : func(designation, model_element, parameter, num_display)
      {
        var obj = {parents : [digital_display] };
        obj.designation = designation;
        obj.model_element = model_element;
        obj.parameter = parameter;

        var dev_canvas= canvas.new({
          "name": designation,
          "size": [128,128], 
          "view": [128,128],                        
          "mipmapping": 0     
        });

        dev_canvas.addPlacement({"node": model_element});
        dev_canvas.setColorBackground(0,0,0,0);

        obj._canvas = dev_canvas;

        var root = dev_canvas.createGroup();

        obj.string = root.createChild("text")
        .setText(num_display)
        .setColor(.2,1,0.2)
        .setFontSize(30)
        .setScale(1,3)
        .setFont("DSEG/DSEG7/Classic-MINI/DSEG7ClassicMini-Bold.ttf")
        .setAlignment("center-bottom")
        .setTranslation(65, 105);

        obj.string.enableUpdate();

        return obj;
      },

  display : func(num_format)
    {
      var string =  sprintf(num_format, getprop("sim/model/watercannon/"~me.parameter));
      me.string.updateText(string);
    },

  update: func(num_format)
    {
      me.display(num_format);
      settimer (func me.update(num_format), 0.1);
    },

#7 caution
#7.9 red line
#20 snorkel
};

var pitch_indicator = digital_display.new("Cannon_Pitch", "cannon-pitch-glass", "position-deg", "0.00");
var snorkel_depth_indicator = digital_display.new("Snorkel_Depth", "snorkel-depth-glass", "snorkel-depth", "0.00");
var tank_volume_indicator = digital_display.new("Tank_Volume", "tank-volume-glass", "tank-volume", "000.00");
var tank_weight_indicator = digital_display.new("Tank_Weight", "tank-weight-glass", "tank-weight", "00000");

pitch_indicator.update("%1.2f");
snorkel_depth_indicator.update("%1.2f");
tank_volume_indicator.update("%3.2f");
tank_weight_indicator.update("%5.0f");

#################### watertank ####################

# 1 Gallon = 8.345404 lbs * 2500 = 20863 lbs

var capacity = 0.0;
var weight = 0.0;
var volume = 0.0;
var flow = 0.0;
var cannonpitch = 0;

var tank_operations = func {

	var paused = getprop("sim/freeze/clock");
	var crashed = getprop("sim/crashed");

  if (crashed or paused) {
    setprop("sim/model/firetank/waterdropparticlectrl", 0);
    setprop("sim/model/firetank/waterdropretardantctrl", 0);
    setprop("sim/model/firetank/watercannonparticlectrl", 0);
    setprop("sim/model/firetank/watercannonretardantctrl", 0);
    return;
  }

	var cannon = getprop("sim/model/watercannon/enabled");
	var cannonvalveopen = getprop("sim/model/firetank/opencannonvalve");
	var tankdooropen = getprop("sim/model/firetank/opentankdoors");
	var hopperweight = getprop("sim/weight[3]/weight-lb");
	var scoopdown = getprop("sim/model/firetank/deployramscoop/position-norm");
	var sniffer = getprop("sim/model/firetank/deployflexhose/position-norm");
	var overland = getprop("gear/gear/ground-is-solid");
	var altitude = getprop("position/altitude-agl-ft");
	var groundspeed = getprop("velocities/groundspeed-kt");
  #may want to use /velocities/equivalent-kt
  var airspeed = getprop("velocities/airspeed-kt");
	var particles = getprop("sim/model/aircrane/effects/particles/enabled");
	var normalized = 1-(altitude-0)/(60-0);
  var quantity = getprop("sim/model/firetank/quantity");
  var coverage = getprop("sim/model/firetank/coverage");
  var cannontoggle = getprop("sim/model/watercannon/togglecannonpitch");

	setprop("/sim/model/aircrane/effects/particles/redcombined", getprop("/rendering/scene/diffuse/red")*.95);
	setprop("/sim/model/aircrane/effects/particles/greencombined", getprop("/rendering/scene/diffuse/red")*.98);
	setprop("/sim/model/aircrane/effects/particles/bluecombined", getprop("/rendering/scene/diffuse/red")*1);

	setprop("sim/model/firetank/waterdropparticlectrl", tankdooropen*hopperweight*particles);
	setprop("sim/model/firetank/watercannonparticlectrl", cannonvalveopen*hopperweight*particles);

	if (!overland and particles and altitude < 27.5 and (sniffer > 0 and sniffer < 1) and sniffer < normalized)
		setprop("sim/model/firetank/snorkelsplashparticlectrl", 1);
	else
		setprop("sim/model/firetank/snorkelsplashparticlectrl", 0);
	
  if (cannonvalveopen and hopperweight and cannon)
    {
		  #300 * 8.345 weight per gal = 2503.5 weight per minute / 60 = 41.72 per second / 4 (.25 seconds timer cycle) = 10.43 capacity per cycle
   		#300 gal per minute / 60 = 5 per second / 4 (.25 seconds timer cycle) = 1.25 per cycle * 8.345 weight per gallon = 10.43 capacity per cycle
      # more precisely 290.58 gal per minute
      capacity = 10.43; 
		  if (hopperweight > 0)
        hopperweight = hopperweight - capacity;
		  setprop("sim/weight[3]/weight-lb", hopperweight);
    }

	if (tankdooropen and hopperweight)
    {     
      #coverage is one of 9 modes, 100% salvo dump load/velocities/equivalent-kt in three seconds
      #quantity is one of 5 modes, safe and 25% - 100%
      #capacity = 1738.53, equals full load in 3 seconds

      if (quantity == 1) weight = 5215.62;
      else if (quantity == 2) weight = 10431.25;
      else if (quantity == 3) weight = 15646.87;
      else if (quantity == 4) weight = 20862.5;

      if (coverage == 0)
        {
          #1 gallon per 100 sqft = 1 gal * 8.345 weight per gal = 8.345 lbs
          capacity = 0.352; 
        }
      else
      if (coverage == 1)
        {
          #2 gallon per 100 sqft = 2 gal * 8.345 weight per gal = 16.69 lbs
          capacity = 0.704; 
        }
      else
      if (coverage == 2)
        {
          #3 gallon per 100 sqft = 3 gal * 8.345 weight per gal = 25.035 lbs
          capacity = 1.056; 
        }
      else
      if (coverage == 3)
        {
          #4 gallon per 100 sqft = 4 gal * 8.345 weight per gal = 33.38 lbs
          capacity = 1.408; 
        }
      else
      if (coverage == 4)
        {
          #5 gallon per 100 sqft = 5 gal * 8.345 weight per gal = 41.725 lbs
          capacity = 1.760; 
        }
      else
      if (coverage == 5)
        {
          #6 gallon per 100 sqft = 6 gal * 8.345 weight per gal = 50.07 lbs
          capacity = 2.112; 
        }
      else
      if (coverage == 6)
        {
          #7 gallon per 100 sqft = 7 gal * 8.345 weight per gal = 58.415 lbs
          capacity = 2.464; 
        }
      else
      if (coverage == 7)
        {
          #8 gallon per 100 sqft = 8 gal * 8.345 weight per gal = 66.76 lbs
          capacity = 2.816;
        }
      else
      if (coverage == 8)
        {
          #2500 gal * 8.345 weight per gal = 20862.5 / 3 sec dump = 6954.17 per sec / 4 (.25 seconds timer cycle) = 1738.54 capacity per cycle
          #2500 gal / 3 sec dump = 833.33 per second / 4 (.25 seconds timer cycle) = 208.33 * 8.345 weight per gallon = 1738.51 capacity per cycle
          capacity = 1738.53;
          
        }

      if (coverage < 8)
        {
          flow = capacity * airspeed;
          setprop("sim/model/firetank/droprate", 100 + (400-100) * (flow - .350) / (307-.350));
        }
      else
        {
          flow = capacity;
          setprop("sim/model/firetank/droprate", 400);
        }

      if (volume < weight)
        {
          if (flow > (weight-volume))
            flow = (weight-volume);

          volume = volume + flow;
          hopperweight = hopperweight - flow;

          if (hopperweight < 10)
            {
              volume = 0;
              hopperweight = 0;
              setprop("sim/weight[3]/weight-lb",0);
              setprop("sim/model/firetank/opentankdoors", 0);
            }
          else
            setprop("sim/weight[3]/weight-lb", hopperweight);
        }
      else
        {
          setprop("sim/model/firetank/opentankdoors", 0);
          volume = 0;
        }      
    }

	if (!overland and scoopdown == 1 and altitude < 26.5 and groundspeed > 25) {
		#2500 gal * 8.345 weight per gal = 20862.5 / 40 second fill = 521.56 per sec / 4 (.25 seconds timer cycle) = 130.39 capacity per cycle
		#2500 gal / 40 sec = 62.5 per sec / 4 (.25 seconds timer cycle) = 15.62 * 8.345 weight per gallon = 130.35 capacity per cycle
		capacity = 130.37;
		if (hopperweight < 20000) 
        	hopperweight = hopperweight + capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
	}
	if (!overland and !sniffer and altitude < 27.5 and groundspeed < 35) {
		#2500 gal * 8.345 weight per gal = 20862.5 / 45 second fill = 463.61 per sec / 4 (.25 seconds timer cycle) = 115.90 capacity per cycle
		#2500 gal / 45 sec = 55.55 per second / 4 (.25 seconds timer cycle) = 13.89 * 8.345 weight per gallon = 115.91 capacity per cycle
		capacity = 115.91;
		if (hopperweight < 20000) 
        	hopperweight = hopperweight + capacity;
		setprop("sim/weight[3]/weight-lb", hopperweight);
	}

	if (hopperweight < 0 or hopperweight == 0 or getprop("sim/weight[3]/weight-lb") < 0 or getprop("sim/weight[3]/weight-lb") == 0) {
    volume = 0;
		hopperweight = 0;
		setprop("sim/weight[3]/weight-lb", 0);
    setprop("sim/model/firetank/opentankdoors", 0);
	}

  if (tankdooropen and hopperweight)
    setprop("sim/model/firetank/waterdropretardantctrl", 1);
  else
    setprop("sim/model/firetank/waterdropretardantctrl", 0);
  if (cannon and cannonvalveopen and hopperweight)
    setprop("sim/model/firetank/watercannonretardantctrl", 1);
  else
    setprop("sim/model/firetank/watercannonretardantctrl", 0);

  setprop("sim/model/watercannon/tank-volume", hopperweight/20000);
  setprop("sim/model/watercannon/tank-weight", hopperweight);
  setprop("sim/model/watercannon/snorkel-depth", getprop("position/gear-agl-ft"));

  if (cannontoggle == 1)
    {
      if (cannonpitch < 7.5)
        cannonpitch = cannonpitch + .25;
    }
  else
  if (cannontoggle == -1)
    {
      if (cannonpitch > -7.5)
      cannonpitch = cannonpitch - .25;
    }

   setprop("sim/model/watercannon/position-deg", cannonpitch);
}