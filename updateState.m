function state = updateState(p, sys_n, sys_p, s, I)

%%% Solid-phase Diffusion %%%
% Spherical Diffusion Simulation
%fprintf('1\n')
%tic
[c_ss_n,t,c_nx] = lsim(sys_n,[s.I,I,I],0:2,s.c_nx);     % Anode Particle
[c_ss_p,t,c_px] = lsim(sys_p,[s.I,I,I],0:2,s.c_px);     % Cathode Particle

% Aggregate states
c_n = [c_nx(:,1), c_nx, c_ss_n];
c_p = [c_px(:,1), c_px, c_ss_p];


data.time = 0:2;
data.cur = [s.I;I;I];
data.c_e0 = s.c_e;
%toc
% Simulate electrolyte dynamics for a given input & initial conditions
%fprintf('2\n')
%tic
c_e = electrolyte_scott(data, p);
%toc
% Electrolyte concentration endpoints
%fprintf('3\n')
%tic
ce0n = c_e(1,:);
cens = c_e(p.Nxn+1,:);
cesp = c_e(p.Nxn+p.Nxs+1,:);
ce0p = c_e(end,:);

% Electrolyte concentration without the endpoints
c_e_nb = [c_e(2:p.Nxn, :); c_e((p.Nxn+2):(p.Nxn+p.Nxs),:); c_e((p.Nxn+p.Nxs+2):(end-1),:)];

% Average electrolyte concentrations
cen_bar = mean(c_e(1:p.Nxn+1,:));
ces_bar = mean(c_e((p.Nxn+1):(p.Nxn+p.Nxs+1),:));
cep_bar = mean(c_e((p.Nxn+p.Nxs+1):(p.Nxn+p.Nxs+p.Nxp+1),:));

% SPMe Voltage w/o electrolyte concentration term
V_noVCE = nonlinearSPMOutputVoltage_Scott(p,c_ss_n(2),c_ss_p(2),cen_bar(2),ces_bar(2),cep_bar(2),I);


% Overpotentials due to electrolyte subsystem
kap_n = electrolyteCond(cen_bar(2));
kap_s = electrolyteCond(ces_bar(2));
kap_p = electrolyteCond(cep_bar(2));
    
kap_n_eff = kap_n * p.epsilon_e_n.^(p.brug);
kap_s_eff = kap_s * p.epsilon_e_s.^(p.brug);
kap_p_eff = kap_p * p.epsilon_e_p.^(p.brug);

    
% Activity coefficient
dfca_n = electrolyteAct(cen_bar(2),s.T,p);
dfca_s = electrolyteAct(ces_bar(2),s.T,p);
dfca_p = electrolyteAct(cep_bar(2),s.T,p);

if( (ce0p(2) < 0) || ce0n(2) < 0)
    error('Error: The electrolyte concentration became negative, which is non-physical. You probably tried a C-rate that is too high. Try reducing your C-rate. (This occured because the SPMe does not capture a self-limiting process that prevents c_e from becoming negative.)');
end

V_electrolyteCond = (p.L_n/(2*kap_n_eff) + 2*p.L_s/(2*kap_s_eff) + p.L_p/(2*kap_p_eff))*I;

V_electrolytePolar = (2*p.R*p.T_amb)/(p.Faraday) * (1-p.t_plus)* ...
                       ( (1+dfca_n) * (log(cens(2)) - log(ce0n(2))) ...
                       +(1+dfca_s) * (log(cesp(2)) - log(cens(2))) ...
                       +(1+dfca_p) * (log(ce0p(2)) - log(cesp(2))));
                   
V = V_noVCE + V_electrolyteCond + V_electrolytePolar;
V_spm = nonlinearSPMOutputVoltage_Scott(p,c_ss_n(2),c_ss_p(2),p.c_e,p.c_e,p.c_e,I);

SOC_n = 3/p.c_s_n_max * trapz(p.r_vec,p.r_vec.^2.*c_n(2,:)');
SOC_p = 3/p.c_s_p_max * trapz(p.r_vec,p.r_vec.^2.*c_p(2,:)');

n_Li_s = (3*p.epsilon_s_p*p.L_p*p.Area) * trapz(p.r_vec,p.r_vec.^2.*c_p(2,:)') ...
            + (3*p.epsilon_s_n*p.L_n*p.Area) * trapz(p.r_vec,p.r_vec.^2.*c_n(2,:)');
        

state.I = I;
state.V = V;
state.V_spm = V_spm;
state.T = s.T;
state.SOC_n = SOC_n;
state.SOC_p = SOC_p;
state.n_Li_s = n_Li_s;
state.c_e = c_e_nb(:,2);
state.c_e_bcs = [ce0n(2); cens(2); cesp(2); ce0p(2)];
state.c_nx = c_nx(2,:);
state.c_px = c_px(2,:);
state.c_ss_n = c_ss_n(2);
state.c_ss_p = c_ss_p(2);
%toc

end

