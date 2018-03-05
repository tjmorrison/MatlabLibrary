%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   thetae - matlab function that calculates the equivalent 
%            potential temperature
%
%   thout = thetae(thin, tin, wsin)
%
%     thin - input potential temperature
%      tin - input temperature
%     wsin - input saturation mixing ratio
%    thout - output equivalent potential temperature
%
%     created Nov. 2004 Ryan Torn, U. Washington
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function thout = thetae(thin, tin, wsin)

load atmos_const.mat

thout = thin .* exp( (Lv_0.*wsin) ./ (Cp.*tin));
