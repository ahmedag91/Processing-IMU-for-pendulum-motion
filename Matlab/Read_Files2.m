close all
clear all
clc 
[file_name,dr ] = uigetfile({'*_LinearAcceleration.csv'});
[file_name1,dr ] = uigetfile({'*_Quaternion.csv'});
% This code fixes the drift according to the following link https://github.com/xioTechnologies/Gait-Tracking-With-x-IMU/blob/master/Gait%20Tracking%20With%20x-IMU/Script.m


tic

file_name = fullfile(file_name);%% The best 
file_name1 = fullfile(file_name1);%% The best 
fileID = fopen([dr file_name]);
accelerations = textscan(fileID,'%s %s %s %s %s %s','Delimiter',',');
smooth_itr = 200;
fclose('all');
%{
t = interp(cellfun(@str2num, accelerations{3}(2:end))',2);
ax = interp(cellfun(@str2num, accelerations{4}(2:end))',2);
ay = interp(cellfun(@str2num, accelerations{5}(2:end))',2);
az = interp(cellfun(@str2num, accelerations{6}(2:end))',2);
%}
g = 9.8;1;
t = cellfun(@str2num, accelerations{3}(2:end))';
ax = cellfun(@str2num, accelerations{4}(2:end))'*g;
ay = cellfun(@str2num, accelerations{5}(2:end))'*g;
az = cellfun(@str2num, accelerations{6}(2:end))'*g;
az = az-az(1);
%t_temp = t;
t = t-t(1);
dt = 0.01;
t = 0:dt:(length(t)-1)*dt;linspace(0,t(end),length(t));
t(end);
length(t)
length(ax)

%ax = ax - ax(1);
%ay = ay - ay(1);
%az = az - az(1);


fclose('all');
figure()
hold on; grid on;set(gca,'fontsize',16) 
t(end);
length(t)
%q = plot(t,[cumtrapz(t,ax); cumtrapz(t,ay); cumtrapz(t,az)]*9.6);
q = plot(t,[ax;ay;az]);
%ylabel('Acceleration, $a_i$ (g)','interpreter','latex','fontsize',20)
ylabel('Acceleration, $a_i$ (m/s$^2$)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20)
set(legend(q,'$a_x$', '$a_y$', '$a_z$'),'interpreter','latex','fontsize',20,'location','best')
box on
%
fmax = 0.5/(t(10)-t(9));

%


ax_new = smoothdata(ax,'loess');
ay_new = smoothdata(ay,'loess');
az_new = smoothdata(az,'loess');

figure 
hold on; grid on;set(gca,'fontsize',16) 
plot(t,ax_new,'Linewidth',2);
plot(t,ax,'Linewidth',1);
%ylabel('Acceleration, $a_i$ (g)','interpreter','latex','fontsize',20)
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
%}

% Read the quaternions and convert them to Eulers
fileID = fopen([dr file_name1]);
accelerations = textscan(fileID,'%s %s %s %s %s %s %s','Delimiter',',');
fclose(fileID);



t1 = cellfun(@str2num, accelerations{3}(2:end))';
w = cellfun(@str2num, accelerations{4}(2:end))';
x = cellfun(@str2num, accelerations{5}(2:end))';
y = cellfun(@str2num, accelerations{6}(2:end))';
z = cellfun(@str2num, accelerations{7}(2:end))';

roll_angles = zeros(1,length(t1));
pitch_angles = zeros(1,length(t1));
yaw_angles = zeros(1,length(t1));
t1 = t1-t1(1);
dt = 0.01;
t1 = 0:dt:(length(t1)-1)*dt;linspace(0,t(end),length(t));
for n = 1:length(t1)
    angles =  quat2eul([w(n) -x(n) -y(n) -z(n)],'XYZ');
    angles =  quat2eul([w(n) x(n) y(n) z(n)],'XYZ');

    %angles =  quat2eul([w(n) x(n) y(n) z(n)],'ZYX');
    roll_angles(n) = angles(1);
    pitch_angles(n) = angles(2);
    yaw_angles(n) = angles(3);
    %}
end
%{
yaw_angles = yaw_angles-yaw_angles(1);
roll_angles = roll_angles-roll_angles(1);
pitch_angles = pitch_angles-pitch_angles(1);
%}

figure
hold on; grid on;set(gca,'fontsize',16) ;box on

q = plot(t1,[roll_angles;pitch_angles;yaw_angles]*180/pi);
set(legend(q,'Roll ($x$)', 'Pitch ($y$)', 'Yaw ($z$)'),'interpreter','latex','fontsize',20)
xlabel('Time, $t$(s)','Interpreter','Latex','Fontsize', 15);

% Convert to reference xyz axes
%close all

ax_earth = zeros(1,length(t));
ay_earth = zeros(1,length(t));
az_earth = zeros(1,length(t));
det_rot = zeros(1,length(t));
for l = 1:length(t)
    %
    %acc_earth =  ( eul2rotm( [roll_angles(l) pitch_angles(l) yaw_angles(l)],'XYZ' ) )' \ [ax(l);ay(l);az(l)];
    %det_rot(l) = det(eul2rotm( [roll_angles(l) pitch_angles(l) yaw_angles(l)],'ZYX' ));
    %}
    det_rot(l) = det(quat2rotm([w(l) x(l) y(l) z(l)]));
    acc_earth = quat2rotm([w(l) x(l) y(l) z(l)])'\[ax(l);ay(l);az(l)];
    %acc_earth = [ax(l);ay(l);az(l)]'*quat2rotm([w(l) -x(l) -y(l) -z(l)]);

    %acc_earth = quat2rotm([w(l) x(l) y(l) z(l)])\[ax(l);ay(l);az(l)];
    %acc_earth = [ax(l);ay(l);az(l)]'*quat2rotm([w(l) x(l) y(l) z(l)])'; 
    %{
    acc_earth =  ( eul2rotm( [roll_angles(l) pitch_angles(l) yaw_angles(l)],'XYZ') )' \ [ax(l);ay(l);az(l)];
    det_rot(l) = det(eul2rotm( [roll_angles(l) pitch_angles(l) yaw_angles(l)]));
    %}
    ax_earth(l) = acc_earth(1);
    ay_earth(l) = acc_earth(2);
    az_earth(l) = acc_earth(3);   
end
%{
ax_earth = ax_earth(find(t>=9&t<=17));
ay_earth = ay_earth(find(t>=9&t<=17));
az_earth = az_earth(find(t>=9&t<=17));
t = t(find(t>=9&t<=17));
t = t-t(1);
%}
figure 
hold on;
q = plot (t, [ax_earth(1:length(t));ay_earth(1:length(t));az_earth(1:length(t))]);
set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)'),'interpreter','latex','fontsize',20)
grid on;set(gca,'fontsize',16) ;box on

%
ax_earth = ax_earth - ax_earth(1);
ay_earth = ay_earth - ay_earth(1);
az_earth = az_earth - az_earth(1);
%}
figure()
hold on
%plot(t,sqrt(ax_earth.^2+ay_earth.^2))
plot(t,ax_earth)
ylabel('Acceleration, $a_x$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

figure()
hold on
plot(t,ay_earth)
ylabel('Acceleration, $a_y$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

figure()
hold on
plot(t,az_earth)
ylabel('Acceleration, $a_z$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

%%
figure()
hold on
plot([ax_earth;ay_earth;az_earth]')

%% Choosing appropriate intervals and plotting
%{
%close all


% ax_earth = ax_earth_Copy';
% ay_earth = ay_earth_Copy';
% az_earth = az_earth_Copy';
%az_earth = circshift(az_earth,-25);

t = (0:length(ax_earth)-1)*0.01;
figure();hold on;plot([ax_earth;ay_earth;az_earth]')
ylabel('Acceleration, $a$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Samples','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on
%}
%%
   
%close all
a_total = sqrt(ax.^2+ay.^2);
figure()
hold on
plot(a_total/g)
ylabel('Acceleration, $|a|$','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

%
start_idx = 2268;
end_idx = 6006;length(t);
t = t(start_idx:end_idx);
t = t-t(1);
ax_earth = ax_earth(start_idx:end_idx);
ay_earth = ay_earth(start_idx:end_idx);
az_earth = az_earth(start_idx:end_idx);

figure()
hold on
plot(t,[ax_earth;az_earth])

%{
ax = ax(start_idx:end_idx);
ay = ay(start_idx:end_idx);
az = az(start_idx:end_idx);
ax_new = ax_new(start_idx:end_idx);
ay_new = ay_new(start_idx:end_idx);
az_new = az_new(start_idx:end_idx);
figure 
hold on; grid on;set(gca,'fontsize',16) 
plot(t,ax_new,'Linewidth',2);
plot(t,ax,'Linewidth',1);
%ylabel('Acceleration, $a_i$ (g)','interpreter','latex','fontsize',20)
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
%}

%{
ax_earth = ax_earth-ax_earth(1);
ay_earth = ay_earth-ay_earth(1);
az_earth = az_earth-az_earth(1);
%}
%%
figure()
hold on
plot(xcorr(ax_earth,ay_earth),'LineWidth',3)
plot(xcorr(ax_earth,ay_earth))
%%
a_total = sqrt(ax.^2+ay.^2);
figure()
hold on
%plot(t,sqrt(ax_earth.^2+ay_earth.^2))
plot(ax_earth)
ylabel('Acceleration, $a_x$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

figure()
hold on
plot(ay_earth)
ylabel('Acceleration, $a_y$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

figure()
hold on
plot(az_earth)
ylabel('Acceleration, $a_z$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on


figure()
hold on
plot(a_total/g)
ylabel('Acceleration, $|a|$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on


%%
%close all
figure()
hold on;
[peaks_x ,peaks_x_idxs] = findpeaks(abs(ax_earth/g));
peaks_x_idxs = sort([peaks_x_idxs-1 peaks_x_idxs peaks_x_idxs+1]);
plot(peaks_x_idxs,a_total(peaks_x_idxs)/g,'ok','MarkerSize',10)

[peaks_x ,peaks_y_idxs] = findpeaks(abs(ay_earth/g));
peaks_y_idxs = sort([peaks_y_idxs-1 peaks_y_idxs peaks_y_idxs+1]);
plot(peaks_y_idxs,a_total(peaks_y_idxs)/g,'ok','MarkerSize',10)

[peaks_x ,peaks_z_idxs] = findpeaks(abs(az_earth/g));
peaks_z_idxs = sort([peaks_z_idxs-1 peaks_z_idxs peaks_z_idxs+1]);
plot(peaks_z_idxs,a_total(peaks_z_idxs)/g,'ok','MarkerSize',10)
threshold = 0.01;
zero_acc_x_idxs = find(abs(ax_earth)/g<=threshold);
zero_acc_y_idxs = find(abs(ay_earth)/g<=threshold);
zero_acc_z_idxs = find(abs(az_earth)/g<=threshold);
figure 
hold on
ylabel('Acceleration, $a_x$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on
plot(ax_earth)
plot(zero_acc_x_idxs,ax_earth(zero_acc_x_idxs)/g,'^r','MarkerSize',10)

figure 
hold on
ylabel('Acceleration, $a_y$ (g)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on
plot(ay_earth)
plot(peaks_y_idxs,ay_earth(peaks_y_idxs)/g,'*k','MarkerSize',10)
plot(zero_acc_y_idxs,ay_earth(zero_acc_y_idxs)/g,'^r','MarkerSize',10)

figure 
hold on
ylabel('Acceleration, $a_z$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on
plot(az_earth)
plot(zero_acc_z_idxs,az_earth(zero_acc_z_idxs)/g,'^r','MarkerSize',10)

%%

accelerations_LL = zeros(4,length(t));
accelerations_LL(1,:) = t;
accelerations_LL(2,:) = ax_earth;
accelerations_LL(3,:) = ay_earth;
accelerations_LL(4,:) = az_earth;
 save([dr 'Earth_accel.mat'],'start_idx','end_idx','accelerations_LL','t','peaks_x_idxs','peaks_y_idxs','peaks_z_idxs','zero_acc_x_idxs','zero_acc_y_idxs','zero_acc_z_idxs','threshold');


figure(10);hold on;


%save(['C:\Users\ahmedag\OneDrive - Universitetet i Agder\CSI-Data Proceseeing\Paper 5\Sensor Data\Pendulum1.mat'],'start_idx','end_idx','accelerations_LL','t','peaks_idxs','zero_acc_idxs');
%save(['C:\Users\ahmedag\OneDrive - Universitetet i Agder\CSI-Data Proceseeing\Paper 5\Sensor Data\Pendulum2.mat'],'start_idx','end_idx','accelerations_LL','t','peaks_idxs','zero_acc_idxs');
%save(['C:\Users\ahmedag\OneDrive - Universitetet i Agder\CSI-Data Proceseeing\Paper 5\Sensor Data\LA_pendulum_ball_WO3.mat'],'start_idx','end_idx','accelerations_LL','t','peaks_idxs','zero_acc_idxs');
%}