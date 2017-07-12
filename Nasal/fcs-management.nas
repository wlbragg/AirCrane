#  based on OH-1 by Tatsuhiro Nishioka

# AFCS configuration

var fcs_params = {
  'gains' : {
    'cas' : {
      'input' : {
        'roll' : 60, 
        'pitch' : -60, 
        'yaw' : 30, 
        'attitude-roll' : 80, 
        'attitude-pitch' : -80, 
        'attitude-control-threshold' : 0.7,
        'rate-control-threshold' : 0.95,
        'anti-side-slip-min-speed' : 0.015
      },
      'output' : {
        'roll' : 0.06, 
        'pitch' : -0.1, 
        'yaw' : 0.5, 
        'roll-brake-freq' : 10, 
        'pitch-brake-freq' : 3, 
        'roll-brake' : 0.4, 
        'pitch-brake' : 6, 
        'anti-side-slip-gain' : -4.5,
        'heading-adjuster-gain' : -8,
        'heading-adjuster-limit' : 5 
      }
    },
    'tail-rotor' : { 
      'src-minimum' : 0.10, 
      'src-maximum' : 1.00, 
      'low-limit'   : 0.00011, 
      'high-limit'  : 0.0035, 
      'error-adjuster-gain' : -0.5
    },
    'stabilator' : { 
                     #   0    10   20    30   40   50   60   70   80   90  100  110  120  130  140  150  160, 170, 180, .....
      'gain-table' : [-0.9, -0.8, 0.1, -0.5, 0.0, 0.7, 0.8, 0.9, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.9, 0.8, 0.4, 0.2, 0.2, -1.0]
    }
  },
  'switches' : { # initial status of FCS
    'auto-hover' : 0, 
    'cas' : 1, 
    'sas' : 1, 
    'auto-stabilator' : 1, 
    'sideslip-adjuster' : 1, 
    'tail-rotor-adjuster' : 1,
    'heading-adjuster' : 1,
    'debug' : 1  # Add this only when you are adjusting FCS parameters
  }
};
    
var setAFCSConfig = func() {
  var confNode = props.globals.getNode("/controls/flight/fcs", 1);
  confNode.setValues(fcs_params);
  # This invokes fcs.initialize() 
  setprop("/sim/signals/fcs-initialized", 1);
}

_setlistener("/sim/signals/fdm-initialized", setAFCSConfig);
