function plot_geom(bc, conductor)
% Plot the geometry of the conductors and boundary conditions.
%
%    Parameters:
%        bc (struct): definition of the boundary conditions (type, position, permeability, number of mirror)
%        conductor (struct): definition of the conductors (position, radius, number)
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

hold('on');
plot(1e3.*[bc.x_min bc.x_min], 1e3.*[bc.y_min bc.y_max], 'Color', 'r', 'LineWidth', 2);
plot(1e3.*[bc.x_max bc.x_max], 1e3.*[bc.y_min bc.y_max], 'Color', 'r', 'LineWidth', 2);
plot(1e3.*[bc.x_min bc.x_max], 1e3.*[bc.y_min bc.y_min], 'Color', 'r', 'LineWidth', 2);
plot(1e3.*[bc.x_min bc.x_max], 1e3.*[bc.y_max bc.y_max], 'Color', 'r', 'LineWidth', 2);
for i=1:conductor.n_conductor
    plot_conductor(1e3.*conductor.x(i), 1e3.*conductor.y(i), 1e3.*conductor.d_c(i));
end
axis ('equal')
axis ('tight')
xlabel('x [mm]')
ylabel('y [mm]')

end

function plot_conductor(x, y, d_c)
% Plot a conductor.
%
%    Parameters:
%        x (float): x coordinate of the conductor
%        y (float): y coordinate of the conductor
%        d_c (float): diameter of the conductor

if d_c==0
    plot(x, y, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
else
    phi = linspace(0, 2.*pi, 100);
    x_vec = x+(d_c./2).*sin(phi);
    y_vec = y+(d_c./2).*cos(phi);
    plot(x_vec, y_vec, 'Color', 'r', 'LineWidth', 2);
end

end
