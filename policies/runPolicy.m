function [states_ch, Voltage_ch, SOC_n_ch, states_dsch, Voltage_dsch, SOC_n_dsch] = runPolicy(p, sys_n, sys_p, VMin, VMax, ChParams, stepTypes, VCutoffs, DschRate)

s = getInitState(p, sys_n, sys_p, VMin);

states_ch = s;
Voltage_ch = s.V;
SOC_n_ch = s.SOC_n;

ki = 10;

for k = 1:length(stepTypes)
    if stepTypes(k) == 1
        while s.V < VCutoffs(k) * VMax
            s = updateState(p, sys_n, sys_p, s, -ChParams(k) * p.OneC);
            states_ch(end+1) = s;
            Voltage_ch(end+1) = s.V;
            SOC_n_ch(end+1) = s.SOC_n;
        end
    end
    
    if stepTypes(k) == 2
        acc_err = 0
        for i = 1:10
            err = VCutoffs(k) * VMax - s.V;
            acc_err = acc_err + err;
            s = updateState(p, sys_n, sys_p, s, -(ki * acc_err) * p.OneC);
            states_ch(end+1) = s;
            Voltage_ch(end+1) = s.V;
            SOC_n_ch(end+1) = s.SOC_n;
        end
        
        while s.I < -ChParams(k) * p.OneC
            err = VCutoffs(k) * VMax - s.V;
            acc_err = acc_err + err;
            s = updateState(p, sys_n, sys_p, s, -(ki * acc_err) * p.OneC);
            states_ch(end+1) = s;
            Voltage_ch(end+1) = s.V;
            SOC_n_ch(end+1) = s.SOC_n;
        end
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

