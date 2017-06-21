function [ output_args ] = compute_2D_POD( var,nx,ny,nsnap )
% METHOD OF SNAPSHOTS
% calculate the empirical correlation matrix C
U = [reshape(var,nx*ny)];


CU = U'*U/nsnap;
fprintf('Correlation matrix \n')

% Calculate the POD basis
[vecU,valU] = eig(CU);
fprintf('Eigenstuff \n')
phi = U * vecU;

% Normalize the POD basis
for i=1:nsnap
    phi(:,i) = phi(:,i)/norm(phi(:,i),2);
end

lam = diag(valU);

% Rearrange POD eigenvalues, vectors in descending order.
lam = rot90(lam,2);
lam(end)=0;

phiU = reshape(fliplr(phi(1:nx*ny,:)),nx,ny,nsnap);

end

