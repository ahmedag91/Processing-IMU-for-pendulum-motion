close all
clear 
clc
dr = 'C:\Users\ahmedag\OneDrive - Universitetet i Agder\CSI-Data Proceseeing\Paper 5\Sensor Data\';
file_name = 'LA_heavy_ball_ch64_3_pos';
file_name = 'LA_heavy_ball_T1_S1_pos'; %%[1 end]
%file_name = 'LA_heavy_ball_T1_S2_pos';
file_name = 'LA_heavy_ball_T1_S22_pos'; %%%% The best[ 7.99s 10s ]
file_name = 'LA_SIMO 6_8_b2b_15swings_s1_pos';

load([dr file_name '_final.mat'])
%%
%{
a_x = diff(v_x)./diff(t);
a_z = diff(v_z)./diff(t);
a_x = interp1(t(1:end-1),a_x,t,'spline');
a_z = interp1(t(1:end-1),a_z,t,'spline');
%}
%%
close all
%a_x = a_x_Copy';
%a_z = a_z_Copy';
%
t_start_idx = min(find(t>=0));1;min(find(t>=1));
t_end_idx = length(t);max(find(t<=20));

ax_earth = ax_earth(t_start_idx:t_end_idx);
az_earth = az_earth(t_start_idx:t_end_idx);

v_x = v_x(t_start_idx:t_end_idx);
v_z = v_z(t_start_idx:t_end_idx);

x = x(t_start_idx:t_end_idx);
z = z(t_start_idx:t_end_idx);
z = z-abs(min(z));
t = t(t_start_idx:t_end_idx);

t = t-t(1);
t_start_idx = 1;
t_end_idx = length(t);
ax_earth = ax_earth(t_start_idx:t_end_idx);
az_earth = az_earth(t_start_idx:t_end_idx);

v_x = v_x(t_start_idx:t_end_idx);
v_z = v_z(t_start_idx:t_end_idx);

x = x(t_start_idx:t_end_idx);
z = z(t_start_idx:t_end_idx);
t = t(t_start_idx:t_end_idx);

%}
a_x= ax_earth;
a_z = az_earth;

%
v_x = v_x';
v_z = v_z';
x = x';
z = z';
v_y = zeros(length(v_x));
y = zeros(length(x));
%}
%%

x = -x;
v_x = -v_x;
a_x = -a_x;
figure()
hold on
subplot(311)
plot(t,[a_x;a_z],'linewidth',2)
ylabel('$a_i$ (m/s$^2$)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$a_x$' ,'$a_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

subplot(312)
plot(t,[v_x;v_z],'linewidth',2)
ylabel('$v_i$ (m/s)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$v_x$' ,'$v_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

subplot(313)
plot(t,[x ; z],'linewidth',2)
ylabel('Displacement (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$x$','$z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

%%
dt = t(10)-t(9);
dt_new = 1e-3;
t_new = (0:length(t)*dt/dt_new-1)*dt_new;

a_x = interp1(t,a_x,t_new,'spline');
a_z = interp1(t,a_z,t_new,'spline');

v_x = interp1(t,v_x,t_new,'spline');
v_y = interp1(t,v_y',t_new,'spline');
v_z = interp1(t,v_z,t_new,'spline');

x = interp1(t,x,t_new,'spline');
y = interp1(t,y,t_new,'spline');
z = interp1(t,z,t_new,'spline');
t = t_new;

%%

figure()
hold on
subplot(311)
plot(t,[a_x;a_z],'linewidth',2)
ylabel('$a_i$ (m/s$^2$)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$a_x$' ,'$a_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

subplot(312)
plot(t,[v_x;v_z],'linewidth',2)
ylabel('$v_i$ (m/s)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$v_x$' ,'$v_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

subplot(313)
plot(t,[x ; z],'linewidth',2)
ylabel('Displacement (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$x$','$z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on
%%
%
clc
close all
L = 1.2;1.04;2.5-1.4;
f_p = 1/2/pi*sqrt(9.81/L);
g = 9.81;
x_max = 0.55;0.35;
z_max = L-L*cos(asin(x_max/L));
%z_max = max(abs(z))/2;

z = L*(1-cos(asin(x/L))); 

x_p = -x_max*sin(2*pi*f_p*t);
z_p = z_max*(sin(4*pi*f_p*t))+z_max;


[peaks_x_IMU peaks_Idxs_x_IMU] = findpeaks(x);
[peaks_x_sim peaks_Idxs_x_sim] = findpeaks(x_p);
gamma_p = 0.01;sum(-log(x(peaks_Idxs_x_IMU(2:end)))./t(peaks_Idxs_x_IMU(2:end)))/length(peaks_Idxs_x_IMU);
[peaks_z_IMU peaks_Idxs_z_IMU] = findpeaks(z);
[peaks_z_sim peaks_Idxs_z_sim] = findpeaks(z_p);

%t_x_diff = t(peaks_Idxs_x_IMU(1))-t(peaks_Idxs_x_sim(1));0;
t_z_diff = t(peaks_Idxs_z_IMU(1))-t(peaks_Idxs_z_sim(1));

% x_p = -x_max*sin(2*pi*f_p*(t-t_x_diff)); %%correct
 z_p = z_max*(sin(4*pi*f_p*(t-t_z_diff)))+z_max; %%correct
theta_t = 2*pi*f_p*t;
x_p = exp(-gamma_p*t).*x_max.*cos(theta_t);%%correct
%z_p = z_max*(cos(4*pi*f_p*t))+z_max;%%correct
z_p = L*(1-cos(asin(x_p/L))); %% fine

x_p = exp(-gamma_p*t)*L.*sin((asin(x_max/L))*cos(sqrt(g/L)*t));
z_p = L*(1-cos(asin(x_p/L)));%L*(1-cos((asin(x_max/L))*sin(sqrt(g/L)*t+pi/4))); %% fine

v_x_p = interp1(t(1:end-1),diff(x_p)./diff(t),t,'spline');
v_z_p = interp1(t(1:end-1),diff(z_p)./diff(t),t,'spline');

a_x_p = interp1(t(1:end-1),diff(v_x_p)./diff(t),t,'spline');
a_z_p = interp1(t(1:end-1),diff(v_z_p)./diff(t),t,'spline');

%%
figure()
hold on
subplot(211)
plot(t(1:150:end),x(1:150:end),'or', t,x_p,'-b','linewidth',2)
%plot(t,x,'--r', t,x_p,'-b','linewidth',2)
ylabel('$x(t)$ (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$x$ (IMU)','$x$ (Pendulum)'},'interpreter','latex','fontsize',20,'location','best','Orientation','horizontal')
set(gca,'fontsize',20) 
grid on;
box on

%z = circshift(z,-5);
subplot(212)
plot(t(1:150:end),z(1:150:end),'or', t,z_p,'-b','linewidth',2)
%plot(t,z,'--r', t,z_p,'-b','linewidth',2)
ylabel('$z(t)$ (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$z$ (IMU)','$z$ (Pendulum)'},'interpreter','latex','fontsize',20,'location','best','Orientation','horizontal')
set(gca,'fontsize',20) 
grid on;
box on

%%

figure()
hold on
subplot(211)
plot(t(1:150:end),v_x(1:150:end),'or', t,v_x_p,'-b','linewidth',2)
%plot(t,v_x,'--r', t,v_x_p,'-b','linewidth',2)
ylabel('$v_x(t)$ (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$v_x$ (IMU)','$v_x$ (Pendulum)'},'interpreter','latex','fontsize',20,'location','best','Orientation','horizontal')
set(gca,'fontsize',20) 
grid on;
box on

subplot(212)
plot(t(1:150:end),v_z(1:150:end),'or', t,v_z_p,'-b','linewidth',2)
%plot(t,v_z,'--r', t,v_z_p,'-b','linewidth',2)
ylabel('$v_z(t)$ (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$v_z$ (IMU)','$v_z$ (Pendulum)'},'interpreter','latex','fontsize',20,'location','best','Orientation','horizontal')
set(gca,'fontsize',20) 
grid on;
box on

%%

figure()
hold on
subplot(211)
plot(t(1:150:end),a_x(1:150:end),'or', t,a_x_p,'-b','linewidth',2)
%plot(t,a_x,'--r', t,a_x_p,'-b','linewidth',2)
ylabel('$a_x(t)$ (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$a_x$ (IMU)','$a_x$ (Pendulum)'},'interpreter','latex','fontsize',20,'location','best','Orientation','horizontal')
set(gca,'fontsize',20) 
grid on;
box on

subplot(212)
plot(t(1:150:end),a_z(1:150:end),'or', t,a_z_p,'-b','linewidth',2)
%plot(t,a_z,'--r', t,a_z_p,'-b','linewidth',2)
ylabel('$a_z(t)$ (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$a_z$ (IMU)','$a_z$ (Pendulum)'},'interpreter','latex','fontsize',20,'location','best','Orientation','horizontal')
set(gca,'fontsize',20) 
grid on;
box on

%%
%save([dr file_name '_final_for_ch.mat'],'a_x','a_z','v_x','v_z','x','z','t','x_p','z_p','v_x_p','v_z_p','a_x_p','a_z_p')
%}


%%

%close all
%{
theta_t = asin(x_max/L)*sin(2*pi*f_p*(t));
z_trial = cos(theta_t);
figure()
hold on
plot(t,[z_p;z_trial]);
legend({'$Z_p$','$Z_\textrm{trial}$'},'interpreter','latex','fontsize',20,'location','best')
%}