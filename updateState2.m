function state = updateState2(p, sys_n, sys_p, s, I, time)

%%% Solid-phase Diffusion %%%
% Spherical Diffusion Simulation
I = [s.I; I * ones(time,1)];
[c_ss_n,t,c_nx] = lsim(sys_n,I,0:time,s.c_nx);     % Anode Particle
[c_ss_p,t,c_px] = lsim(sys_p,I,0:time,s.c_px);     % Cathode Particle

% Aggregate states
c_n = [c_nx(:,1), c_nx, c_ss_n];
c_p = [c_px(:,1), c_px, c_ss_p];


data.time = 0:time;
data.cur = I;
data.c_e0 = s.c_e;
% Simulate electrolyte dynamics for a given input & initial conditions
c_e = electrolyte_scott(data, p);
% Electrolyte concentration endpoints
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


%%% Voltage Output Function %%%
state = s;

for k = 2:time
    % SPMe Voltage w/o electrolyte concentration term
    state(k).V_noVCE = nonlinearSPMOutputVoltage_Scott(p,c_ss_n(k),c_ss_p(k),cen_bar(k),ces_bar(k),cep_bar(k),I(k));
    
    % Overpotentials due to electrolyte subsystem
    kap_n = electrolyteCond(cen_bar(k));
    kap_s = electrolyteCond(ces_bar(k));
    kap_p = electrolyteCond(cep_bar(k));
    
    kap_n_eff = kap_n * p.epsilon_e_n.^(p.brug);
    kap_s_eff = kap_s * p.epsilon_e_s.^(p.brug);
    kap_p_eff = kap_p * p.epsilon_e_p.^(p.brug);
    
    % Activity coefficient
    dfca_n = electrolyteAct(cen_bar(k),s.T,p);
    dfca_s = electrolyteAct(ces_bar(k),s.T,p);
    dfca_p = electrolyteAct(cep_bar(k),s.T,p);
    
    if( (ce0p(k) < 0) || ce0n(k) < 0)
        error('Error: The electrolyte concentration became negative, which is non-physical. You probably tried a C-rate that is too high. Try reducing your C-rate. (This occured because the SPMe does not capture a self-limiting process that prevents c_e from becoming negative.)');
    end
    
    % Overpotential due to electrolyte conductivity
    state(k).V_electrolyteCond = (p.L_n/(2*kap_n_eff) + 2*p.L_s/(2*kap_s_eff) + p.L_p/(2*kap_p_eff))*I(k); ...
        
    % Overpotential due to electrolyte polarization
    state(k).V_electrolytePolar = (2*p.R*p.T_amb)/(p.Faraday) * (1-p.t_plus)* ...
            ( (1+dfca_n) * (log(cens(k)) - log(ce0n(k))) ...
             +(1+dfca_s) * (log(cesp(k)) - log(cens(k))) ...
             +(1+dfca_p) * (log(ce0p(k)) - log(cesp(k))));
    
    % Add 'em up!
    state(k).V = state(k).V_noVCE + state(k).V_electrolyteCond + state(k).V_electrolytePolar;
    
    % SPM Voltage
    state(k).V_spm = nonlinearSPMOutputVoltage_Scott(p,c_ss_n(k),c_ss_p(k),p.c_e,p.c_e,p.c_e,I(k));
    
    % State-of-Charge (Bulk)
    state(k).SOC_n = 3/p.c_s_n_max * trapz(p.r_vec,p.r_vec.^2.*c_n(k,:)');
    state(k).SOC_p = 3/p.c_s_p_max * trapz(p.r_vec,p.r_vec.^2.*c_p(k,:)');
    
    % Total Moles of Lithium in Solid
    state(k).n_Li_s = (3*p.epsilon_s_p*p.L_p*p.Area) * trapz(p.r_vec,p.r_vec.^2.*c_p(k,:)') ...
            + (3*p.epsilon_s_n*p.L_n*p.Area) * trapz(p.r_vec,p.r_vec.^2.*c_n(k,:)');
        
    state(k).c_e = c_e_nb(:,k);
    state(k).c_e_bcs = [ce0n(k); cens(k); cesp(k); ce0p(k)];
    state(k).c_nx = c_nx(k,:);
    state(k).c_px = c_px(k,:);
    state(k).c_ss_n = c_ss_n(k);
    state(k).c_ss_p = c_ss_p(k);
    state(k).T = s.T;
    state(k).I = I(k);
    
end


end

