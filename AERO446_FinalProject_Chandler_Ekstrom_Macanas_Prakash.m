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
r_moon = 1737; % radius of moon, [km]
mu_earth = 398600; % grativational parameter of earth, [km^3 / s^2]
mu_moon = 4904.87; % grativational parameter of moon, [km^3 / s^2]

% Givens
dataRate_sensor = 100; % data sensor produces, [kbps]
P_sensor = 40; % sensor power consumed, [W]
P_standby = 2; % sensor on standby power consumed, [W]
t_trans = 2*60*60; % transmit time of s/c for 1 day, [s]
d_ground = 20; % diameter of ground antenna, [m]
T_noise = 150; % comms system temp noise, [K]
T_sp = 40; % solar panel temperature (both), [C]
losses = 5; % overall losseson comms systems, [dB]
margin = 5; % link budget margin, [dB]
% Low Cost
d_low = 20; % diameter of parabolic antenna, [cm]
% High Cost
d_high = 50; % diameter of deployable antennna, [cm]

% Orbital Parameters for the Moon
alt = 200; % altitude of orbit, [km]
T = 2*pi*sqrt((r_moon + alt)^3/mu_moon); % Period of orbit, [s]
data = dataRate_sensor*T/1000; % data per day required to send [Mb]

ang = 2*(90 - acosd(r_moon/(r_moon + alt))); % angle for arc in eclipse, [deg]
tEclipse = T*ang/360; % time spent in eclipse, [s]
tSight = T - tEclipse; % time spent in [Earth line-of-sight / Sunlight], [s]
numOrbits = floor(24*60*60/T); % number of orbits around moon in a day



%% Low Cost

% Power

% Comms

%% High Cost

% Power

% Comms
