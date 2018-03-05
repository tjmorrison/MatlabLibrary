%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   satur_mix_ratio - functiont that calculates the saturdation mixing 
%                     ratio given the saturation vapor pressure and 
%                     air pressure.
%
%   ws = satur_mix_ratio(es, pin)
%
%     es - saturation vapor pressure (in same units as pin)
%    pin - air pressure (in same units as es)
%     ws - saturation mixing ratio (unitless)
%
%     created Jan. 2005 Ryan Torn, U. Washington
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ws = satur_mix_ratio(es, pin)

ws = 0.622 .* ( es ./ (pin - es) );
