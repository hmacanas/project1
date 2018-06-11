function [ E_low, E_high ] = energyUsed()

% Function to calculate energy used by spacecraft operations over some
% period
% Assumes low cost receiving is only on when transmitting, and high
% cost receiving is always one
%
%
% Inputs    t_transmit: time the sapcecraft is transmitting [s]
%           t_science: time spacecraft is collecting science [s]
%           t_eclipse: time spacecraft is in eclipse [s]
%           period: total time of interest [s]
% Outputs   E: total energy used including margin [W-hr]
%           E_transmit: energy used by the during transmit [W-hr]
%           E_eclipse: energy used by the during eclipse [W-hr]


r_moon = 1737; % radius of moon, [km]
mu_moon = 4904.87; % grativational parameter of moon, [km^3 / s^2]
alt = 200; % altitude of orbit, [km]
T = 2*pi*sqrt((r_moon + alt)^3/mu_moon); % Period of orbit, [s]

t_transmit = 15*60;  % [s]
t_science = 15*60;   % [s]
t_idle = T*11 - t_transmit - t_science;

% Constants: found in duty cycle table [W]
P_idle = 5.6;
P_receive = 18.2;
P_transmit = 40.6;
P_science = 43.6;

% HIGH COST energy used in each mode [W-hrs]
E_high_transmit = t_transmit*P_transmit / 3600;
E_high_science = t_science*P_science / 3600;
E_high_idle = t_idle*P_receive / 3600;

% high cost total energy including margin [W-hrs]
E_high = (E_high_transmit + E_high_science + E_high_idle) * 1.2;


% LOW COST energy used in each mode [W-hrs]
E_low_transmit = t_transmit*P_transmit / 3600;
E_low_science = t_science*P_science / 3600;
E_low_idle = t_idle*P_idle / 3600;

% low cost total energy including margin [W-hrs]
E_low = (E_low_transmit + E_low_science + E_low_idle) * 1.2;


end