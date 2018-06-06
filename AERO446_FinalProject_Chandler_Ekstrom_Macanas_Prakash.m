% Lea Chandler
% Eric Ekstrom
% Henry Macanas
% Deeksha Prakash
% AERO 446-01
% Final Project

close all
clear
clc

% Constants
r_earth = 6378; % radius of earth, [km]
mu_earth = 398600; % grativational parameter of earth, [km^3 / s^2]

% Givens
data_sensor = 100; % data sensor produces, [kbps]
P_sensor = 40; % sensor power consumed, [W]
P_standby = 2; % sensor on standby power consumed, [W]
z = 200; % altitude, [km]
t_trans = 2*60*60; % transmit time of s/c for 1 day, [s]
d_ground = 20; % diameter of ground antenna, [m]
T_noise = 150; % comms system temp noise, [K]
T_sp = 40; % solar panel temperature (both), [C]
losses = 5; % overall losseson comms systems, [dB]
margin = 5; % link budget margin, [dB]
% Low Cost







%% eric is bunk