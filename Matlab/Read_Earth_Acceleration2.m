% Read data


close all
clear all
clc
tic
[file_name,dr ] = uigetfile({'*rotated*'});

load([dr file_name])
t = accelerations_LL(1,:);
ax_earth = accelerations_LL(2,:);
ay_earth = accelerations_LL(3,:);
az_earth = accelerations_LL(4,:);
%}
%
%close all
ay_earth = -ay_earth;

figure
hold on;
q = plot (t, [ax_earth(1:length(t));ay_earth(1:length(t));az_earth(1:length(t))]);
set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)'),'interpreter','latex','fontsize',20)
grid on;set(gca,'fontsize',16) ;box on


fmax = 0.5/(t(10)-t(9));
g = 9.81;

f_s = linspace(-fmax,fmax,length(fft(ax_earth)));
fmax = 0.5/(t(10)-t(9));
%[c d] = cheby2(5,100,[0.02]/fmax,'high');butter(2,0.185/fmax,'high');
%[h ts] = impz(c,d,length(t));figure();hold on;plot(f_s,abs(fftshift(fft(h))));xlim([0,0.5])


% calculate velocities and remove drifts
%close all

%{


ax_earth = filtfilt(a,ax_earth);
ay_earth = filtfilt(a,ay_earth);
az_earth = filtfilt(a,az_earth);
%}


%{
ax_earth = ax_earth-ax_earth(1);
ay_earth = ay_earth-ay_earth(1);
az_earth = az_earth-az_earth(1);
%}
t = t-t(1);
acc_magnitude = sqrt(ax_earth.^2+ay_earth.^2+az_earth.^2)/g;
%acc_magnitude = sqrt(ax_new.^2+ay_new.^2+az_new.^2)/g;
%isnon_moving = acc_magnitude<=0.022;
figure()
hold on
plot(t,acc_magnitude)
%threshold = 0.05
isnon_moving_x = abs(ax_earth)<=threshold;
isnon_moving_y = abs(ay_earth)<=threshold;
isnon_moving_z = abs(az_earth)<=threshold;
is_Max_acc_x_moving = zeros(1,length(ax_earth));
is_Max_acc_y_moving = zeros(1,length(ay_earth));
is_Max_acc_z_moving = zeros(1,length(az_earth));

is_Max_acc_x_moving(peaks_x_idxs)=1;
is_Max_acc_y_moving(peaks_y_idxs)=1;
is_Max_acc_z_moving(peaks_z_idxs)=1;
%is_Max_acc_z_moving([2761 2870 3267]) = 0;
figure()
hold on
%q = plot(t,[ax_earth;ay_earth;az_earth]);
%set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)'),'interpreter','latex','fontsize',20)
q = plot(t,[ax_earth;ay_earth;az_earth;acc_magnitude*g],'LineWidth',2);
set(legend(q,'$a_x$ (Earth)', '$a_y$ (Earth)', '$a_z$ (Earth)','$|a|$'),'interpreter','latex','fontsize',20)
grid on;set(gca,'fontsize',16) ;box on
xlabel('Time, $t(s)$','interpreter','latex','fontsize',20);

%% Fix the velocity drift
clc
close all
vx = cumtrapz(t,ax_earth);
vy = cumtrapz(t,ay_earth);
vz = cumtrapz(t,az_earth);

figure()
hold on
plot(t,vx)
ylabel('Velocity, $v_x$ (Earth)','interpreter','latex','fontsize',10)
xlabel('Time t(s)','interpreter','latex','fontsize',10)
box on;grid on;

figure()
hold on
plot(t,vy)
ylabel('Velocity, $v_y$ (Earth)','interpreter','latex','fontsize',10)
xlabel('Time t(s)','interpreter','latex','fontsize',10)
box on;grid on;

figure()
hold on
plot(t,vz)
ylabel('Velocity, $v_z$ (Earth)','interpreter','latex','fontsize',10)
xlabel('Time t(s)','interpreter','latex','fontsize',10)
box on;grid on;

vel = [vx;vy;vz]';
velDrift = zeros(size(vel));
velocity_drifts = zeros(3,length(ax_earth));
vel(find(is_Max_acc_x_moving==1),1) = 0;
vel(find(is_Max_acc_y_moving==1),2) = 0;
vel(find(is_Max_acc_z_moving==1),3) = 0;
%
figure()
hold on
plot(vel)
%{
figure()
hold on
plot(vel(:,2))

figure()
hold on
plot(vel(:,3))
%}
moving_x_start = [1;find([0;diff(is_Max_acc_x_moving')]==-1)];
moving_x_end = [find([0;diff(is_Max_acc_x_moving')]==1);length(is_Max_acc_x_moving)];

moving_y_start = [1;find([0;diff(is_Max_acc_y_moving')]==-1)];
moving_y_end = [find([0;diff(is_Max_acc_y_moving')]==1);length(is_Max_acc_y_moving)];

moving_z_start = [1;find([0;diff(is_Max_acc_z_moving')]==-1)];
moving_z_end = [find([0;diff(is_Max_acc_z_moving')]==1);length(is_Max_acc_z_moving)];
%%%%%%%% Part a is done for the pendulum drift x
for i = 1:length(moving_x_end)
%    ['Hiiiii ', num2str(i)];
%     vel(moving_start(i),1)
%     vel(moving_start(i),2)
%     vel(moving_start(i),3)
    vel(moving_x_start(i):moving_x_end(i)-1,1) = vel(moving_x_start(i):moving_x_end(i)-1,1)-vel(moving_x_start(i),1);%detrend(vel(moving_start(i):moving_end(i),1));
%    vel(moving_x_start(i):moving_end(i)-1,2) = vel(moving_x_start(i):moving_end(i)-1,2)-vel(moving_x_start(i),2);%detrend(vel(moving_start(i):moving_end(i),2));
%    vel(moving_x_start(i):moving_end(i)-1,3) = vel(moving_x_start(i):moving_end(i)-1,3)-vel(moving_x_start(i),3);%detrend(vel(moving_start(i):moving_end(i),3));
end
%%%%%%%% Part a is done for the pendulum drift y
for i = 1:length(moving_y_end)
%    ['Hiiiii ', num2str(i)];
%     vel(moving_start(i),1)
%     vel(moving_start(i),2)
%     vel(moving_start(i),3)
    vel(moving_y_start(i):moving_y_end(i)-1,2) = vel(moving_y_start(i):moving_y_end(i)-1,2)-vel(moving_y_start(i),2);%detrend(vel(moving_start(i):moving_end(i),1));
%    vel(moving_x_start(i):moving_end(i)-1,2) = vel(moving_x_start(i):moving_end(i)-1,2)-vel(moving_x_start(i),2);%detrend(vel(moving_start(i):moving_end(i),2));
%    vel(moving_x_start(i):moving_end(i)-1,3) = vel(moving_x_start(i):moving_end(i)-1,3)-vel(moving_x_start(i),3);%detrend(vel(moving_start(i):moving_end(i),3));
end
%%%%%%%% Part a is done for the pendulum drift z
for i = 1:length(moving_z_end)
%    ['Hiiiii ', num2str(i)];
%     vel(moving_start(i),1)
%     vel(moving_start(i),2)
%     vel(moving_start(i),3)
    vel(moving_z_start(i):moving_z_end(i)-1,3) = vel(moving_z_start(i):moving_z_end(i)-1,3)-vel(moving_z_start(i),3);%detrend(vel(moving_start(i):moving_end(i),1));
%    vel(moving_x_start(i):moving_end(i)-1,2) = vel(moving_x_start(i):moving_end(i)-1,2)-vel(moving_x_start(i),2);%detrend(vel(moving_start(i):moving_end(i),2));
%    vel(moving_x_start(i):moving_end(i)-1,3) = vel(moving_x_start(i):moving_end(i)-1,3)-vel(moving_x_start(i),3);%detrend(vel(moving_start(i):moving_end(i),3));
end
%
%moving_start(end-1) = [];
figure(500)
hold on
plot(vel)
%}
%
%%%%% Part b for vx
for i = 1:length(moving_x_end)
    driftRate = vel(moving_x_end(i)-1, 1) / (t(moving_x_end(i)-1) - t((moving_x_start(i))));
    % driftRate
    enum = moving_x_start(i):moving_x_end(i)-1;%1:(moving_end(i)-1 - (moving_start(i) ));
    %enum = enum(i);
    %enum = enum+1;
    %drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)].*(t(enum)');
    drift = (t(enum')-t(enum(1)))*driftRate;% ; (t(enum')-t(enum(1)))*driftRate(2); (t(enum')-t(enum(1)))*driftRate(3)]';
    velDrift(enum, 1) = drift;

end
%%%%% Part b for vy
for i = 1:length(moving_y_end)
    driftRate = vel(moving_y_end(i)-1, 2) / (t(moving_y_end(i)) - t((moving_y_start(i))));
    % driftRate
    enum = moving_y_start(i):moving_y_end(i)-1;%1:(moving_end(i)-1 - (moving_start(i) ));
    %enum = enum(i);
    %enum = enum+1;
    %drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)].*(t(enum)');
    drift = (t(enum')-t(enum(1)))*driftRate ; %(t(enum')-t(enum(1)))*driftRate(2); (t(enum')-t(enum(1)))*driftRate(3)]';
    velDrift(enum, 2) = drift;

end
%%%%% Part b for vz
for i = 1:length(moving_z_end)-1
    driftRate = vel(moving_z_end(i)-1, 3) / (t(moving_z_end(i)-1) - t((moving_z_start(i))));
    % driftRate
    enum = moving_z_start(i):moving_z_end(i)-1;%1:(moving_end(i)-1 - (moving_start(i) ));
    %enum = enum(i);
    %enum = enum+1;
    %drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)].*(t(enum)');
    drift = (t(enum')-t(enum(1)))*driftRate ;%; (t(enum')-t(enum(1)))*driftRate(2); (t(enum')-t(enum(1)))*driftRate(3)]';
    velDrift(enum, 3) = drift;

end
%{
figure(500)
   hold on
   plot(velDrift)
moving_start;
moving_end;
%}
vel = vel - velDrift;



figure()
hold on
plot(t,vx);
plot(t,vel(:,1));
legend({ '$v_x$ before','$v_x$ after '},'interpreter','latex','fontsize',20,'location','best')
ylabel('Velocity, $v_x$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
set(gca,'fontsize',20)
grid on;
box on

figure()
hold on
plot(t,vy);
plot(t,vel(:,2));
legend({ '$v_y$ before','$v_y$ after '},'interpreter','latex','fontsize',20,'location','best')
ylabel('Velocity, $v_y$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)

set(gca,'fontsize',20)
grid on;
box on

figure()
hold on
plot(t,vz);
plot(t,vel(:,3));
legend({ '$v_z$ before','$v_z$ after '},'interpreter','latex','fontsize',20,'location','best')
ylabel('Velocity, $v_z$ (Earth)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)

set(gca,'fontsize',20)
grid on;
box on
vx = vel(:,1);
vy = vel(:,2);
vz = vel(:,3);
%
figure()
hold on
plot(vel(:,1));
plot(vel(:,2));
plot(vel(:,3));
%}
%
figure()
hold on
plot(vx)
plot( smoothdata(vx,'loess') )

figure()
hold on
plot(vz)
plot( smoothdata(vz,'loess') )

vx = smoothdata(vx,'loess');
vz = smoothdata(vz,'loess');
%{
interp_factor = 5;
vx = interp1(t,vx,(0:length(vx)*interp_factor-1)*1e-3);
vz = interp1(t,vz,(0:length(vz)*interp_factor-1)*1e-3);
vx = vx(1:interp_factor:end);
vz = vz(1:interp_factor:end);
%}
%%

%vy = vy';
close all
vel(:,1) = vx;
vel(:,2) = vy;
vel(:,3) = vz;
[peaks_x ,peaks_x_idxs] = findpeaks(abs(vx));
%peaks_x_idxs = sort([peaks_x_idxs-1 peaks_x_idxs peaks_x_idxs+1]);
isnon_moving_x(:) = 0;
isnon_moving_x(peaks_x_idxs) = 1;
%isnon_moving_x(1) = [];
%isnon_moving_x(2) = 1;

[peaks_y ,peaks_y_idxs] = findpeaks(abs(vy));
%peaks_y_idxs = sort([peaks_y_idxs-1 peaks_y_idxs peaks_y_idxs+1]);
isnon_moving_y(:) = 0;
isnon_moving_y(peaks_y_idxs) = 1;


[peaks_z ,peaks_z_idxs] = findpeaks(abs(vz));find(abs(vz)<=0.05);
%peaks_z_idxs = sort([peaks_z_idxs-1 peaks_z_idxs peaks_z_idxs+1]);
isnon_moving_z(:) = 0;
isnon_moving_z(peaks_z_idxs) = 1;

is_Max_acc_x_moving = zeros(1,length(ax_earth));
is_Max_acc_y_moving = zeros(1,length(ay_earth));
is_Max_acc_z_moving = zeros(1,length(az_earth));

is_Max_acc_x_moving(peaks_x_idxs)=1;
is_Max_acc_y_moving(peaks_y_idxs)=1;
is_Max_acc_z_moving(peaks_z_idxs)=1;


figure()
hold on
title('Velocities after detrending','Interpreter','latex','FontSize',15)
plot(vel(:,1));
plot(vel(:,2));
plot(vel(:,3));
%%close all
x = cumtrapz(t,vx);
y = cumtrapz(t,vy);
z = cumtrapz(t,vz);
pos = [x , y , z];

figure()
title('Displacements before detrending','Interpreter','latex','FontSize',15)
hold on
plot(x)
plot(y)
plot(z)
%%
%
clc
%pos(find(isnon_moving==1),:) = 0;
moving_x_start = find([0;diff(isnon_moving_x')]==-1);
moving_x_end = find([0;diff(isnon_moving_x')]==1);

moving_y_start = find([0;diff(isnon_moving_y')]==-1);
moving_y_end = find([0;diff(isnon_moving_y')]==1);

moving_z_start = find([diff(isnon_moving_z')]==-1);
moving_z_end = find([0;diff(isnon_moving_z')]==1);

%%%%% these three lines are added when necessary make the first value 2 or 1
moving_x_start = [1;moving_x_start];
moving_y_start = [2;moving_y_start];
moving_z_start = [2;moving_z_start];

pos(find(isnon_moving_x==1),1) = 0;
pos(find(isnon_moving_y==1),2) = 0;
pos(find(isnon_moving_z==1),3) = 0;
posDrift = zeros(size(pos));
pos_drifts = zeros(3,length(ax_earth));

%
for i = 1:length(moving_x_end)
    %pos(moving_x_start(i):moving_x_end(i)-1,1)
    pos(moving_x_start(i):moving_x_end(i)-1,1) = pos(moving_x_start(i):moving_x_end(i)-1,1)-pos(moving_x_start(i),1);%detrend(vel(moving_start(i):moving_end(i),1));
    %pos(moving_x_start(i):moving_x_end(i)-1,1)
end
pos(find(isnon_moving_x==1),1) = 0;

for i = 1:length(moving_y_end)
    pos(moving_y_start(i):moving_y_end(i)-1,2) = pos(moving_y_start(i):moving_y_end(i)-1,2)-pos(moving_y_start(i),2);%detrend(vel(moving_start(i):moving_end(i),2));
end


for i = 1:length(moving_z_end)
    pos(moving_z_start(i)+1:moving_z_end(i)-1,3) = pos(moving_z_start(i)+1:moving_z_end(i)-1,3)-pos(moving_z_start(i)+1,3);%detrend(vel(moving_start(i):moving_end(i),3));
end
%
figure()
hold on
plot(pos)
plot((find(isnon_moving_z==1)),pos(find(isnon_moving_z==1),3),'^r','MarkerSize',3)
figure()
hold on
plot([ax_earth ;ay_earth ;az_earth]')
plot((find(isnon_moving_z==1)),pos(find(isnon_moving_z==1),3),'^r','MarkerSize',3)

figure()
title('Velocities and position drift removal locations','Interpreter','latex','FontSize',15)
hold on
plot(vx)
plot(vy)
plot(vz)
plot((find(isnon_moving_x==1)),vel(find(isnon_moving_x==1),1),'^r','MarkerSize',3)
plot((find(isnon_moving_z==1)),vel(find(isnon_moving_z==1),3),'ok','MarkerSize',3)
%%
%
%
for i = 1:length(moving_x_end)
    driftRate = pos(moving_x_end(i)-1, 1) / (t(moving_x_end(i)-1) - t((moving_x_start(i))));
    % driftRate
    enum = moving_x_start(i):moving_x_end(i)-1;%1:(moving_end(i)-1 - (moving_start(i) ));
    %enum = enum(i);
    %enum = enum+1;
    %drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)].*(t(enum)');
    drift = (t(enum')-t(enum(1)))*driftRate ; %(t(enum')-t(enum(1)))*driftRate(2); (t(enum')-t(enum(1)))*driftRate(3)]';
    posDrift(enum, 1) = drift;
end
for i = 1:length(moving_y_end)
    driftRate = pos(moving_y_end(i)-1, 2) / (t(moving_y_end(i)) - t((moving_y_start(i))));
    % driftRate
    enum = moving_y_start(i):moving_y_end(i);%1:(moving_end(i)-1 - (moving_start(i) ));
    %enum = enum(i);
    %enum = enum+1;
    %drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)].*(t(enum)');
    drift = (t(enum')-t(enum(1)))*driftRate ; %(t(enum')-t(enum(1)))*driftRate(2); (t(enum')-t(enum(1)))*driftRate(3)]';
    posDrift(enum, 2) = drift;
end



for i = 1:length(moving_z_end)

    driftRate = pos(moving_z_end(i)-1, 3) / (t(moving_z_end(i)) - t((moving_z_start(i))));
    % driftRate
    enum = moving_z_start(i):moving_z_end(i);%1:(moving_end(i)-1 - (moving_start(i) ));
    %enum = enum(i);
    %enum = enum+1;
    %drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)].*(t(enum)');
    drift = (t(enum')-t(enum(1)))*driftRate ; %(t(enum')-t(enum(1)))*driftRate(2); (t(enum')-t(enum(1)))*driftRate(3)]';
    posDrift(enum, 3) = drift;
end
%

pos = pos-posDrift;
%%%%% this line is added when necessary when the number of consecutive
%%%%% indices for zero values are less than three
pos(find(isnon_moving_x==1),1) = 0;
pos(find(isnon_moving_y==1),2) = 0;
pos(find(isnon_moving_z==1),3) = 0;

figure()
hold on
plot(x);
plot(pos(:,1));
legend({ '$x$ before','$x$ after '},'interpreter','latex','fontsize',20,'location','best')
ylabel('$x$ (m)(Earth)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)

set(gca,'fontsize',20)
grid on;
box on



figure()
hold on
plot(y);
plot(pos(:,2));
legend({ '$y$ before','$y$ after '},'interpreter','latex','fontsize',20,'location','best')
ylabel('$y$ (m)(Earth)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)

set(gca,'fontsize',20)
grid on;
box on


figure()
hold on
plot(z);
plot(pos(:,3));
legend({ '$z$ before','$z$ after '},'interpreter','latex','fontsize',20,'location','best')
ylabel('$z$ (m)(Earth)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)

set(gca,'fontsize',20)
grid on;
box on
x = pos(:,1);
y = pos(:,2);
z = pos(:,3);
%%
figure()
hold on
title('Displacements in $x$ directions before and after smoothing','interpreter','latex','fontsize',20)
plot(x,'-b')
plot(smoothdata(x,'loess'),'-r')

figure()
hold on
title('Displacements in $z$ directions before and after smoothing','interpreter','latex','fontsize',20)
plot(z,'-b')
plot(smoothdata(z,'loess'),'-r')

x = smoothdata(x,'loess');
z = smoothdata(z,'loess');
figure()
hold on
title('Displacements in $x$ and $z$ directions','interpreter','latex','fontsize',20)
plot(x,'-b','LineWidth',3)
plot(z,'-r','LineWidth',3)
box on;
grid on
%%
start_idx = 1;251;
end_idx = length(x);3505;
xlim([start_idx end_idx])
pos = [x , y , z];
%save('C:\Users\ahmedag\OneDrive - Universitetet i Agder\CSI-Data Proceseeing\Paper 5\Sensor Data\Pendulum2_pos','t','x','y','z','pos','peaks_idxs','zero_acc_idxs')
%}
%{
  save([dr 'vel_pos.mat'],'t','ax_earth','ay_earth','az_earth','vel','pos','start_idx','end_idx')
%}
