function test_transformer()
% Test the mirroring method for a transformer (winding window).
%
%    The conductors are defined (pimary and secondary).
%    The field patterns and the inductance are computed.
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all');
addpath('mirroring_method')
addpath('mirroring_utils')

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
bc.y_min = -10e-3;
bc.y_max = +10e-3;

% LV conductors
y_lv = linspace(-7e-3, +7e-3, 4);
x_lv = -2e-3.*ones(1,4);
d_c_lv = 4e-3.*ones(1,4);

% HV conductors
y_hv = linspace(-8e-3, +8e-3, 8);
x_hv = 2e-3.*ones(1,8);
d_c_hv = 2e-3.*ones(1,8);

% assign conductors
conductor.x = [x_lv x_hv];
conductor.y = [y_lv y_hv];
conductor.d_c = [d_c_lv d_c_hv];
conductor.n_conductor = 4+8;

%% obj

obj = MirroringMethod(bc, conductor);

%% plot

% current excitation
I_lv = +5.0.*ones(1,4);
I_hv = -2.5.*ones(1,8);
I = [I_lv I_hv].';

% inductance matrix
plot_inductance_matrix('inductance matrix', obj)

% magnetic field in the conductors
plot_field_conductor('conductor field', obj, I);

% magnetic field everywhere
plot_field_space('field distribution', obj, I, 30, 60, 0.5e-3);

end

