function [ tke_sgs, u_star_sgs , tke_resolved, u_star_resolved, q_sgs, q_resolved] = compute_sgs_tke( Umean, u, v ,w,T )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%u = 20Hz data for 30 min
%Umean = 30min avg wind speed

freq = 20; 
[ u_avg_sgs, filter_size,psedo_space ] = Taylors_filter( Umean, u' , freq );
[ v_avg_sgs, filter_size,psedo_space ] = Taylors_filter( Umean, v', freq );
[ w_avg_sgs, filter_size,psedo_space ] = Taylors_filter( Umean,w' , freq );
[ T_avg_sgs, filter_size,psedo_space ] = Taylors_filter( Umean,T' , freq );


N_sgs = length(u_avg_sgs);
N = length(u);
if mod(N-N_sgs,2) == 0
    n_remove_start = ((N-N_sgs)/2)+1;
    n_remove_end = (N-N_sgs)/2;
else 
    n_remove_start = (floor(N-N_sgs)/2);
    n_remove_end = (floor(N-N_sgs)/2)+1;
end

u_prime_sgs = u(n_remove_start:end-n_remove_end) - u_avg_sgs;
v_prime_sgs = v(n_remove_start:end-n_remove_end) - v_avg_sgs;
w_prime_sgs = w(n_remove_start:end-n_remove_end) - w_avg_sgs;
T_prime_sgs = T(n_remove_start:end-n_remove_end) - T_avg_sgs;

q_sgs = w_prime_sgs.*T_prime_sgs;
q_resolved = detrend(w_avg_sgs).*detrend(T_avg_sgs);
%q_resolved = w_avg_sgs.*T_avg_sgs;


tke_sgs = 0.5.*sqrt(u_prime_sgs.^2 + v_prime_sgs.^2 + w_prime_sgs.^2); 
tke_resolved = 0.5.*sqrt(detrend(u_avg_sgs).^2 + detrend(v_avg_sgs).^2 + detrend(w_avg_sgs).^2); 

tau_sgs = sqrt((u_prime_sgs.*w_prime_sgs).^2 + (v_prime_sgs.*w_prime_sgs).^2);
u_star_sgs = sqrt(tau_sgs);

tau_resolved = sqrt((detrend(u_avg_sgs).*detrend(w_avg_sgs)).^2 +...
    (detrend(v_avg_sgs).*detrend(w_avg_sgs)).^2);
u_star_resolved = sqrt(tau_resolved);
end 

