% Inputs: 
% V - voltage curve produced by policy
% b - normalization constant
% n - number of cycles that policy is run
%
% Outputs:
% Q - capacity

function Q = degradation(V, b, n)

Q = zeros(1,n);

for k = 1:n
    Q(k) = 100 - (trapz(exp(V)) / b) * k^0.5;
end

end

