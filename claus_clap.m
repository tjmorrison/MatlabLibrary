%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   claus_clap - function that gives the saturation vapor pressure for 
%                a given temperature based on the Clausius-Clapeyron
%                equation
%
%   esat = claus_clap(tin,ice_flg)
%
%    tin - input temperature in Kelvin
%   esat - saturation vapor pressure in Pa
%   ice_flg - if ice_flg=1, esat is w.r.t. ice for T<0C
%
%     created Feb. 2005 Ryan Torn, U. Washington
%     modified (for ice) Jul. 2009 J Minder, U. Washington
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function esat = claus_clap(tin,ice_flg)

load atmos_const.mat

esat=nan(size(tin));
if ~exist('ice_flg')|| ice_flg~=1
    esat = eo .* exp( (Lv_0 ./ Rv) * ( 1./Tfrez - 1./tin) ) *100;
elseif exist('ice_flg') && ice_flg==1
    Icld=find(tin<Tfrez);
    Iwrm=find(tin>=Tfrez);
    esat(Iwrm) = eo .* exp( (Lv_0 ./ Rv) * ( 1./Tfrez - 1./tin(Iwrm) )) *100;
    esat(Icld) = eo .* exp( (L_s ./ Rv) * ( 1./Tfrez - 1./tin(Icld) ) ) *100;    
end

% for k=1:numel(tin) 
%     if ~exist('ice_flg')|| ice_flg~=1
%         esat(k) = eo .* exp( (Lv_0 ./ Rv) * ( 1./Tfrez - 1./tin(k)) ) *100;
%     elseif exist('ice_flg') && ice_flg==1
%         if (tin(k)-Tfrez)>=0
%             esat(k) = eo .* exp( (Lv_0 ./ Rv) * ( 1./Tfrez - 1./tin(k)) ) *100;            
%         elseif (tin(k)-Tfrez)<0
%             esat(k) = eo .* exp( (L_s ./ Rv) * ( 1./Tfrez - 1./tin(k)) ) *100;            
%         end
%     end
% end