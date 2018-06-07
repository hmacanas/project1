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

% Power>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% needed parameters

w = 2*pi/T;                                         % angular velocity rads/s
Se = 1366;                                          % W/m^2

% NEED TO CHANGE
Area_body = 1;                                      % area of 1 body panel
Area_tarcking = 1;                                  % area of 1 tracking panel

% efficiency

% NEED TO CHANGE THESE 
e_cell = .29;                                       % solar cell efficiency
e_deg = .025;                                       % cell degradation/year
e_temp = .005;                                      % temp efficiency change

% THESE ARE FINE 
E_temp = e_cell*(1-e_temp*(40-28));                 % temperature effciency
E_time = (1-e_deg)^7;                               % time efficiency
E_packing_desnity = 1;                              % packing desnity for now
E_total = E_temp*E_time*E_packing_desnity;          % combined efficiency

% power calcs

syms t
theta = w*t;                                        % angle of incidence 
P_fore = Se*Area_body*E_total*sin(theta);           % power fore panel
P_aft =  Se*Area_body*E_total*-sin(theta);          % power aft panel
P_side1 = 0;                                        % power side panel 1
P_side2 = 0;                                        % power side panel 1

% energy calcs
energy_fore = double(int(P_fore,t,[tEclipse/2, T/2]));      % energy produced by fore
energy_aft = double(int(P_aft,t,[T/2, T - tEclipse/2]));    % energy produced by aft


% Comms>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%% High Cost

% Power>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% power calcs
syms t
theta = pi/2;                                           % incidence angle always 
P_norm = Se*Area_tarcking*E_total*sin(theta);           % power produced by one panel

% energy calcs
energy_norm = double(int(P_norm,t,[0, T-tEclipse]));    % energy produced by one panel

% Comms>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>








