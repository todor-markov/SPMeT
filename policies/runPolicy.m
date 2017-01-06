function [states_ch, Voltage_ch, SOC_n_ch, states_dsch, Voltage_dsch, SOC_n_dsch] = runPolicy(p, sys_n, sys_p, VMin, VMax, restPeriod, ChRate, VCutoffs, DschRate)

s = getInitState(p, sys_n, sys_p, VMin);

states_ch = s;
Voltage_ch = s.V;
SOC_n_ch = s.SOC_n;

for k = 1:length(ChRate)
    while s.V < VCutoffs(k) * VMax
        s = updateState(p, sys_n, sys_p, s, -ChRate(k) * p.OneC);
        states_ch(end+1) = s;
        Voltage_ch(end+1) = s.V;
        SOC_n_ch(end+1) = s.SOC_n;
    end
    
    if k == length(ChRate)
        break
    end
    
    for j = 1:restPeriod
        s = updateState(p, sys_n, sys_p, s, 0);
        states_ch(end+1) = s;
        Voltage_ch(end+1) = s.V;
        SOC_n_ch(end+1) = s.SOC_n;
    end        
end

states_dsch = s;
Voltage_dsch = s.V;
SOC_n_dsch = s.SOC_n;

while s.V > VMin
    s = updateState(p, sys_n, sys_p, s, -DschRate * p.OneC);
    states_dsch(end+1) = s;
    Voltage_dsch(end+1) = s.V;
    SOC_n_dsch(end+1) = s.SOC_n;
end    

end

