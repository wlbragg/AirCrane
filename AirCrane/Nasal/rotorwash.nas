var landcover_map = {
        Asphalt:                0.1,
        Freeway:                0.1,
        Road:                   0.1,
        BuiltUpCover:           0.1,
        Town:                   0.1,
        SubUrban:               0.1,
        pa_centerline:          0.1,
        pa_aim:                 0.1,
        pa_rest:                0.1,
        pa_shoulder:            0.1,
        pa_shoulder_f:          0.1,
        pa_taxiway:             0.1,
        pa_tiedown:             0.1,
        pa_dspl_thresh:         0.1,
        pa_dspl_arrows:         0.1,
        pa_threshold:           0.1,
        pa_no_threshold:        0.1,
        pa_stopway:             0.1,
        pa_L:                   0.1,
        pa_R:                   0.1,
        pa_C:                   0.1,
        pa_0l:                  0.1,
        pa_0r:                  0.1,
        pa_1c:                  0.1,
        pa_1l:                  0.1,
        pa_1r:                  0.1,
        pa_11:                  0.1,
        pa_2c:                  0.1,
        pa_2l:                  0.1,
        pa_2r:                  0.1,
        pa_3c:                  0.1,
        pa_3l:                  0.1,
        pa_3r:                  0.1,
        pa_4c:                  0.1,
        pa_4r:                  0.1,
        pa_5c:                  0.1,
        pa_5r:                  0.1,
        pa_6c:                  0.1,
        pa_6r:                  0.1,
        pa_7c:                  0.1,
        pa_7r:                  0.1,
        pa_8c:                  0.1,
        pa_8r:                  0.1,
        pa_9c:                  0.1,
        pa_9r:                  0.1,
        pa_tz_three:            0.1,
        pa_aim:                 0.1,
        pa_aim_uk:              0.1,
        pa_tz_two_a:            0.1,
        pa_tz_two_b:            0.1,
        pa_tz_one_a:            0.1,
        pa_tz_one_b:            0.1,
        pa_centerline:          0.1,
        pa_rest:                0.1,
        pa_heli:                0.1,
        pc_taxiway:             0.1,
        pc_tiedown:             0.1,
        pc_dspl_thresh:         0.1,
        pc_dspl_arrows:         0.1,
        pc_shoulder:            0.1,
        pc_shoulder_f:          0.1,
        pc_threshold:           0.1,
        pc_no_threshold:        0.1,
        pc_stopway:             0.1,
        pc_L:                   0.1,
        pc_R:                   0.1,
        pc_C:                   0.1,
        pc_0l:                  0.1,
        pc_0r:                  0.1,
        pc_1c:                  0.1,
        pc_1l:                  0.1,
        pc_1r:                  0.1,
        pc_11:                  0.1,
        pc_2c:                  0.1,
        pc_2l:                  0.1,
        pc_2r:                  0.1,
        pc_3c:                  0.1,
        pc_3l:                  0.1,
        pc_3r:                  0.1,
        pc_4c:                  0.1,
        pc_4r:                  0.1,
        pc_5c:                  0.1,
        pc_5r:                  0.1,
        pc_6c:                  0.1,
        pc_6r:                  0.1,
        pc_7c:                  0.1,
        pc_7r:                  0.1,
        pc_8c:                  0.1,
        pc_8r:                  0.1,
        pc_9c:                  0.1,
        pc_9r:                  0.1,
        pc_tz_three:            0.1,
        pc_aim:                 0.1,
        pc_aim_uk:              0.1,
        pc_tz_two_a:            0.1,
        pc_tz_two_b:            0.1,
        pc_tz_one_a:            0.1,
        pc_tz_one_b:            0.1,
        pc_centerline:          0.1,
        pc_rest:                0.1,
        pc_heli:                0.1,
        BarrenCover:            0.1,
        YellowSign:             0.1,
        RedSign:                0.1,
        BlackSign:              0.1,
        FramedSign:             0.1,
        UnidirectionalTaper:    0.1,
        UnidirectionalTaperRed: 0.1,
        UnidirectionalTaperGreen:0.1,
        BidirectionalTaper:     0.1,
        EvergreenNeedleCover:   0.3,
        GolfCourse:             0.3,
        DeciduousNeedleCover:   0.3,
        MixedForestCover:       0.3,
        Urban:                  0.3,
        CropWoodCover:          0.4,
        DeciduousBroadCover:    0.4,
        EvergreenBroadCover:    0.4,
        MixedCrop:              0.5,
        ComplexCrop:            0.5,
        Construction:           0.5,
        Railroad:               0.5,
        SomeSort:               0.5,
        DryCropPastureCover:    0.6,
        MixedCropPastureCover:  0.6,
        IrrCropPastureCover:    0.6,
        DryCrop:                0.6,
        Rock:                   0.6,
        NaturalCrop:            0.6,
        HerbTundraCover:        0.6,
        Island:                 0.6,
        grass_rwy:              0.7,
        GrassCover:             0.7,
        CropGrassCover:         0.7,
        Grass:                  0.7,
        Grassland:              0.7,
        ShrubCover:             0.7,
        Shrub:                  0.7,
        Sand:                   1.0,
        BarrenCover:            1.0,
        Landmass:               1.0,
        Glacier:                1.0,
        SnowCover:              1.0,
        DryLake:                1.0,
        IntermittentStream:     1.0,
        Lava:                   1.0,
        PackIce:                1.0,
        dirt_rwytiedown:        1.0,
        dirt_rwytaxiway:        1.0,
        dirt_rwythreshold:      1.0,
        dirt_rwyL:              1.0,
        dirt_rwyR:              1.0,
        dirt_rwyC:              1.0,
        dirt_rwy0l:             1.0,
        dirt_rwy0r:             1.0,
        dirt_rwy1c:             1.0,
        dirt_rwy1l:             1.0,
        dirt_rwy1r:             1.0,
        dirt_rwy11:             1.0,
        dirt_rwy2c:             1.0,
        dirt_rwy2l:             1.0,
        dirt_rwy2r:             1.0,
        dirt_rwy3c:             1.0,
        dirt_rwy3l:             1.0,
        dirt_rwy3r:             1.0,
        dirt_rwy4c:             1.0,
        dirt_rwy4r:             1.0,
        dirt_rwy5c:             1.0,
        dirt_rwy5r:             1.0,
        dirt_rwy6c:             1.0,
        dirt_rwy6r:             1.0,
        dirt_rwy7c:             1.0,
        dirt_rwy7r:             1.0,
        dirt_rwy8c:             1.0,
        dirt_rwy8r:             1.0,
        dirt_rwy9c:             1.0,
        dirt_rwy9r:             1.0,
        dirt_rwytz_three:       1.0,
        dirt_rwyaim:            1.0,
        dirt_rwyaim_uk:         1.0,
        dirt_rwytz_two_a:       1.0,
        dirt_rwy:               1.0,
        Default:                1.0,
        lakebed_taxiway:        1.0
 };

var rotor_wash_loop = func {

	##### water and grass shader effect
	var vpos = geo.viewer_position();
	var apos = geo.aircraft_position();

	var lat_to_m = 110952.0;
	var lon_to_m = math.cos(apos.lat()*math.pi/180.0) * lat_to_m;

	var alt = getprop("/position/altitude-agl-ft");

	var delta_x = (apos.lat() - vpos.lat()) * lat_to_m;
	var delta_y = -(apos.lon() - vpos.lon()) * lon_to_m;

	setprop("/environment/aircraft-effects/wash-x", delta_x);
	setprop("/environment/aircraft-effects/wash-y", delta_y);

	var rpm_factor = getprop("rotors/main/rpm")/400.0;

	var strength = 20.0/alt;
	if (strength > 1.0) {strength = 1.0;}
	strength = strength * rpm_factor;

	setprop("/environment/aircraft-effects/wash-strength", strength);

  #rotor wash particle strength
  var lat = getprop("/position/latitude-deg");
  var lon = getprop("/position/longitude-deg");
  var info = geodinfo(lat, lon);
  var dustcover = getprop("/environment/surface/dust-cover-factor");
  var wetness = getprop("/environment/surface/wetness");
  var dustfactor = getprop("/controls/engines/engine/throttle");

  if (info != nil) {
    if (info[1] != nil) {
      if (info[1].names !=nil) {
        setprop("/environment/terrain-names",info[1].names[0]);
        if (contains(landcover_map,info[1].names[0]))
          dustfactor = (1 - getprop("/controls/engines/engine/throttle")) * (landcover_map[info[1].names[0]]);
      }
    }
  }

  dustfactor = dustfactor - wetness;
	dustfactor = dustfactor + dustcover;
  setprop("/environment/terrain-dust-factor", dustfactor);

	#rotor wash particle effect colors
	var land = getprop("/gear/gear/ground-is-solid");
  var red_diffuse = getprop("/rendering/scene/diffuse/red");
  var snowlevel = getprop("/environment/snow-level-m");

	if (land)
    {
      if (alt > snowlevel)
        {
          setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedstart",   red_diffuse*.8);
	        setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedstart", red_diffuse*.8);
	        setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedstart",  red_diffuse*.8);
	        setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedend",     red_diffuse*.9);
	        setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedend",   red_diffuse*.9);
	        setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedend",    red_diffuse*.9);
        }
      else
        {
          setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedstart",   red_diffuse*.89);
		      setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedstart", red_diffuse*.76);
		      setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedstart",  red_diffuse*.57);
		      setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedend",     red_diffuse*.99);
		      setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedend",   red_diffuse*.86);
		      setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedend",    red_diffuse*.67);
        }
	  }
  else
    {
		  setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedstart",   red_diffuse*.90);
		  setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedstart", red_diffuse*.95);
		  setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedstart",  red_diffuse*.93);
		  setprop("/sim/model/aircrane/effects/particles/rotorwash/redcombinedend",     red_diffuse*.92);
		  setprop("/sim/model/aircrane/effects/particles/rotorwash/greencombinedend",   red_diffuse*.98);
		  setprop("/sim/model/aircrane/effects/particles/rotorwash/bluecombinedend",    red_diffuse*.95);
	  }
}

