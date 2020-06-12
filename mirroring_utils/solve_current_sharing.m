function [I_group, V_group] = solve_current_sharing(f_vec, L, group)
% Solve a current sharing problem between different conductors.
%
%    Solve a current sharing problem from the inductance matrix:
%        - between different conductor groups
%        - conductor groups are defined with the indices of the conductors 
%        - the resistance of the conductors composing a group is specified 
%        - the total current of the different conductor groups is specified
%        - the current sharing between the conductor inside a group is computed
%        - the voltage drop for the different conductor inside a group is computed
%
%    The problem is solved by:
%        - equalizing the voltage drop between all the conductors composing a group
%        - imposing that the sum of the currents inside a conductor group equal the given value 
%
%    Parameters:
%        f_vec (vector): frequency vector
%        L (matrix): inductance matrix between the conductors
%        group (cell): definition of the different conductor groups (indices, resistance, current)
%
%    Returns:
%        I_group (cell): current sharing for the different conductor groups
%        V_group (cell): voltage drop for the different conductor groups
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% indices for the current and voltage vectors
n_current = length(L);
n_voltage = length(group);
idx_current = 1:n_current;
idx_voltage = n_current+(1:n_voltage);

% assign resistance matrix
R = zeros(size(L));
for i=1:length(group)
    ind = sub2ind(size(L) ,group{i}.idx, group{i}.idx);
    R(ind) = group{i}.R;
end

% matrix for the voltage assignation
mat_voltage = zeros(n_current, n_voltage);
for i=1:length(group)
    mat_voltage(group{i}.idx, i) = 1;
end

% matrix for the current summation
mat_current = zeros(n_voltage, n_current);
for i=1:length(group)
    mat_current(i, group{i}.idx) = 1;
end

% current summation constaint vector
vec_current = zeros(n_voltage, 1);
for i=1:length(group)
    vec_current(i, 1) = group{i}.I;
end

% solve the current sharing problem
I_mat = zeros(n_current, length(f_vec));
V_mat = zeros(n_voltage, length(f_vec));
for i=1:length(f_vec)
    % get the impedance matrix
    s = 2.*pi.*f_vec(i).*1i;
    mat_impedance = R+s.*L;
    
    % assemble matrix
    mat = [...
        mat_impedance mat_voltage;...
        mat_current zeros(n_voltage, n_voltage);...
        ];
    
    % assemble vector
    vec = [...
        zeros(n_current, 1);...
        vec_current;...
        ];
    
    % solve
    sol = mat\vec;
    
    % assign
    I_mat(:,i) = sol(idx_current);
    V_mat(:,i) = sol(idx_voltage);
end

% assign currents
for i=1:length(group)
    I_group{i} = I_mat(group{i}.idx, :);
    V_group{i} = V_mat(i, :);
end

end