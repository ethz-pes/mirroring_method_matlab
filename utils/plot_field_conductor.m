function plot_field_conductor(obj, I_vec)

% get value
bc = obj.get_bc();
conductor = obj.get_conductor();

% get conductor field
H = obj.get_H_norm_conductor(I_vec);
[H_x, H_y] = obj.get_H_xy_conductor(I_vec);

% get energy
E = obj.get_E(I_vec);

% init
figure();

% plot data
scatter(1e3.*conductor.x, 1e3.*conductor.y, 30, 1e-3.*H.', 'filled')
hold('on')
quiver(1e3.*conductor.x(:), 1e3.*conductor.y(:), 1e-3.*H_x(:), 1e-3.*H_y(:), 'AutoScaleFactor', 0.5)

% plot geometry
plot_geom(bc, conductor);
c = colorbar();
set(c.Label, 'String', 'H [A/mm]')
title(sprintf('Magnetic Field  / E = %.2f uJ', 1e6.*E))

end
