function plot_current_sharing(name, f_vec, I_mat, V_mat, group)
% Plot the current sharing between the conductors and the voltage.
%
%    Parameters:
%        name (str): name of the figure
%        f_vec (vector): frequency vector
%        I_group (cell): current sharing for the different conductor groups
%        V_group (cell): voltage drop for the different conductor groups
%
%    (c) 2016-2025, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% init figure
figure('name', name);

% plot current sharing
for i=1:length(group)
    % extract group
    name = group{i}.name;
    idx = group{i}.idx;

    % plot current
    subplot(length(group), 2, (2.*(i-1))+1)
    semilogx(f_vec, abs(I_mat(idx, :)), 'LineWidth', 1)
    grid('on')
    xlabel('f [Hz]')
    ylabel('I [A]')
    title(['Current : ' name])

    % plot voltage
    subplot(length(group), 2, (2.*(i-1))+2)
    loglog(f_vec, abs(V_mat(idx, :)), 'LineWidth', 1)
    grid('on')
    xlabel('f [Hz]')
    ylabel('V [V]')
    title(['Voltage : ' name])
end

end