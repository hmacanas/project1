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

%% Orbital Parameters for the Moon
alt = 200; % altitude of orbit, [km]
T = 2*pi*sqrt((r_moon + alt)^3/mu_moon); % Period of orbit, [s]
data = dataRate_sensor*T/1000; % data per day required to send [Mbits]
data_rate = data/(15*60);%[bits/s]
ang = 2*(90 - acosd(r_moon/(r_moon + alt))); % angle for arc in eclipse, [deg]
tEclipse = T*ang/360; % time spent in eclipse, [s]
tSight = T - tEclipse; % time spent in [Earth line-of-sight / Sunlight], [s]
numOrbits = floor(24*60*60/T); % number of orbits around moon in a day

%% Low Cost

% Operations>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% 1.) Science Data Collection
%       * 1 orbit pointed nadir
%       * Payload on
%       * No comms
%       * Solar power dependent on orientation with body mounted panels
% 2.) Power and Comms
%       * 10 orbits
%       * 15 minutes of comms with no solar power per orbit (8 orbits)
%       * Rest of the time pointed to allow 2 panels to receive sun


% Power>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


% Comms>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

R = myComms('Low'); % [bit/s]
time_low = transmit_time(data_rate,data,numOrbits-1);

%% High Cost

% Operations>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% 1.) Science Data Collection
%       * 1 orbit pointed nadir
%       * Payload on
%       * No comms
%       * Solar power constant while in sun
% 2.) Power and Comms
%       * 10 orbits
%       * 15 minutes of comms per orbit (8 orbits)
%       * Solar power constant while in sun


% Power>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


% Comms>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

R = myComms('High'); % [bit/s]
time_high = transmit_time(data_rate,data,numOrbits-1);

[total_low,total_high] = myPower(500)

[mass_low,mass_high] = EricisBunk(tEclipse,T)


