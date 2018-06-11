function [mass_low,mass_high] = EricisBunk(energy_needed_high,energy_needed_low)


rho_batt = 130;                                             % whr/kg
DoD = .41;                                                  % percent
charge_eff = .95;                                           % percent
batt_cap_needed_high = energy_needed_high/charge_eff/DoD;   % whr  
batt_cap_needed_low = energy_needed_low/charge_eff/DoD;     % whr
mass_high = batt_cap_needed_high/rho_batt;                  % kg
mass_low = batt_cap_needed_low/rho_batt;                    % kg

end

