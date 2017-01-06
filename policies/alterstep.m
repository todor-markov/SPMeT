clear

run ../param/params_LCO.m
addpath ../


p = updateParams(p, 30);
[sys_n, sys_p] = getSys(p);

VMin = 3.0;
VMax = 4.2;
restPeriod = 30;

s = getInitState(p, sys_n, sys_p, VMin);

s1 = s;
v1 = s.V;
soc1 = s.SOC_n;

while s.V < VMax
    for k = 1:40
        s = updateState(p, sys_n, sys_p, s, -4 * p.OneC);
        s1(end+1) = s;
        v1(end+1) = s.V;
        soc1(end+1) = s.SOC_n;
        if s.V >= VMax
            break
        end
    end
    
    for k = 1:20
        s = updateState(p, sys_n, sys_p, s, -1 * p.OneC);
        s1(end+1) = s;
        v1(end+1) = s.V;
        soc1(end+1) = s.SOC_n;
        if s.V >= VMax
            break
        end
    end
end


for k = 1:restPeriod
    s = updateState(p, sys_n, sys_p, s, 0 * p.OneC);
    s1(end+1) = s;
    v1(end+1) = s.V;
    soc1(end+1) = s.SOC_n;
end

for ChRate = [0.36, 0.18, 0.1]
    while s.V < VMax
        s = updateState(p, sys_n, sys_p, s, -ChRate * p.OneC);
        s1(end+1) = s;
        v1(end+1) = s.V;
        soc1(end+1) = s.SOC_n;
    end
    
    if ChRate == 0.1
        break
    end
    
    for k = 1:restPeriod
        s = updateState(p, sys_n, sys_p, s, 0 * p.OneC);
        s1(end+1) = s;
        v1(end+1) = s.V;
        soc1(end+1) = s.SOC_n;
    end
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