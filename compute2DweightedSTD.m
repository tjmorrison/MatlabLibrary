function [ weighted_std ] = compute2DweightedSTD( X, w, nx,ny )
%X - var to compute the STD of
%w = weighting variable
%nx = number in x
%ny = number in y

N = nx*ny;

%pixel_area = ones(size(index_x,2),size(index_y,2));
A_tot = sum(sum(abs(w)));
tot = 0;
for ii = 1:nx
    for jj = 1:ny
       tot = tot + (X(ii,jj).*abs(w(ii,jj)));
    end
end
weight_avg = tot/A_tot;

tot = 0;
for ii = 1:nx
    for jj = 1:ny
        tot = tot + (abs(w(ii,jj)).*((X(ii,jj)-weight_avg).^2));
    end
end

weighted_std = sqrt(tot/(((N-1)/N).*A_tot));

end

