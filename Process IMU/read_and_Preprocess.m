%% Read The accelerations
function [ax_earth, ay_earth, az_earth, time_stamps, dt] = preprocess()
    [file_name, dr] = uigetfile({'*_LinearAcceleration.csv'});
    [time_stamps, ax, ay, az, ~] = read_csv_files(dr,file_name);

    %% Parsing time_stamp from strings to date time format
    time_stamps = datetime(time_stamps,'Format','yyyy-MM-dd''T''HH.mm.ss.SSS');
    dt = 1e-2;
    t = (0:length(ax)-1)*dt;

    %% Smooth the accelerations and compare by plotting
    ax_new = smoothdata(ax,'loess');
    ay_new = smoothdata(ay,'loess');
    az_new = smoothdata(az,'loess');

    %
    %% plotting before and after denoising (optional)

    plotting(time_stamps, [ax_new; ax], ' ',....
    {'$a_x(t)$ (before denoising)', '$a_x(t)$ (after denoising)'},.....
    'Time, $t$~(s)', 'Accelerations~($m/s^{2}$)')

    plotting(time_stamps, [ay_new; ay], ' ',....
    {'$a_y(t)$ (before denoising)', '$a_y(t)$ (after denoising)'},.....
    'Time, $t$~(s)', 'Accelerations~($m/s^{2}$)')

    plotting(time_stamps, [ay_new; ay], ' ',....
    {'$a_y(t)$ (before denoising)', '$a_y(t)$ (after denoising)'},.....
    'Time, $t$~(s)', 'Accelerations~($m/s^{2}$)')

    plotting(time_stamps, [az_new; az], ' ',....
    {'$a_y(t)$ (before denoising)', '$a_y(t)$ (after denoising)'},.....
    'Time, $t$~(s)', 'Accelerations~($m/s^{2}$)')

    %% overwriting the raw accelerations with the denoised ones (optional)

    ax = ax_new;
    ay = ay_new;
    az = az_new;
    %}

    %% Read the quaternions

    %global accelerations;
    [file_name1, dr] = uigetfile({'*_Quaternion.csv'});
    [~, w, x, y, z] = read_csv_files(dr,file_name1);

    %% Rotate the accelerations


    ax_earth = zeros(1,length(t));
    ay_earth = zeros(1,length(t));
    az_earth = zeros(1,length(t));
    det_rot = zeros(1,length(t));
    %t = ax_earth;
    for l = 1:length(t)
        %det_rot(l) = det(quat2rotm([w(l) x(l) y(l) z(l)]));
        acc_earth = quat2rotm([w(l) x(l) y(l) z(l)])'\[ax(l);ay(l);az(l)];
        ax_earth(l) = acc_earth(1);
        ay_earth(l) = acc_earth(2);
        az_earth(l) = acc_earth(3);
    end
    % Calibrate the data (Optional)
    %
    ax_earth = ax_earth - ax_earth(1);
    ay_earth = ay_earth - ay_earth(1);
    az_earth = az_earth - az_earth(1);
    %}


    plotting(time_stamps, [ax_earth; ay_earth; az_earth], 'Earth accelerations',....
    {'$a_x(t)$ (Earth)', '$a_y(t)$ (Earth)', '$a_z(t)$ (Earth)'},.....
    'Time, $t$~(s)', 'Accelerations~($m/s^{2}$)')

    %% Normalize accelerations and plot them versus the time stamps

    [ax_earth, ay_earth, az_earth] = normAccEarth(ax_earth, ay_earth, az_earth);

    plotting(time_stamps, [ax_earth; ay_earth; az_earth], 'Earth accelerations after normalization',....
    {'$a_x(t)$ (Earth)', '$a_y(t)$ (Earth)', '$a_z(t)$ (Earth)'},.....
    'Time, $t$~(s)', 'Accelerations~($m/s^{2}$)')

end