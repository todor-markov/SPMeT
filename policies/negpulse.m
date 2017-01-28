clear

run ../param/params_LCO.m
addpath ../


p = updateParams(p, 30);
[sys_n, sys_p] = getSys(p);

VMin = 3.0;
VMax = 4.2;
ki = 10;

s = getInitState(p, sys_n, sys_p, VMin);

s1 = s;
v1 = s.V;
soc1 = s.SOC_n;

while s.V < VMax
    for k = 1:180
        s = updateState(p, sys_n, sys_p, s, -1 * p.OneC);
        s1(end+1) = s;
        v1(end+1) = s.V;
        soc1(end+1) = s.SOC_n;
        if s.V >= VMax
            break
        end
    end
    
    if s.V >= VMax
        break
    end
    
    for k = 1:3
        s = updateState(p, sys_n, sys_p, s, 0.5 * p.OneC);
        s1(end+1) = s;
        v1(end+1) = s.V;
        soc1(end+1) = s.SOC_n;
        if s.V >= VMax
            break
        end
    end
end

acc_err = 0
for i = 1:10
    err = 1 * VMax - s.V;
    acc_err = acc_err + err;
    s = updateState(p, sys_n, sys_p, s, -(ki * acc_err) * p.OneC);
    s1(end+1) = s;
    v1(end+1) = s.V;
    soc1(end+1) = s.SOC_n;
end


while s.I < -0.1 * p.OneC
    err = 1 * VMax - s.V;
    acc_err = acc_err + err;
    s = updateState(p, sys_n, sys_p, s, -(ki * acc_err) * p.OneC);
    s1(end+1) = s;
    v1(end+1) = s.V;
    soc1(end+1) = s.SOC_n;
end

s2 = s;
v2 = s.V;
soc2 = s.SOC_n;

while s.V > VMin
    s = updateState(p, sys_n, sys_p, s, 3 * p.OneC);
    s2(end+1) = s;
    v2(end+1) = s.V;
    soc2(end+1) = s.SOC_n;
end    
