%%%% This function takes a column vector or a matrix, and the sample period (dt) as
%%%% inputs. You can insert a matrix whose each column represents a
%%%% component. This function can be used to get the velocity or
%%%% displacement as outputs, for pendulum's motion
%%%% accel_smoothed_vector should be in column form not row
function [vel_vec] = ZUPT_vel_wrists_vec(accel_smoothed_vector,samplePeriod)
    g = 9.8;
    vel_vec = accel_smoothed_vector;
    vel_vec(:) = 0;
    acc = accel_smoothed_vector;
    stationary = zeros(size(accel_smoothed_vector));
    [~,indices] = findpeaks(abs(accel_smoothed_vector/g));
    stationary(indices) = 1;
    vel = zeros(length(accel_smoothed_vector),1);
    for t = 2:length(vel)
        vel(t,:) = vel(t-1,:) + acc(t,:) * samplePeriod;
        if(stationary(t) == 1)
            % force zero velocity when the pendulum is at maximum as it is sinusoid
            vel(t,:) = 0;
        end
    end
    velDrift = zeros(size(vel));
    stationaryStart = [1;indices(1:end-1)];%find([0; diff(stationary)] == 1);
    stationaryEnd = [indices(2:end);length(vel)];
    stationaryStart = [stationaryStart;stationaryEnd(end-1)];
    stationaryEnd = [stationaryStart(2);stationaryEnd];
    for i = 1:numel(stationaryEnd)
        if i ==length(vel)
            driftRate = vel(stationaryEnd(i)) / (stationaryEnd(i) - stationaryStart(i));
        else
            driftRate = vel(stationaryEnd(i)-1) / (stationaryEnd(i) - stationaryStart(i));
        end
        enum = 1:(stationaryEnd(i) - stationaryStart(i));
        drift = [enum'*driftRate];
        if i ==length(vel)
            velDrift(stationaryStart(i):stationaryEnd(i)) = drift;
        else
            velDrift(stationaryStart(i):stationaryEnd(i)-1) = drift;
        end
    end
    vel = vel - velDrift;
    vel_vec = vel;
end
