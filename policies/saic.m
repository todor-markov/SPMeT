run ../param/params_LCO.m
addpath ../

p.T_amb = 308.15;
p = updateParams(p, 30);
[sys_n, sys_p] = getSys(p);

VMin = 3.0;
VMax = 4.2;
restPeriod = 30;

ChRate = [3, 2.2, 1.1, .735];
VCutoffs = [1,1,1,1];
DschRate = -3;

[s1, v1, soc1, s2, v2, soc2] = runPolicy(p, sys_n, sys_p, VMin, VMax, restPeriod, ChRate, VCutoffs, DschRate);

