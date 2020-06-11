function plot_geom(bc, conductor)

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
% Plot a conductor
%     - x - x position
%     - y - y position
%     - d_c - diameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if d_c==0
    plot(x, y, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
else
    phi = linspace(0, 2.*pi, 100);
    x_vec = x+(d_c./2).*sin(phi);
    y_vec = y+(d_c./2).*cos(phi);
    plot(x_vec, y_vec, 'Color', 'r', 'LineWidth', 2);
end

end
