close all
clear
clc
read_and_Preprocess;
%% crop the data and time stamps to your chosen subinterval

start_date = [toStringJSON(time_stamps(1).Year), '-', toStringJSON(time_stamps(1).Month), '-', toStringJSON(time_stamps(1).Day)];

% This start_time is chosen by you in the last figure
start_time = 'T22.02.56.000';
end_date = start_date;

% Interval length in seconds
interval_length = 40;
interval_start = datetime({[ start_date, start_time ]},'Format','yyyy-MM-dd''T''HH.mm.ss.SSS');
[time_stamps, ax_earth, ay_earth, az_earth] = cropData(time_stamps, ax_earth, ay_earth, az_earth, start_date, start_time, interval_length);
t = (0:length(ax_earth)-1)*dt;

figure
hold on;
title('Earth aceelerations before cropping','Fontsize',16,'interpreter','Latex')
q = plot (time_stamps, [ax_earth; ay_earth; az_earth]);
set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)'),'interpreter','latex','fontsize',20)
grid on;set(gca,'fontsize',16) ;box on

%% Compute the drift-free velocities
vx = smoothdata(zuptPendulum(ax_earth', dt)','loess');
vy = 0*vx;
vz = smoothdata(zuptPendulum(az_earth', dt)','loess');
figure
hold on;

title('Velocities after detrending','Fontsize',16,'interpreter','Latex')
q = plot (t, [vx; vz]);
set(legend(q,'$v_x(t)$ (Earth)', '$v_z(t)$ (Earth)'),'interpreter','latex','fontsize',20)
xlabel('Time, $t$~(s)', 'Interpreter', 'latex','FontSize', 20)
ylabel('Velocities~(m/s)', 'Interpreter', 'latex','FontSize', 20)
grid on;set(gca,'fontsize',16) ;box on
%% Compute the drift-free displacements

x = smoothdata(zuptPendulum(vx', dt)','loess');
y = 0*x;
z = smoothdata(zuptPendulum(vz', dt)','loess');
figure
hold on;
title('Velocities after detrending','Fontsize',16,'interpreter','Latex')
q = plot (t, [x; z]);
set(legend(q,'$x(t)$ (Earth)', '$z(t)$ (Earth)'),'interpreter','latex','fontsize',20)
xlabel('Time, $t$~(s)', 'Interpreter', 'latex','FontSize', 20)
ylabel('Displacements~(m)', 'Interpreter', 'latex','FontSize', 20)
grid on;set(gca,'fontsize',16) ;box on
