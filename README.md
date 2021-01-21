# Processing-IMU-for-pendulum-motion
This is a Matlab library that processes MetaMotionR IMU sensor data 
This code is for reading and processing measured linear acceleration and quaternions from IMUs. Run the main.m file to show preprocessing and the drift-free velocities and displacements coreesponding to measured pendulum motion.

The project has the following files:
- `main.m`: This is the main file to run
- `cropData.m`: This file has MATLAB function that aims to crop the time series data.
- `normEarth.m`: This file has a function that normalizes the rotated accelerations.
- `plotting.m`: This file has plotting function that can be called. This function was made to reduce the repitions of the code.
- `read_and_Preprocess.m`: This file has function `preprocess()`, that reads the raw linear acceleration and quaternion data. It rotates the linear acceleration to the reference frame by using the Euler angles computed from the quaternions.
- `zuptPendulum.m`: This file is responsible from the drift elimination of the velocities and the displacements computed from the rotated linear accelerations.
