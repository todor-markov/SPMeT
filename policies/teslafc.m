clear

run ../param/params_LCO.m
addpath ../


p = updateParams(p, 30);
[sys_n, sys_p] = getSys(p);

VMin = 3.0;
VMax = 4.2;
restPeriod = 30;

ChRate = [2,1.47,0.735,0.7,0.49,0.36,0.29,0.24,0.21,0.15];
VCutoffs = [0.95,0.95,0.95,1,1,1,1,1,1,1];
DschRate = -3;

[s1, v1, soc1, s2, v2, soc2] = runPolicy(p, sys_n, sys_p, VMin, VMax, restPeriod, ChRate, VCutoffs, DschRate);
