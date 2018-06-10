function [R] = myComms(cost)

kb = 1.38065*10^(-23); % Boltzmann (J/K)
margin = 5; % [dB]
P = 3.8;
Ts = 150; % [k]
loss = -5; % [dB]
f = 8.4e9; % [Hz]
dFixed = 0.20; % [m]
dDepl = 0.50; % [m]
dGnd = 20; % [m]
EbNo = 3; % [dB]

dist = 384400000; % [m]
FSPL = -20*log10(dist) - 20*log10(f) + 147.55; % [dB]

gainFixed = 20*log10(f*10^-9) + 20*log10(dFixed) + 17.8;
gainDepl = 20*log10(f*10^-9) + 20*log10(dDepl) + 17.8;
gainGnd = 20*log10(f*10^-9) + 20*log10(dGnd) + 17.8;

if strcmp(cost,'Low')
    R = 10.^((10*log10(P) + loss + gainFixed + FSPL + gainGnd - 10*log10(kb) - 10*log10(Ts) - EbNo - margin)/10);
elseif strcmp(cost,'High')
    R = 10.^((10*log10(P) + loss + gainDepl + FSPL + gainGnd - 10*log10(kb) - 10*log10(Ts) - EbNo - margin)/10);
else
    error('Usage: myComms([''High''/''Low''])');
end
% R = 10.^((10*log10(P) + Ll + Gg + FSPL - 10*log10(Astro.kb) - 10*log10(Ts) - E_No - marg)/10);

end