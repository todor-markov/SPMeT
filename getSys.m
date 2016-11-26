function [sys_n, sys_p] = getSys(p)

% Construct (A,B) matrices for solid-phase Li diffusion
[A_n,A_p,B_n,B_p,C_n,C_p,D_n,D_p,MN_mats] = spm_plant_obs_mats(p);

sys_n = ss(A_n,B_n,C_n,D_n);
sys_p = ss(A_p,B_p,C_p,D_p);

end

