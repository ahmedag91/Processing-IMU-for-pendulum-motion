function [time_stamp, ax, ay, az, b] = read_csv_files(dr,file_name)
    % This function reads either the linear acceleration or quaternion
    % files in csv format it either returns the times stamps and the
    % acceleration vectors or the quaternion vectors
    file_name = fullfile(file_name);
    fileID = fopen([dr file_name]);
    %global accelerations
    if( ~contains(file_name, '_Quaternion') )
        accelerations = textscan(fileID,'%s %s %s %s %s %s','Delimiter',',');
        g = 9.8;
        time_stamp = cellfun(@str2num, accelerations{3}(2:end))';
        ax = cellfun(@str2num, accelerations{4}(2:end))'*g;
        ay = cellfun(@str2num, accelerations{5}(2:end))'*g;
        az = cellfun(@str2num, accelerations{6}(2:end))'*g;
        b = [];
    else
        accelerations = textscan(fileID,'%s %s %s %s %s %s %s','Delimiter',',');
        time_stamp = [];
        ax = cellfun(@str2num, accelerations{4}(2:end))';
        ay = cellfun(@str2num, accelerations{5}(2:end))';
        az = cellfun(@str2num, accelerations{6}(2:end))';
        b = cellfun(@str2num, accelerations{7}(2:end))';
    end
    fclose(fileID);
end
