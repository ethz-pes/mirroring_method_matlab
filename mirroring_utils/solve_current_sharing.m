function [I_mat, V_mat] = solve_current_sharing(n_total, f_vec, R, L, group)
% Solve a current sharing problem between different conductors.
%
%    Solve a current sharing problem from the resistance and inductance matrices:
%        - between different conductor groups (parallel connected strands)
%        - conductor groups are defined with the indices of the conductors
%        - the total current of the different conductor groups is specified
%        - the current sharing between the conductor inside a group is computed
%        - the voltage drop for the different conductor inside a group is computed
%
%    The problem is solved by:
%        - equalizing the voltage drop between all the conductors composing a group
%        - imposing that the sum of the currents inside a conductor group equal the given value
%
%    Parameters:
%        n_total (integer): number of conductors
%        f_vec (vector): vector with the frequencies
%        R (matrix): resistance matrix between the conductors
%        L (matrix): inductance matrix between the conductors
%        group (cell): definition of the different conductor groups (indices and current)
%
%    Returns:
%        I_mat (matrix): current sharing for the different conductors
%        V_mat (matrix): voltage drop for the different conductors
%
%    (c) 2016-2025, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% indices for the current and voltage vectors
n_group = length(group);
idx_current = 1:n_total;

% matrix for the voltage assignation
mat_voltage = zeros(n_total, n_group);
for i=1:length(group)
    mat_voltage(group{i}.idx, i) = 1;
end

% matrix for the current summation
mat_current = zeros(n_group, n_total);
for i=1:length(group)
    mat_current(i, group{i}.idx) = 1;
end

% current summation constaint vector
vec_current = zeros(n_group, 1);
for i=1:length(group)
    vec_current(i, 1) = group{i}.I;
end

% solve the current sharing problem
I_mat = zeros(n_total, length(f_vec));
V_mat = zeros(n_total, length(f_vec));
for i=1:length(f_vec)
    % get the impedance matrix
    s = 2.*pi.*f_vec(i).*1i;
    mat_impedance = R+s.*L;

    % assemble matrix
    mat = [...
        mat_impedance mat_voltage;...
        mat_current zeros(n_group, n_group);...
        ];

    % assemble vector
    vec = [...
        zeros(n_total, 1);...
        vec_current;...
        ];

    % solve
    sol = mat\vec;

    % extract
    I_vec = sol(idx_current);
    V_vec = mat_impedance*I_vec;

    % assign
    I_mat(:, i) = I_vec;
    V_mat(:, i) = V_vec;
end

end