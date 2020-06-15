function plot_current_sharing(name, f_vec, I_mat, V_vec)
% Plot the current sharing between the conductors and the voltage.
%
%    Parameters:
%        name (str): name of the figure
%        f_vec (vector): frequency vector
%        I_mat (matrix): current matrix (different conductors, different frequencies)
%        V_vec (vector): voltage vector (different frequencies)
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% init figure
figure('name', name);

% plot current sharing
subplot(2,2,1)
semilogx(f_vec, abs(I_mat))
grid('on')
xlabel('f [Hz]')
ylabel('I [A]')
title('Current Amplitude')
subplot(2,2,2)
semilogx(f_vec, rad2deg(unwrap(angle(I_mat))))
grid('on')
xlabel('f [Hz]')
ylabel('phi [deg]')
title('Current Phase')

% plot induced voltage
subplot(2,2,3)
loglog(f_vec, abs(V_vec))
grid('on')
xlabel('f [Hz]')
ylabel('V [V]')
title('Voltage Amplitude')
subplot(2,2,4)
semilogx(f_vec, rad2deg(unwrap(angle(V_vec))))
grid('on')
xlabel('f [Hz]')
ylabel('phi [deg]')
title('Voltage Phase')

end