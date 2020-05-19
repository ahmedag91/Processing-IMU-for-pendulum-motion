

function [time_stamp, ax, ay, az, b] = read_csv_files(dr,file_name)

    if( ~contains(file_name, '_Quaternion') )
        g = 9.8;
        accelerations = textscan(fileID,'%s %s %s %s %s %s','Delimiter',',');
        time_stamp = cellfun(@str2num, accelerations{3}(2:end))';
        ax = cellfun(@str2num, accelerations{4}(2:end))'*g;
        ay = cellfun(@str2num, accelerations{5}(2:end))'*g;
        az = cellfun(@str2num, accelerations{6}(2:end))'*g;
        b = [];
    else
        time_stamp = [];
        ax = cellfun(@str2num, accelerations{4}(2:end))';
        ay = cellfun(@str2num, accelerations{5}(2:end))';
        az = cellfun(@str2num, accelerations{6}(2:end))';
        b = cellfun(@str2num, accelerations{7}(2:end))';
    end
end
