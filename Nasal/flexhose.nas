var flex_hose = func {

var deg_rot = sin(getprop("sim/model/firetank/deployflexhose")*0.01745329252);
var trans_factorX = getprop("sim/model/firetank/cradleX");
var trans_factorY = getprop("sim/model/firetank/cradleY");
var trans_factorZ = getprop("sim/model/firetank/cradleZ");

setprop("sim/model/firetank/cradleX1", (.5*trans_factorX*deg_rot));
setprop("sim/model/firetank/cradleX2", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX1"));
setprop("sim/model/firetank/cradleX3", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX2"));
setprop("sim/model/firetank/cradleX4", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX3"));
setprop("sim/model/firetank/cradleX5", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX4"));
setprop("sim/model/firetank/cradleX6", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX5"));
setprop("sim/model/firetank/cradleX7", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX6"));
setprop("sim/model/firetank/cradleX8", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX7"));
setprop("sim/model/firetank/cradleX9", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX8"));
setprop("sim/model/firetank/cradleX10", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX9"));
setprop("sim/model/firetank/cradleX11", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX10"));
setprop("sim/model/firetank/cradleX12", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX11"));
setprop("sim/model/firetank/cradleX13", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX12"));
setprop("sim/model/firetank/cradleX14", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX13"));
setprop("sim/model/firetank/cradleX15", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX14"));
setprop("sim/model/firetank/cradleX16", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX15"));
setprop("sim/model/firetank/cradleX17", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX16"));
setprop("sim/model/firetank/cradleX18", (.5*trans_factorX*deg_rot) + getprop("sim/model/firetank/cradleX17"));

#left/right offset
setprop("sim/model/firetank/cradleY1", (.5*trans_factorY*deg_rot));
setprop("sim/model/firetank/cradleY2", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY1"));
setprop("sim/model/firetank/cradleY3", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY2"));
setprop("sim/model/firetank/cradleY4", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY3"));
setprop("sim/model/firetank/cradleY5", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY4"));
setprop("sim/model/firetank/cradleY6", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY5"));
setprop("sim/model/firetank/cradleY7", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY6"));
setprop("sim/model/firetank/cradleY8", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY7"));
setprop("sim/model/firetank/cradleY9", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY8"));
setprop("sim/model/firetank/cradleY10", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY9"));
setprop("sim/model/firetank/cradleY11", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY10"));
setprop("sim/model/firetank/cradleY12", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY11"));
setprop("sim/model/firetank/cradleY13", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY12"));
setprop("sim/model/firetank/cradleY14", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY13"));
setprop("sim/model/firetank/cradleY15", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY14"));
setprop("sim/model/firetank/cradleY16", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY15"));
setprop("sim/model/firetank/cradleY17", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY16"));
setprop("sim/model/firetank/cradleY18", (.5*trans_factorY*deg_rot) + getprop("sim/model/firetank/cradleY17"));

#up/down offset
setprop("sim/model/firetank/cradleZ1", (.5*trans_factorZ*deg_rot));
setprop("sim/model/firetank/cradleZ2", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ1"));
setprop("sim/model/firetank/cradleZ3", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ2"));
setprop("sim/model/firetank/cradleZ4", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ3"));
setprop("sim/model/firetank/cradleZ5", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ4"));
setprop("sim/model/firetank/cradleZ6", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ5"));
setprop("sim/model/firetank/cradleZ7", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ6"));
setprop("sim/model/firetank/cradleZ8", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ7"));
setprop("sim/model/firetank/cradleZ9", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ8"));
setprop("sim/model/firetank/cradleZ10", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ9"));
setprop("sim/model/firetank/cradleZ11", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ10"));
setprop("sim/model/firetank/cradleZ12", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ11"));
setprop("sim/model/firetank/cradleZ13", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ12"));
setprop("sim/model/firetank/cradleZ14", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ13"));
setprop("sim/model/firetank/cradleZ15", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ14"));
setprop("sim/model/firetank/cradleZ16", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ15"));
setprop("sim/model/firetank/cradleZ17", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ16"));
setprop("sim/model/firetank/cradleZ18", (.5*trans_factorZ*deg_rot) + getprop("sim/model/firetank/cradleZ17"));

}