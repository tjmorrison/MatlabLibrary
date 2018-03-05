%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   skewt - function that skews the temperature axis for use in 
%           making skew-T plots.
%
%   tout = skewt(tin, pin)
%
%     tin - input temperature field
%     pin - input pressure field
%    tout - skewed temperatures for plot
%
%     created Nov. 2004 Ryan Torn, U. Washington
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tout = skewt(tin, pin)

mskew = ( 47 - 43.5 ) ./ ( log(1000) - log(900) );

%tout = tin - mskew .* ( log(pin) - log(1050.) );
tout = tin -mskew .* ( log(pin) - log(900.));