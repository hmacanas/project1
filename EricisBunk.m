function [mass_low,mass_high] = EricisBunk(tEclipse)
% convert eclipse time to hrs


tEclipse = tEclipse/(60*60);
P_needed_high = 56.2; 
energy_needed_high = P_needed_high*tEclipse/2;
P_needed_low = 56.2;
energy_produced_low = 29.5757;
energy_needed_low =  P_needed_low*tEclipse-energy_produced_low;

rho_batt = 130;                                             % whr/kg
DoD = .41;                                                  % percent
charge_eff = .95;                                           % percent
batt_cap_needed_high = energy_needed_high/charge_eff/DoD;   % whr  
batt_cap_needed_low = energy_needed_low/charge_eff/DoD;     % whr
mass_high = batt_cap_needed_high/rho_batt;                  % kg
mass_low = batt_cap_needed_low/rho_batt;                    % kg


end

