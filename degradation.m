% Inputs: 
% V - voltage curve produced by policy
% b - normalization constant
% n - number of cycles that policy is run
%
% Outputs:
% Q - capacity

function Q = degradation(V, b, n)

Q = 100 - (trapz(V) / b) * n^0.5;

end

