function plot_current(f_vec, I_mat, V_vec)

figure()

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