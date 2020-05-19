close all
clear 
clc

tic
[file_name,dr ] = uigetfile({'*vel_pos*'});

load([dr file_name ])


%% Display the velocities in one figure
t_start = t(1);0.64;1.35;
t_end = t(end);24.95;
ax_earth = ax_earth(find(t>=t_start& t<=t_end));
ay_earth = ay_earth(find(t>=t_start& t<=t_end));
az_earth = az_earth(find(t>=t_start& t<=t_end));
pos = pos(find(t>=t_start& t<=t_end),:);
vel = vel(find(t>=t_start& t<=t_end),:);
t = t(find(t>=t_start& t<=t_end));

pos(:,3) = pos(:,3)+max(pos(:,3)).*exp(-0.005*t)';

%pos(:,3) = pos(:,3);%.*exp(-0.001*t)';%-min(pos(:,3));
pos = pos';
vel = vel';

pos = pos';
vel = vel';
%{
vel = vel';
%vel(1,:) = -vel(1,:);

pos = pos';
pos(3,:) = pos(3,:)+0.01233;
t_index_end = 8;t(end);%t(2055);t(994);14;
vel = vel(:,find(t<=t_index_end));

pos = pos(:,find(t<=t_index_end));
%pos(1,:) = -pos(1,:);

t = t(find(t<=t_index_end));
%}

figure()
hold on
subplot(211)
plot(t,vel,'linewidth',2)
ylabel('$v_i$ (m/s)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$v_x$' ,'$v_y$','$v_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

subplot(212)
plot(t,pos,'linewidth',2)
ylabel('Displacement (m)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$x$' ,'$y$','$z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

figure()
hold on

plot(t,vel(:,3),t,pos(:,3)','linewidth',2)
ylabel('$v_i$ (m/s)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$v_x$' ,'$v_y$','$v_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

v_x = vel(:,1);zeros(1,size(vel,2));
v_y = vel(:,2);zeros(1,size(vel,2));
v_z = vel(:,3);zeros(1,size(vel,2));

x = pos(:,1);
y = pos(:,2);
z = pos(:,3);
z = z-min(abs(z));


figure;
hold on;
plot(t,[ax_earth;ay_earth;az_earth],'linewidth',2)
ylabel('acceleration (m/s$^2$)','interpreter','latex','fontsize',20)
xlabel('Time $t$(s)','interpreter','latex','fontsize',20)
legend({'$a_x$' ,'$a_y$','$a_z$'},'interpreter','latex','fontsize',20,'location','best')
set(gca,'fontsize',20) 
grid on;
box on

%%
save([dr 'vel_pos_final' '.mat'],'t','ax_earth','ay_earth','az_earth','v_x','v_y','v_z','x','y','z')
%%
