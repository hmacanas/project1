function [time] = transmit_time(R,data,numOrbits)

    % Input:
        % max data rate to close the link in (bits/s)
        % amount of data needed to to trasnmitted per day (data/day)
    % Output:
        % time needed to trasnmit per orbit
 
    % amount of data per orbit needed to send (s)
    data_per_orbit = data/numOrbits;
    
    % calculate amount of time (s)
    time = data_per_orbit/R;
    
    
end

