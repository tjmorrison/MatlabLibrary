function [ phiU, lam ] = compute_POD( M )
% Compute POD using traditional method for POD

nsnap = size(M,1)
nperiod = size(M,2)

%compute correlation matric
CU = M'*M; 
fprintf('Correlation matrix \n')

% Calculate the POD basis - the eigenvectors are not yet the POD basis, but are
% orthogonal 
[vecU,valU] = eig(CU); %produces a diagonal matrix D of eigenvalues and 
                        % a full matrix V whose columns are the corresponding
                        %eigenvectors so that A*V = V*D.

fprintf('Eigenstuff \n')
%project the POD basis 
phi = vecU;

% Normalize the POD basis
for i=1:nperiod
    phi_norm(:,i) = phi(:,i)/norm(phi(:,i),2);
end

lam = diag(valU);

% Rearrange POD eigenvalues, vectors in descending order.
lam = rot90(lam,2);
lam(end)=0;

phiU = fliplr(phi); % Now our POD basis is in the matrix PhiU, and has dim N
%NsnapxNperiod, where Nperiod is the mode index (1200 modes)

end 




