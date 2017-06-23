function [ u_rec ] = reconstruct_2D_POD( u, phiU,n_modes)

%preparing data
[nx,ny,n_snap]=size(u);
fprintf('Begin POD Reconstruction \n')

phiU(:,:,n_snap) = 0;

%%
coeff = zeros(n_snap, n_snap, n_modes);
for index_snap = 1:n_snap
    temp = zeros(nx,ny,n_snap);
    for index_modes=1:n_modes 
        temp(:,:,index_modes) = u(:,:,index_snap).*phiU(:,:,index_modes);
        coeff(index_snap,index_snap,index_modes) = trapz(trapz(temp(:,:,index_modes)));
    end
end

fprintf('Coefficients calculated \n')


%% Velocity field reconstruction

u_rec = zeros(nx,ny,n_snap);
temp = zeros(nx,ny,n_snap); 

for index_snap = 1:n_snap
    for index_modes = 1:n_modes
        temp(:,:,index_modes)  = coeff(index_snap,index_snap,index_modes)*phiU(:,:,index_modes);
    end
    u_rec(:,:,index_snap) = sum(temp,3);
    if mod(n_snap,10)==0
        fprintf('recomposed percentage complete \n')
        Percent = (index_snap/n_snap)*100
    end
end

end
