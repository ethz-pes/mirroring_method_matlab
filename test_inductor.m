function test_inductor()
% Test the mirroring method for an gapped inductor core
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close('all');

%% param

% boundary condition type
bc.type = 'xy';
bc.mu_core = 25;
bc.n_mirror = 5;
bc.d_pole = 1.0;

% boundary condition geometry
bc.z_size = 1.0;
bc.x_min = -6e-3;
bc.x_max = +6e-3;
bc.y_min = -8e-3;
bc.y_max = +8e-3;

% conductors
y_cond = [linspace(-6e-3, +6e-3, 6) linspace(-6e-3, +6e-3, 6)];
x_cond = [-2e-3.*ones(1,6) +2e-3.*ones(1,6)];
d_c_cond = 2e-3.*ones(1,12);

% air gap
y_gap = [0e-3 0e-3];
x_gap = [-6.0e-3 +6.0e-3];
d_c_gap = 0e-3.*ones(1,2);

% assign conductors
conductor.x = [x_cond x_gap];
conductor.y = [y_cond y_gap];
conductor.d_c = [d_c_cond d_c_gap];
conductor.n_conductor = 12+2;

%% obj

obj = MirroringMethod(bc, conductor);

%% plot

% current excitation
I_cond = +2.0.*ones(1,12);
I_gap = -12.0.*ones(1,2);
I_vec = [I_cond I_gap].';

% inductance matrix
plot_inductance_matrix(obj)

% magnetic field in the conductors
plot_field_conductor(obj, I_vec);

% magnetic field everywhere
plot_field_space(obj, I_vec, 30, 60, 0.5e-3);

end