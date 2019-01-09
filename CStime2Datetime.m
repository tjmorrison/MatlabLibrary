function [Converted_time] = CStime2Datetime(time)
%Function to convert Campbell Scienctific (CS) data logger time to a
%matlab datetime vec
%Written by Travis Morrison
%University of Utah, dept. of Mech Eng. 
time  = soil_T(:,1:4);
Year = time(:,1);
julian_day = time(:,2);
HHmm = time(:,3);

Converted_time = ;
end

