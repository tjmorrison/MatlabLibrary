function [ phi,lam ] = compute_1D_POD( var)
% METHOD OF SNAPSHOTS
% calculate the empirical correlation matrix C
nsnap = length(var);
U = var;


CU = U'*U/nsnap;
fprintf('Correlation matrix \n')

% Calculate the POD basis
[vecU,valU] = eig(CU);
fprintf('Eigenstuff \n')
phi = U * vecU;

% Normalize the POD basis
for i=1:nsnap
    phi(:,i) = phi(i)/norm(phi(i),2);
end

lam = diag(valU);

% Rearrange POD eigenvalues, vectors in descending order.
lam = rot90(lam,2);
lam(end)=0;


% Plotting the results
figure()
for i = 1:10
    plot(phi(:,i)); 
    pause(1)
    savefig(strcat('POD_mode',num2str(i),'.fig'))

end

figure()
semilogx(lam(2:end))
ylabel('$\lambda$','interpreter','latex','fontsize',20)
xlabel('n','interpreter','latex','fontsize',20)
savefig('lambda.fig')

end


