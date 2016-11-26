function p = updateParams(p, Nr)

% Calculate C-rate in terms of [A/m^2] using low/high voltage cutoffs
[cn_low,cp_low] = init_cs(p,p.volt_min);
[cn_high,cp_high] = init_cs(p,p.volt_max);
Delta_cn = cn_high-cn_low;
Delta_cp = cp_low-cp_high;
p.OneC = min(p.epsilon_s_n*p.L_n*Delta_cn*p.Faraday/3600, p.epsilon_s_p*p.L_p*Delta_cp*p.Faraday/3600);

% clear Delta_cn Delta_cp cn_low cp_low cn_high cp_high

%% Preallocation

% Finite difference for spherical particle
p.Nr = Nr; % 100 Make this very large so it closely approximates the true model
p.delta_r_n = 1/p.Nr;
p.delta_r_p = 1/p.Nr;
p.r_vec = (0:p.delta_r_n:1)';

%% ISOTHERMAL assumption: Set temperature-dependent parameters as constants

% Solid phase diffusivity
p.D_s_n = p.D_s_n0 * exp(p.E.Dsn/p.R*(1/p.T_ref - 1/p.T_amb));
p.D_s_p = p.D_s_n0 * exp(p.E.Dsp/p.R*(1/p.T_ref - 1/p.T_amb));

% Kinetic reaction rate
p.k_n = p.k_n0 * exp(p.E.kn/p.R*(1/p.T_ref - 1/p.T_amb));
p.k_p = p.k_p0 * exp(p.E.kp/p.R*(1/p.T_ref - 1/p.T_amb));


%% Electrolyte concentration matrices
[M1n,M2n,M3n,M4n,M5n, M1s,M2s,M3s,M4s, M1p,M2p,M3p,M4p,M5p, C_ce] = c_e_mats(p);

p.ce.M1n = M1n;
p.ce.M2n = M2n;
p.ce.M3n = M3n;
p.ce.M4n = M4n;
p.ce.M5n = M5n;

p.ce.M1s = M1s;
p.ce.M2s = M2s;
p.ce.M3s = M3s;
p.ce.M4s = M4s;

p.ce.M1p = M1p;
p.ce.M2p = M2p;
p.ce.M3p = M3p;
p.ce.M4p = M4p;
p.ce.M5p = M5p;

p.ce.C = C_ce;

% clear M1n M2n M3n M4n M5n M1s M2s M3s M4s M1p M2p M3p M4p M5p C_ce;
% clear A_n A_p B_n B_p C_n C_p D_n D_p MN_mats