function state = updateState(p, sys_n, sys_p, s, t, I)

%%% Solid-phase Diffusion %%%
% Spherical Diffusion Simulation
[c_ss_n,t,c_nx] = lsim(sys_n,I,t,s.c_nx);     % Anode Particle
[c_ss_p,t,c_px] = lsim(sys_p,I,t,s.c_px);     % Cathode Particle

% Aggregate states
c_n = [c_nx(:,1), c_nx, c_ss_n];
c_p = [c_px(:,1), c_px, c_ss_p];

end

