function [ E ] = energyUsed(t_transmit, t_science, period)
% Function to calculate energy used by spacecraft operations over some
% period
%
% Inputs:   t_transmit: time the sapcecraft is transmitting [s]
%           t_science: time spacecraft is collecting science [s]
%           period: total time of interest [s]
% Outputs:  E: total energy used by the spacecraft [W-hr]

% Constant: found in duty cycle table
P_transmit = 41.725;    % [W]
P_science = 57.325;     % [W]
P_idle = 19.325;        % [W]

% idle time
t_idle = period - t_transmit - t_science;       % [s]

% energy used in each mode
E_transmit = t_transmit * P_transmit / 3600;	% [W-hrs]
E_science = t_science * P_science / 3600;       % [W-hrs]
E_idle = t_idle * P_idle / 3600;                % [W-hrs]

% total energy
E = E_transmit + E_science + E_idle;            % [W-hrs]

end