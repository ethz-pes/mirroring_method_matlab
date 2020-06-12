function plot_field_space(name, obj, I, n_x, n_y, margin)
% Plot the magnetic field in the domain.
%
%    Parameters:
%        name (str): name of the figure
%        obj (MirroringMethod): instance of the mirroring solver
%        I (vector): vector with the current excitation of the conductors
%        n_x (integer): number of points to evaluate in the x direction
%        n_y (integer): number of points to evaluate in the y direction
%        margin (float): margin from the boundaries to evaluate the field
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% get value
bc = obj.get_bc();
conductor = obj.get_conductor();

% get position
x = linspace(bc.x_min+margin, bc.x_max-margin, n_x);
y = linspace(bc.y_min+margin, bc.y_max-margin, n_y);
[x_mat, y_mat] = meshgrid(x, y);
x_all = x_mat(:).';
y_all = y_mat(:).';

% get field
H = obj.get_H_norm_position(x_all, y_all, I);
[H_x, H_y] = obj.get_H_xy_position(x_all, y_all, I);
H_mat = reshape(H, length(y), length(x));
H_x = reshape(H_x, length(y), length(x));
H_y = reshape(H_y, length(y), length(x));

% get energy
E = obj.get_E(I);

% init figure
figure('name', name);

% plot field and direction
contourf(1e3.*x_mat, 1e3.*y_mat, 1e-3.*H_mat, 200, 'edgecolor','none');
hold('on')
quiver(1e3.*x_mat(:), 1e3.*y_mat(:), 1e-3.*H_x(:), 1e-3.*H_y(:), 'AutoScaleFactor', 0.5)

% plot geometry and axis
plot_geom(bc, conductor);
c = colorbar();
set(c.Label, 'String', 'H [A/mm]')
title(sprintf('Magnetic Field  / E = %.2f uJ', 1e6.*E))

end
