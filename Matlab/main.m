close all
clear
clc
%% Read The accelerations

[file_name, dr] = uigetfile({'*_LinearAcceleration.csv'});
[time_stamp, ax, ay, az, ~] = read_csv_files(dr,file_name);

% Smooth the accelerations and compare
ax_new = smoothdata(ax,'loess');
ay_new = smoothdata(ay,'loess');
az_new = smoothdata(az,'loess');

figure
hold on; grid on;set(gca,'fontsize',16)
plot(t,ax_new,'Linewidth',2);
plot(t,ax,'Linewidth',1);
ylabel('Acceleration, $a_i$ (m/s$^2$) after filtering','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20)
legend({'$a_x$ after ', '$a_x$ before'},'interpreter','latex','fontsize',20,'location','best')
box on

figure
hold on; grid on;set(gca,'fontsize',16)
plot(t,ay_new,'Linewidth',2);
plot(t,ay,'Linewidth',1);
%ylabel('Acceleration, $a_i$ (g)','interpreter','latex','fontsize',20)
ylabel('Acceleration, $a_i$ (m/s$^2$) after filtering','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20)
legend({'$a_y$ after ', '$a_y$ before'},'interpreter','latex','fontsize',20,'location','best')
box on

figure
hold on; grid on;set(gca,'fontsize',16)
plot(t,az_new,'Linewidth',2);
plot(t,az,'Linewidth',1);
%ylabel('Acceleration, $a_i$ (g)','interpreter','latex','fontsize',20)
ylabel('Acceleration, $a_i$ (m/s$^2$) after filtering','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20)
legend({'$a_z$ after ', '$a_z$ before'},'interpreter','latex','fontsize',20,'location','best')
box on

%
ax = ax_new;
ay = ay_new;
az = az_new;


%% Read the quaternions

[file_name1, dr] = uigetfile({'*_Quaternion.csv'});
[~, w, x, y, z] = read_csv_files(dr,file_name1);


%% Rotate the accelerations

t = ax_earth;
ax_earth = zeros(1,length(t));
ay_earth = zeros(1,length(t));
az_earth = zeros(1,length(t));
det_rot = zeros(1,length(t));
for l = 1:length(t)
    %det_rot(l) = det(quat2rotm([w(l) x(l) y(l) z(l)]));
    acc_earth = quat2rotm([w(l) x(l) y(l) z(l)])'\[ax(l);ay(l);az(l)];
    ax_earth(l) = acc_earth(1);
    ay_earth(l) = acc_earth(2);
    az_earth(l) = acc_earth(3);
end
% Calibrate the data (Optional)
%{
ax_earth = ax_earth - ax_earth(1);
ay_earth = ay_earth - ay_earth(1);
az_earth = az_earth - az_earth(1);
%}

figure
hold on;
title('Earth Aceelerations','Fontsize',16,'interpreter','Latex')
q = plot (t, [ax_earth; ay_earth; az_earth]);
set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)'),'interpreter','latex','fontsize',20)
grid on;set(gca,'fontsize',16) ;box on

%% normalize accelerations

[ax_earth, ay_earth, az_earth] = normAccEarth(ax_earth, ay_earth, az_earth);
figure
hold on;
title('Earth aceelerations after normalization','Fontsize',16,'interpreter','Latex')
q = plot (t, [ax_earth; ay_earth; az_earth]);
set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)'),'interpreter','latex','fontsize',20)
grid on;set(gca,'fontsize',16) ;box on


%% Parsing time_stamp from strings to date time format
