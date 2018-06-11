function [ E ] = energyUsed(t_transmit, t_science, period)
% t in seconds
% E in W

t_idle = period - t_transmit - t_science;   % [s]

P_transmit = 41.725;    % [W]
P_science = 57.325;     % [W]
P_idle = 19.325;        % [W]

E_transmit = t_transmit * P_transmit / 60;	% [W-hrs]
E_science = t_science * P_science / 60;     % [W-hrs]
E_idle = t_idle * P_idle / 60;              % [W-hrs]

E = E_transmit + E_science + E_idle;        % [W-hrs]

end