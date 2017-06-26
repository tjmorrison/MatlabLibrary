function [ phiU,lam ] = compute_1D_POD( var)
% METHOD OF SNAPSHOTS
% calculate the empirical correlation matrix C
nx = size(var,1);
nsnap = size(var,2);
U= reshape(var,nx,nsnap);


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

phiU = reshape(fliplr(phi(1:nx,:)),nx,nsnap);

% Plotting the results
figure()
%set(h, 'Visible', 'off')
for i = 1:10
    plot(phiU(:,i)); 
    %shading interp;
    pause(1)
    savefig(strcat('POD_mode',num2str(i),'.fig'))

end

figure()
semilogx(lam(1:end))
ylabel('$\lambda$','interpreter','latex','fontsize',20)
xlabel('n','interpreter','latex','fontsize',20)
savefig('lambda.fig')

figure()
semilogx(lam(1:end)./sum(lam(1:end)))
ylabel('$\lambda / \sum{\lambda}$','interpreter','latex','fontsize',20)
xlabel('n','interpreter','latex','fontsize',20)
savefig('norm_lambda.fig')

end



