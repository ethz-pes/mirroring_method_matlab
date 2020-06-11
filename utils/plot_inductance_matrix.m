function plot_inductance_matrix(obj)

% get inductance
L = obj.get_L();

% init
figure();

% plot matrix
h = imagesc(1e6.*L);
set(h, 'AlphaData', isfinite(L));

% plot axis
xlabel('conductor [#]')
ylabel('conductor [#]')
set(gca, 'xticklabel',[])
set(gca, 'yticklabel',[])
c = colorbar();
set(c.Label, 'String', 'L [uH]')
title('Inductance Matrix')

end
