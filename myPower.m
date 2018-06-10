function [total_energy_science,total_energy_tracking,energy_total_body] = myPower()
% Constants
r_moon = 1737; % radius of moon, [km]
mu_moon = 4904.87; % grativational parameter of moon, [km^3 / s^2]


% Orbital Parameters for the Moon
alt = 200; % altitude of orbit, [km]
T = 2*pi*sqrt((r_moon + alt)^3/mu_moon); % Period of orbit, [s]
ang = 2*(90 - acosd(r_moon/(r_moon + alt))); % angle for arc in eclipse, [deg]
tEclipse = T*ang/360; % time spent in eclipse, [s]

%% Low Cost >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


% needed parameters

w = 2*pi/T;                                         % angular velocity rads/s
Se = 1367;                                          % W/m^2
Temp = 40;                                          % nominal solar panel temp
Temp_ref = 28;                                      % solar panel reference temp

% NEED TO CHANGE
Area = .3*.2;                                       % area of each panel

% efficiency

% NEED TO CHANGE THESE 
e_cell = .29;                                       % solar cell efficiency
e_deg = .025;                                       % cell degradation/year
e_temp = .005;                                      % temp efficiency change

% THESE ARE FINE 
E_temp = e_cell*(1-e_temp*(Temp-Temp_ref));         % temperature effciency
E_time = (1-e_deg)^7;                               % time efficiency
E_packing_desnity = 1;                              % packing desnity for now
E_total = E_temp*E_time*E_packing_desnity;          % combined efficiency

% power calcs when collecting science (solar panels at a 45)
syms t
theta = w*t;                                        % angle of incidence 
Area_wetted = 2*cos(pi/4)*Area;
P_fore = Se*Area_wetted*E_total*sin(theta);         % power fore panel
P_aft =  Se*Area_wetted*E_total*-sin(theta);        % power aft panel
P_side1 = 0;                                        % power side panel 1
P_side2 = 0;                                        % power side panel 1
P_total_science = P_fore+P_aft;                     % watts

% energy calcs when collecting science
energy_fore_science = double(int(P_fore,t,[tEclipse/2, T/2]));      % energy produced by fore
energy_aft_science = double(int(P_aft,t,[T/2, T - tEclipse/2]));    % energy produced by aft
total_energy_science = (energy_fore_science + energy_aft_science)/3600;     %(whrs)

% power calcs when colecting power
syms t
P_fore = Se*Area_wetted*E_total*sin(theta);                 % power fore panel
P_aft =  Se*Area_wetted*E_total*-sin(theta);                % power aft panel
P_zenith = Se*Area*E_total*-cos(theta);                     % zenith panel power
P_total_body = P_fore+P_aft+P_zenith;

% energy calcs 
energy_fore_body = double(int(P_fore_body,t,[tEclipse/2, T/2]));
energy_aft_body = double(int(P_aft_body,t,[T/2, T - tEclipse/2]));
energy_zenith_body = double(int(P_zenith_body,t,[P/4, 3*P/4]));
energy_total_body = (energy_fore_body + energy_aft_body + energy_zenith_body)/3600;

% Comms>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%% High Cost

% Power>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% power calcs
syms t
theta = pi/2;                                                           % incidence angle always 
P_norm = 3*Se*Area*E_total*sin(theta);                                  % watts power produced by all panels

% energy calcs
total_energy_tracking = (double(int(P_norm,t,[0, T-tEclipse])))/3600;   % whrs energy produced by all panels

% Comms>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end

