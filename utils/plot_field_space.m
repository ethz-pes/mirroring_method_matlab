function plot_field_space(obj, I_vec, n_x, n_y, margin)

% get value
bc = obj.get_bc();
conductor = obj.get_conductor();

% get position
x = linspace(bc.x_min+margin, bc.x_max-margin, n_x);
y = linspace(bc.y_min+margin, bc.y_max-margin, n_y);
[x_mat, y_mat] = meshgrid(x, y);
x_vec = x_mat(:).';
y_vec = y_mat(:).';

% get field
H = obj.get_H_norm_position(x_vec, y_vec, I_vec);
[H_x, H_y] = obj.get_H_xy_position(x_vec, y_vec, I_vec);
H_mat = reshape(H, length(y), length(x));
H_x = reshape(H_x, length(y), length(x));
H_y = reshape(H_y, length(y), length(x));

% get energy
E = obj.get_E(I_vec);

% init
figure();

% plot
contourf(1e3.*x_mat, 1e3.*y_mat, 1e-3.*H_mat, 200, 'edgecolor','none');
hold('on')
quiver(1e3.*x_mat(:), 1e3.*y_mat(:), 1e-3.*H_x(:), 1e-3.*H_y(:), 'AutoScaleFactor', 0.5)

% plot geometry
plot_geom(bc, conductor);
c = colorbar();
set(c.Label, 'String', 'H [A/mm]')
title(sprintf('Magnetic Field  / E = %.2f uJ', 1e6.*E))

end
