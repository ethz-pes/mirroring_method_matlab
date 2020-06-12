function plot_field_conductor(name, obj, I)
% Plot the magnetic field at the center of the conductors.
%
%    Parameters:
%        name (str): name of the figure
%        obj (MirroringMethod): instance of the mirroring solver
%        I (vector): vector with the current excitation of the conductors
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% get value
bc = obj.get_bc();
conductor = obj.get_conductor();

% get conductor field
H = obj.get_H_norm_conductor(I);
[H_x, H_y] = obj.get_H_xy_conductor(I);

% get energy
E = obj.get_E(I);

% init figure
figure('name', name);

% plot field and direction
scatter(1e3.*conductor.x, 1e3.*conductor.y, 30, 1e-3.*H.', 'filled')
hold('on')
quiver(1e3.*conductor.x(:), 1e3.*conductor.y(:), 1e-3.*H_x(:), 1e-3.*H_y(:), 'AutoScaleFactor', 0.5)

% plot geometry and axis
plot_geom(bc, conductor);
c = colorbar();
set(c.Label, 'String', 'H [A/mm]')
title(sprintf('Magnetic Field  / E = %.2f uJ', 1e6.*E))

end
