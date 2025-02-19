function test_litz_wire()
% Test the mirroring method with a current sharing problem between litz wires.
%
%    Two parallel litz wires are defined (with seven strands).
%    The field patterns and the inductance are computed.
%    The frequency dependent current sharing problem is solved for the litz wires.
%
%    (c) 2016-2025, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all');
addpath('mirroring_method')
addpath('mirroring_utils')

%% param

% boundary condition type
bc.type = 'none';
bc.mu_core = 5;
bc.n_mirror = 5;
bc.d_pole = 1.0;

% boundary condition geometry
bc.z_size = 1.0;
bc.x_min = -10e-3;
bc.x_max = +10e-3;
bc.y_min = -6e-3;
bc.y_max = +6e-3;

% litz conductor
phi = (pi./3).*(0:5);
x_litz = [0.0 (5e-3./2.0).*sin(phi)];
y_litz = [0.0 (5e-3./2.0).*cos(phi)];
d_c_litz = 2e-3.*ones(1, 7);

% assign conductors
conductor.x = [x_litz+5e-3 x_litz-5e-3];
conductor.y = [y_litz y_litz];
conductor.d_c = [d_c_litz d_c_litz];
conductor.n_conductor = 7+7;

% conductor numbers of the two litz wires
n_litz = 7;
n_total = 14;

% conductor indices of the two litz wires
idx_litz_1 = 1:7;
idx_litz_2 = 8:14;

% total current of the two litz wires
I_1 = +1.0;
I_2 = -1.0;

% resistance of the strands
R_litz = 5e-3;

% define the current sharing problem
group{1} = struct('name', 'wire 1', 'idx', idx_litz_1, 'I', I_1);
group{2} = struct('name', 'wire 2', 'idx', idx_litz_2, 'I', I_2);

%% obj

obj = MirroringMethod(bc, conductor);

%% plot DC field patterns

% current excitation (DC sharing, homogeneous sharing)
I_litz_1 = (I_1./n_litz).*ones(1, n_litz);
I_litz_2 = (I_2./n_litz).*ones(1, n_litz);
I = [I_litz_1 I_litz_2].';

% inductance matrix
plot_inductance_matrix('inductance matrix', obj)

% magnetic field in the conductors
plot_field_conductor('conductor field', obj, I);

% magnetic field everywhere
plot_field_space('field distribution', obj, I, 60, 30, 0.5e-3);

%% get the resistance  and inductance matrices

% frequency vector
f_vec = logspace(log10(1e0), log10(100e3), 100);

% get inductance matrix
L = obj.get_L();

% get resistance matrix
R = R_litz.*diag(ones(1, n_total));

%% solve current sharing (untwisted wire)

% solve the current sharing problem
[I_mat, V_mat] = solve_current_sharing(n_total, f_vec, R, L, group);

% plot the results
plot_current_sharing('untwisted wire', f_vec, I_mat, V_mat, group)

%% solve current sharing (fully twisted wire)

% defines the strands permutations for the wires (all the strands)
wgt = (1./n_litz).*ones(1, n_litz);
prm = zeros(n_total, n_litz);
for i=1:n_litz
    prm_1 = circshift(idx_litz_1, i);
    prm_2 = circshift(idx_litz_2, i);
    prm(:, i) = [prm_1 prm_2];
end

% permute the matrices to model the twisted wires
[R_twisted, L_twisted] = solve_twisting(n_total, R, L, wgt, prm);

% solve the current sharing problem
[I_mat, V_mat] = solve_current_sharing(n_total, f_vec, R_twisted, L_twisted, group);

% plot the results
plot_current_sharing('fully twisted wire', f_vec, I_mat, V_mat, group)

%% solve current sharing (partially twisted wire)

% defines the strands permutations for the wires (except the middle strand)
wgt = (1./(n_litz-1)).*ones(1, n_litz-1);
prm = zeros(n_total, n_litz-1);
for i=1:(n_litz-1)
    prm_1 = [idx_litz_1(1) circshift(idx_litz_1(2:end), i)];
    prm_2 = [idx_litz_2(1) circshift(idx_litz_2(2:end), i)];
    prm(:, i) = [prm_1 prm_2];
end

% permute the matrices to model the twisted wires
[R_twisted, L_twisted] = solve_twisting(n_total, R, L, wgt, prm);

% solve the current sharing problem
[I_mat, V_mat] = solve_current_sharing(n_total, f_vec, R_twisted, L_twisted, group);

% plot the results
plot_current_sharing('partially twisted wire', f_vec, I_mat, V_mat, group)

end
