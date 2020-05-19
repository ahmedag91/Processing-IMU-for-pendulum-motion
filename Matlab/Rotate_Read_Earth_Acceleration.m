close all
clear 
clc


[file_name,dr ] = uigetfile({'*accel.mat'});

g = 9.81;
load([dr file_name])
t = accelerations_LL(1,:);
ax_earth_old = accelerations_LL(2,:);
ay_earth_old = accelerations_LL(3,:);
az_earth = accelerations_LL(4,:);
%
ax_earth = sqrt(ax_earth_old.^2+ay_earth_old.^2);
ax_earth(find(ax_earth_old<0)) = -1*ax_earth(find(ax_earth_old<0));

figure()
hold on
q = plot(t,[ax_earth;  sqrt(ax_earth_old.^2+ay_earth_old.^2);ax_earth;-ay_earth_old]);
grid on;set(gca,'fontsize',16) ;box on
legend({'$a_x$ after','$|a_x|$ after ', '$a_x$ before','$a_y$ before'},'interpreter','latex','fontsize',20,'location','best')


figure()
hold on
q = plot(t,[ax_earth; ax_earth_old;ay_earth_old]);
grid on;set(gca,'fontsize',16) ;box on
legend({'$a_x$ after','$a_x$ before','$a_y$ before'},'interpreter','latex','fontsize',20,'location','best')

figure
hold on
plot(t,[ax_earth;smoothdata(ax_earth,'loess')])
ax_earth = smoothdata(ax_earth,'loess');
%

figure()
hold on
plot(t,[ax_earth;az_earth]);
ax_earth = interp1(t,ax_earth,(0:length(t)*10-1)*1e-3);
ax_earth = ax_earth(1:10:end);
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);
grid on;set(gca,'fontsize',16) ;box on

%%
close all
clc
g = 9.81;

ay_earth = zeros(1,length(ax_earth));

a_total = sqrt(ax_earth.^2+az_earth.^2)/g;
[peaks_x ,peaks_x_idxs] = findpeaks(abs(ax_earth/g));
%peaks_x_idxs = sort([peaks_x_idxs-1 peaks_x_idxs peaks_x_idxs+1]);
plot(peaks_x_idxs,a_total(peaks_x_idxs)/g,'ok','MarkerSize',10)

[peaks_x ,peaks_y_idxs] = findpeaks(abs(ay_earth/g));
%peaks_y_idxs = sort([peaks_y_idxs-1 peaks_y_idxs peaks_y_idxs+1]);
plot(peaks_y_idxs,a_total(peaks_y_idxs)/g,'ok','MarkerSize',10)

[peaks_x ,peaks_z_idxs] = findpeaks(abs(az_earth/g));
%peaks_z_idxs = sort([peaks_z_idxs-1 peaks_z_idxs peaks_z_idxs+1]);
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
plot(peaks_x_idxs,ax_earth(peaks_x_idxs)/g,'*k','MarkerSize',10)
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
plot(peaks_z_idxs,az_earth(peaks_z_idxs)/g,'*k','MarkerSize',10)

zero_acc_y_idxs = [];
peaks_y_idxs = [];

%%

accelerations_LL = zeros(4,length(t));
accelerations_LL(1,:) = t;
accelerations_LL(2,:) = ax_earth;
accelerations_LL(3,:) = ay_earth;
accelerations_LL(4,:) = az_earth;

save([dr 'rotated_Earth_accel' '.mat'],'start_idx','end_idx','accelerations_LL','t','peaks_x_idxs','peaks_y_idxs','peaks_z_idxs','zero_acc_x_idxs','zero_acc_y_idxs','zero_acc_z_idxs','threshold');
%save([dr file_name '2.mat'],'start_idx','end_idx','accelerations_LL','t','peaks_x_idxs','peaks_y_idxs','peaks_z_idxs','zero_acc_x_idxs','zero_acc_y_idxs','zero_acc_z_idxs','threshold');







