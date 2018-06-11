function [ E, E_transmit, E_eclipse ] = ...
    energyUsed(t_transmit, t_science, t_eclipse, period)

% Function to calculate energy used by spacecraft operations over some
% period
%
% Example usage
% energyUsed(15*60, T, 45*60*10, T*11)
% where T is lunar orbit period
%       (15*60) seconds of transmitting
%       (45*60)*(10periods) seconds of non-science eclipse
%       (T*11periods) seconds total for time span of interest
%
% Inputs    t_transmit: time the sapcecraft is transmitting [s]
%           t_science: time spacecraft is collecting science [s]
%           t_eclipse: time spacecraft is in eclipse [s]
%           period: total time of interest [s]
% Outputs   E: total energy used including margin [W-hr]
%           E_transmit: energy used by the during transmit [W-hr]
%           E_eclipse: energy used by the during eclipse [W-hr]

% Constant: found in duty cycle table [W]
P_transmit = 40.6;
P_science = 56.2;
P_idle = 18.2;
P_eclipse = P_idle;

% idle time [s]
t_idle = period - t_transmit - t_science - t_eclipse;

% energy used in each mode [W-hrs]
E_transmit = t_transmit * P_transmit / 3600;
E_science = t_science * P_science / 3600;
E_idle = t_idle * P_idle / 3600;
E_eclipse = t_eclipse * P_eclipse / 3600;

% total energy including margin [W-hrs]
E = (E_transmit + E_science + E_idle + E_eclipse) * 1.2;

end