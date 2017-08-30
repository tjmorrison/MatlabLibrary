function [ tower_phi, tower_lam, tower_EigenVec, TIR_phi, TIR_lam, TIR_EigenVec ] = compute_sonic_tir_IOP9_POD(tower,T_prime_cut)

tower.T = [];
% spectral cut off to 1Hz
tower.Fs = 20;
TIR.T = [];
 
for z = 1:tower.num_z
    [tower.T_filt(:,z)] = spectral_cuttoff(tower.Fs,Temp(:,z)', 0 ,1);
    tower.T = [tower.T;tower.T_filt(:,z)];
    TIR.T = [TIR.T;squeeze(T_prime_cut(1+z*6,1+z*6,:))];
end

rmfield(tower,'T_filt');
%clear T_prime_cut;

% build matrix for sonic POD 
%clear w_POD; clear T_POD;
Nperiod = tower.Fs*60*60; %Nperiod
samp_interval = 60;

T = tower.T(1:samp_interval:end);
TC = TIR.T(1:samp_interval:end);

cnt = 1;
length = Nperiod/samp_interval;
shift = 1;
for Nsnap = 1:((size(T,1)-length)/shift)
    T_POD(Nsnap,:) = T(cnt:cnt + length-1);
    TIR_POD(Nsnap,:) = TC(cnt:cnt + length-1);
    cnt = cnt + shift ;
end

fprintf('POD Matrix Built \n')

clear TC; clear T;
%
[ tower_phi(:,:),tower_lam(:),tower_EigenVec ] = compute_1D_POD( T_POD(:,:)','off');
[ TIR_phi(:,:),TIR_lam(:),TIR_EigenVec ] = compute_1D_POD( squeeze(TIR_POD(:,:))','off');
fprintf('POD complete \n')

end

