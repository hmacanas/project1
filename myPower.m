function [total_low,total_high] = myPower(transmit_time)
% Input:
    % time of data transmission (s)
    
% Output:
    % total energy produced during low cost, and high cost configuration
    % over 11 orbits
    
% Note:
    % if the time of data transmission is zero energy then you produce
    % energy the entire time 
    
%% Constants

% orbital parameters>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
r_moon = 1737; % radius of moon, [km]
mu_moon = 4904.87; % grativational parameter of moon, [km^3 / s^2]
alt = 200; % altitude of orbit, [km]
T = 2*pi*sqrt((r_moon + alt)^3/mu_moon); % Period of orbit, [s]
ang = 2*(90 - acosd(r_moon/(r_moon + alt))); % angle for arc in eclipse, [deg]
tEclipse = T*ang/360; % time spent in eclipse, [s]

% needed parameters>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% angular velocity rads/s
w = 2*pi/T;                                                                 

% W/m^2
Se = 1367; 

% solar panel temp (c)
Temp = 40;   

% panel reference temp (c)
Temp_ref = 28;  

% area of one solar panel
Area = .3*.2;                                                             

% efficiency>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% solar cell efficiency
e_cell = .30;

% cell degradation/year
e_deg = .025;

% temp efficiency change
e_temp = .005;                                                             

% temperature effciency
E_temp = e_cell*(1-e_temp*(Temp-Temp_ref)); 

% time efficiency
E_time = (1-e_deg)^3;

% packing desnity for now
E_packing_desnity = 1;    

% combined efficiency
E_total = E_temp*E_time*E_packing_desnity; 

%% Low Cost

% Science orientation>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% power calcs when collecting science (solar panels at a 45
syms t
theta = w*t;                                                               
Area_wetted = 2*cos(pi/4)*Area;
P_fore_science = Se*Area_wetted*E_total*sin(theta);                         
P_aft_science =  Se*Area_wetted*E_total*-sin(theta);                        
P_total_science = P_fore_science+P_aft_science;                             

% energy calcs when collecting science
energy_fore_science = double(int(P_fore_science,t,[tEclipse/2, T/2]));      
energy_aft_science = double(int(P_aft_science,t,[T/2, T - tEclipse/2]));    
total_energy_science = (energy_fore_science + energy_aft_science)/3600;     

% 45 always>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% power
P_45_all = Se*Area_wetted*E_total*sin(pi/2);

% energy
energy_total_45 = (double(int(P_45_all,t,[tEclipse/2, T/2-transmit_time/2])))/3600+...
(double(int(P_45_all,t,[T/2+transmit_time/2, T - tEclipse/2])))/3600;

% % 3-body Penals>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% 
% % power calcs when colecting power
% syms t
% P_fore_body = Se*Area*E_total*sin(theta);                                   
% P_aft_body =  Se*Area*E_total*-sin(theta);                                  
% P_zenith_body = Se*Area*E_total*-cos(theta);                                
% P_total_body = P_fore_body+P_aft_body+P_zenith_body;

% % energy calcs 
% energy_fore_body = double(int(P_fore_body,t,[tEclipse/2, T/2]));
% energy_aft_body = double(int(P_aft_body,t,[T/2, T - tEclipse/2]));
% energy_zenith_body = double(int(P_zenith_body,t,[T/4, 3*T/4]));
% energy_total_body = (energy_fore_body + energy_aft_body + energy_zenith_body)/3600;

%% High Cost

% power calcs
syms t
theta = pi/2;                                                                
P_norm = 2*Se*Area*E_total*sin(theta);                                      

% energy calcs
total_energy_tracking = (double(int(P_norm,t,[0, T-tEclipse])))/3600;   

%% Power Plots 

% time is one orbit
time = linspace(0,T,100);

% how long we will be transmitting data (s)
%transmit_time = 1/10*T;

% Constant: found in duty cycle table [W]
P_transmit = 40.6;
P_science = 56.2;
P_idle = 18.2;


% P_cpu = 
% P_adcs = 
% P_transmitter = 
% P_reciever = 
% P_sensor = 
for i = 1:length(time)
    theta = w*time(i);
    P_science(i) = 56.2;
    P_cpu(i) = 1.6;
    P_adcs(i) = 2;
    P_reciever(i) = 12.6;
    P_sensor(i) = 38;
    
    % if its in eclipse all power is zero
    if time(i) <= tEclipse/2 ||time(i) >= T-tEclipse/2
        P_fore_science(i) = 0;                                      
        P_aft_science(i) = 0;                                        
        P_norm(i) = 0;
        P_45_all(i) = 0;
        P_idle(i) = 18.2;
        
     
    end
    
    % if its after eclipse and before transmitting and half the period 
    if time(i) > tEclipse/2 && time(i) < T/2 - transmit_time/2
        P_fore_science(i) = Se*Area_wetted*E_total*sin(theta);     
        P_aft_science(i) = 0;
        P_45_all(i) = Se*Area_wetted*E_total*sin(pi/2);
        P_idle(i) = 18.2;
    end
    
    % if its transmitting 
    if time(i) >= T/2-transmit_time && time(i)<= T/2+transmit_time
        P_transmit(i) = 40.6;
        P_idle(i) = NaN;
        P_transmitter(i) = 22.4;
    else
        P_transmit(i) = 0;
        P_transmitter(i) = NaN;
    end
    
    % if its after half the period and transmit time and not in eclipse
    if time(i) >= T/2 + transmit_time/2 && time(i) < T - tEclipse/2
        P_fore_science(i) = 0;                                      
        P_aft_science(i) = Se*Area_wetted*E_total*-sin(theta);      
        P_45_all(i) = Se*Area_wetted*E_total*sin(pi/2);
        P_idle(i) = 18.2;
    end

 
    % if tis in the sun at all tracking panels can collect
    if time(i) >=tEclipse/2 && time(i)< T-tEclipse/2
        P_norm(i) = 3*Se*Area_wetted*E_total*sin(pi/2);  
    end
 
end

P_used_by_sc = P_transmit+P_idle;


total_high = total_energy_tracking*11;
total_low = total_energy_science+energy_total_45*10;
% figure
% hold on
% plot(time,P_fore_science+P_aft_science,'linewidth',2)
% title('Power Generation During Science vs Time')
% xlabel('Time (s)')
% ylabel('Power (W)')
% 
% 
% figure
% plot(time,P_45_all,'linewidth',2)
% title('Power Generation Low Cost Configuration"')
% xlabel('Time (s)')
% ylabel('Power (W)')
% 
% figure
% plot(time,P_norm,'linewidth',2)
% title('Power Generation High Cost Configuration')
% xlabel('Time (s)')
% ylabel('Power (W)')

time = linspace(0,11*T,100*11);
P_high = [P_norm,P_norm,P_norm,P_norm,P_norm,P_norm,P_norm,P_norm,P_norm,P_norm,P_norm];
P_low = [P_aft_science+P_fore_science,P_45_all,P_45_all,P_45_all,P_45_all,P_45_all,P_45_all,P_45_all,P_45_all,P_45_all,P_45_all];
P_consumed = [P_science,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc,P_used_by_sc];
P_cpu = [P_cpu,P_cpu,P_cpu,P_cpu,P_cpu,P_cpu,P_cpu,P_cpu,P_cpu,P_cpu,P_cpu];
P_adcs = [P_adcs,P_adcs,P_adcs,P_adcs,P_adcs,P_adcs,P_adcs,P_adcs,P_adcs,P_adcs,P_adcs];
P_transmitter = [P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,P_transmitter,];
P_reciever =[P_reciever,P_reciever,P_reciever,P_reciever,P_reciever,P_reciever,P_reciever,P_reciever,P_reciever,P_reciever,P_reciever];
t = linspace(0,T,100);
null = zeros(1,length(t))*nan;
P_sensor =[P_sensor,null,null,null,null,null,null,null,null,null,null];


t = linspace(0,T,100);
figure
set(gca,'FontSize',18)
hold on
plot(time,P_high,'linewidth',2)
plot(time,-P_cpu,'linewidth',2)
plot(time,-P_adcs,'linewidth',2)
plot(time,-P_transmitter,'linewidth',2)
plot(time,-P_reciever,'linewidth',2)
plot(time,-P_sensor,'linewidth',2)
title('Power Generation High Cost Configuration')
xlabel('Time (s)')
ylabel('Power (W)')
legend({'Panels','cpu','adcs','trasnmitter','reciever','sensor'},'Location','northeast','FontSize',16)

figure
set(gca,'FontSize',18)
hold on
plot(time,P_low,'linewidth',2)
plot(time,-P_cpu,'linewidth',2)
plot(time,-P_adcs,'linewidth',2)
plot(time,-P_transmitter,'linewidth',2)
plot(time,-P_reciever,'linewidth',2)
plot(time,-P_sensor,'linewidth',2)
title('Power Generation Low Cost Configuration')
xlabel('Time (s)')
ylabel('Power (W)')
legend({'Panels','cpu','adcs','trasnmitter','reciever','sensor'},'Location','northeast','FontSize',16)


% figure
% plot(t,P_idle,'linewidth',2)
% title('Spacecraft Idle Power')
% xlabel('Time (s)')
% ylabel('Power (W)')
% 
% figure
% plot(t,P_transmit,'linewidth',2)
% title('Spacecraft Transmit Power')
% xlabel('Time (s)')
% ylabel('Power (W)')
% 
% figure
% plot(t,P_used_by_sc,'linewidth',2)
% title('Spacecraft Consumed Power')
% xlabel('Time (s)')
% ylabel('Power (W)')
% 
figure
plot(time,P_low-P_consumed,'linewidth',2)
title('Power Generated Minus Power Consumed by Spacecraft: Low Cost Configuration')
xlabel('Time (s)')
ylabel('Power (W)')

figure
plot(time,P_high-P_consumed,'linewidth',2)
title('Power Generated Minus Power Consumed by Spacecraft: High Cost Configuration')
xlabel('Time (s)')
ylabel('Power (W)')


end

