function [R_twisted, L_twisted] = solve_twisting(n_total, R, L, wgt, prm)
% Simulate twisted conductors with a permutation matrix.
%
%    Parameters:
%        n_total (integer): number of conductors
%        R (matrix): resistance matrix between the conductors
%        L (matrix): inductance matrix between the conductors
%        wgt (vector): vector with the weights of the permutations
%        prm (matrix): matrix with the indices of the permutations
%
%    Returns:
%        R_twisted (matrix): resistance matrix between the twisted conductors
%        L_twisted (matrix): inductance matrix between the twisted conductors
%
%    (c) 2016-2025, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% initialize
R_twisted = zeros(n_total, n_total);
L_twisted = zeros(n_total, n_total);

% permute the matrices
for i=1:length(wgt)
    % permute the matrices
    idx = prm(:, i);
    R_tmp = R(idx, idx);
    L_tmp = L(idx, idx);

    % add the contributions
    R_twisted = R_twisted+wgt(i).*R_tmp;
    L_twisted = L_twisted+wgt(i).*L_tmp;
end

end