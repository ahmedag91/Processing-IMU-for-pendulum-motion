function [time_stamps_cropped, ax_cropped, ay_cropped, az_cropped] = cropData(time_stamps, ax_earth, ay_earth, az_earth, start_date, start_time, interval_length)
    % This function crops the acceleration, and time stamps data based on the strings start date
    % and time and an integer representing interval length in seconds
    interval_start = datetime({[ start_date, start_time ]},'Format','yyyy-MM-dd''T''HH.mm.ss.SSS');
    interval_end = datetime({[ start_date, start_time ]},'Format','yyyy-MM-dd''T''HH.mm.ss.SSS')+seconds(interval_length);
    ax_cropped = ax_earth(time_stamps>=interval_start & time_stamps<=interval_end);
    ay_cropped = ay_earth(time_stamps>=interval_start & time_stamps<=interval_end);
    az_cropped = az_earth(time_stamps>=interval_start & time_stamps<=interval_end);
    time_stamps_cropped = time_stamps(time_stamps>=interval_start & time_stamps<=interval_end);
end
