function plot_inductance_matrix(name, obj)
% Plot the inductance matrix between the conductors.
%
%    Parameters:
%        name (str): name of the figure
%        obj (MirroringMethod): instance of the mirroring solver
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% get inductance
L = obj.get_L();

% init figure
figure('name', name);

% plot matrix (without NaN entries)
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
