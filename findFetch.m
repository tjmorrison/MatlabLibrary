function data = findFetch(data)
clc
%      beach, shrimp, sub
allL = [-1 0 1]; % offshore

all_z0 = [10e-3 10e-3 10e-3]; % offshore

% initiate output
fetch = nan(size(allL));

zm = 2; %m
k = 0.4; %von Karmen constant
zLimit = 0.1; % stability divider
Fstar = 0.9; % flux fraction

for ii = 1:numel(allL)
    L = allL(ii);
    z0 = all_z0(ii);
    
    if zm/L < -zLimit % unstable
        D = 0.28; p = 0.59;
    elseif zm/L > zLimit % stable
        D = 2.44; p = 1.33;
    else
        D = 0.91; p = 1; % neutral
    end
    
    % find
    zu = zm*(log(zm/z0) - 1 + z0/zm);
    
    % find the 90% fetch
    fetch(ii) = -D*zu.^p*abs(L)^(1-p) / (k^2 * log(Fstar));
    x_footprint2 = -((D.*zu.^p).*abs(L).^(1-p))./(log(Fstar)*k^2)

    % Eric's 
    %x = abs(L)*(-(D*zu./abs(L)).^P)/(log(fluxfract)*k^2);
end