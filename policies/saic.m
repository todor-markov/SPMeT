run param/params_LCO.m

%p.T_amb = 308.15;
p = updateParams(p, 30);
[sys_n, sys_p] = getSys(p);

VMin = 3.0;
VMax = 4.2;

ChParams = [3, 0.1];
stepTypes = [1, 2];
VCutoffs = [1,1];
DschRate = -3;

tic
[s1, v1, soc1, s2, v2, soc2] = runPolicy(p, sys_n, sys_p, VMin, VMax, ChParams, stepTypes, VCutoffs, DschRate);
toc