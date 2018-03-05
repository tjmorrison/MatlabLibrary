%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   temp_to_theta - function that calculates the potential temperature
%                   given the temperature and pressure.
%
%   theta = temp_to_theta(temp, pres)
%
%     temp - input temperature (K)
%     pres - input pressure (Pa)
%    theta - potential temperature (K)
%
%     created June 2003 Ryan Torn, U. Washington
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = temp_to_theta(temp, pres) 

load atmos_const.mat

theta = temp .* (Pr ./ (pres./100) ) .^ (Rd/Cp);
