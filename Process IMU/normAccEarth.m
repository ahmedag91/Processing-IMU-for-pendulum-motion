function [ax_rot, ay_rot, az_rot] = normAccEarth(ax_earth, ay_earth, az_earth)
  %% This function rotates the earth acceleration to be in x direction only
  az_rot = az_earth;
  ax_rot = sqrt(ax_earth.^2+ay_earth.^2);
  ax_rot(ax_earth<0) = -1*ax_rot(ax_earth<0);
  ay_rot = zeros(size(ay_earth));
  ax_rot = smoothdata(ax_rot,'loess');
end
