function [ T_prime ] = compute_T_prime( T )
%computes T_prime, where T_prime is passed a TIR data set and each pixel is
%detrended in the time dimension, where T is T(x,y,t).
nx = size(T,1);
ny = size(T,2);
nt = size(T,3);
T_prime = zeros(nx,ny,nt);
for x = 1:nx
    for y =1:ny
        T_prime(x,y,:) = detrend(squeeze(T(x,y,:)));
    end
     if mod(x,10) == 0
        T_prime_percent_complete = ((x*y)/(nx*ny))*100
    end
end


end

