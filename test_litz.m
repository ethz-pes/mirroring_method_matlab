function test_litz()
% Test the mirroring method for a (non-transposed) litz wire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close('all');

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
x_litz_1 = [0.0 (5e-3./2.0).*sin(phi)]-5e-3;
y_litz_1 = [0.0 (5e-3./2.0).*cos(phi)];
d_c_litz_1 = 2e-3.*ones(1, 7);

% solid conductor
x_litz_2 = [-2e-3 -2e-3 +2e-3 +2e-3]+5e-3;
y_litz_2 = [-2e-3 +2e-3 -2e-3 +2e-3];
d_c_litz_2 = 3e-3.*ones(1, 4);

% assign conductors
conductor.x = [x_litz_1 x_litz_2];
conductor.y = [y_litz_1 y_litz_2];
conductor.d_c = [d_c_litz_1 d_c_litz_2];
conductor.n_conductor = 7+4;

%% obj

obj = MirroringMethod(bc, conductor);

%% plot

% current excitation
I_litz_1 = +(1./7).*ones(1, 7);
I_litz_2 = -(1./4).*ones(1, 4);
I_vec = [I_litz_1 I_litz_2].';

% inductance matrix
plot_inductance_matrix(obj)

% magnetic field in the conductors
plot_field_conductor(obj, I_vec);

% magnetic field everywhere
plot_field_space(obj, I_vec, 60, 30, 0.5e-3);

%% solve current sharing

% frequency vector
f_vec = logspace(log10(100), log10(100e3), 25);

% conductor indices
idx_litz_1 = 1:7;
idx_litz_2 = 8:11;

% litz wire resistance
R_litz_1 = 10e-3;
R_litz_2 = 5e-3;

% total current 
I_1 = +1;
I_2 = -1;

% get inductance
L = obj.get_L();

% solve the current sharing problem
group{1} = struct('idx', idx_litz_1, 'R', R_litz_1, 'I', I_1);
group{2} = struct('idx', idx_litz_2, 'R', R_litz_2, 'I', I_2);
[I_group, V_group] = solve_current_sharing(f_vec, L, group);

% plot
plot_current(f_vec, I_group{1}, V_group{1})
plot_current(f_vec, I_group{2}, V_group{2})

end
