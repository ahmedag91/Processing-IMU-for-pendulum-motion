# Processing-IMU-for-pendulum-motion

## Description and How to Run

This is a Matlab library that processes MetaMotionR IMU sensor data 
This code is for reading and processing measured linear acceleration and quaternions from IMUs. Run the main.m file to show preprocessing and the drift-free velocities and displacements coreesponding to measured pendulum motion. There are two `csv` files on which you can test this code. These files contain the recorded quaternions and linear acceleration of a pendulum experiment. Just, run the `main.m` file and you will be asked twice to choose the `csv` files. The first time, you should choose the one that contains the linear acceleration data. The second time, choose the one that contains quaternions data. 

## Description of the [`Matlab`](https://www.mathworks.com/) files

The project has the following files:
- [`main.m`](https://github.com/ahmedag91/Processing-IMU-for-pendulum-motion/blob/master/Process%20IMU/main.m): This is the main file to run.
- [`cropData.m`](https://github.com/ahmedag91/Processing-IMU-for-pendulum-motion/blob/master/Process%20IMU/cropData.m): This file has MATLAB function that aims to crop the time series data.
- [`normEarth.m`](https://github.com/ahmedag91/Processing-IMU-for-pendulum-motion/blob/master/Process%20IMU/normEarth.m): This file has a function that normalizes the rotated accelerations.
- [`plotting.m`](https://github.com/ahmedag91/Processing-IMU-for-pendulum-motion/blob/master/Process%20IMU/plotting.m): This file has plotting function that can be called. This function was made to reduce the repitions of the code.
- [`read_and_Preprocess.m`](https://github.com/ahmedag91/Processing-IMU-for-pendulum-motion/blob/master/Process%20IMU/read_and_Preprocess.m): This file has function `preprocess()`, that reads the raw linear acceleration and quaternion data. It rotates the linear acceleration to the reference frame by using the Euler angles computed from the quaternions.
- [`zuptPendulum.m`](https://github.com/ahmedag91/Processing-IMU-for-pendulum-motion/blob/master/Process%20IMU/zuptPendulum.m): This file is responsible for the drift elimination of the velocities and the displacements computed from the rotated linear accelerations. The algorithm implemented in this file is a modified version of the one available at this [link](https://github.com/xioTechnologies/Gait-Tracking-With-x-IMU/blob/master/Gait%20Tracking%20With%20x-IMU/Script.m) and this [video](https://www.youtube.com/watch?v=6ijArKE8vKU). The algorithm provided in the afermentioned links was used to track walking humans by attaching a IMU to their feet. Further explanation of the modified version of implemented algorithm can be found at the results section of the [paper](http://dx.doi.org/10.3390/s20041049) with the citation below.

## Citation

If you find that this repository is useful for you research work, please cite the following article:

```bash
@article{Abdelgawwad_2020, 
title={Modelling, Analysis, and Simulation of the Micro-Doppler Effect in Wideband Indoor Channels with Confirmation Through Pendulum Experiments}, 
volume={20},
ISSN={1424-8220}, 
url={http://dx.doi.org/10.3390/s20041049},
DOI={10.3390/s20041049}, 
number={4}, 
journal={Sensors},
publisher={MDPI AG},
author={Abdelgawwad, Ahmed and Borhani, Alireza and P{\"}atzold, Matthias}, 
year={2020}, 
month={Feb},
pages={1049}}
```
