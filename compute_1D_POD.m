function [ phiU,lam,vecU ] = compute_1D_POD( var,figure)
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
switch figure
    case 'on'
        figure(1)
        subplot(5,2,1)
        plot(phiU(:,1),'k-')
        title('Mode 1', 'interpreter','latex')
        
        subplot(5,2,2)
        plot(phiU(:,2),'k-')
        title('Mode 2', 'interpreter','latex')
        
        
        subplot(5,2,3)
        plot(phiU(:,3),'k-')
        title('Mode 3', 'interpreter','latex')
        
        subplot(5,2,4)
        plot(phiU(:,4),'k-')
        title('Mode 4', 'interpreter','latex')
        
        subplot(5,2,5)
        plot(phiU(:,5),'k-')
        title('Mode 5', 'interpreter','latex')
        
        subplot(5,2,6)
        plot(phiU(:,6),'k-')
        title('Mode 6', 'interpreter','latex')
        
        subplot(5,2,7)
        plot(phiU(:,7),'k-')
        title('Mode 7', 'interpreter','latex')
        
        subplot(5,2,8)
        plot(phiU(:,8),'k-')
        title('Mode 8', 'interpreter','latex')
        
        subplot(5,2,9)
        plot(phiU(:,9),'k-')
        title('Mode 9', 'interpreter','latex')
        
        subplot(5,2,10)
        plot(phiU(:,10),'k-')
        title('Mode 10', 'interpreter','latex')
        
        savefig('POD_modes')
        saveas(gcf,'POD_modes.png')
close all;
        
        figure()
        semilogx(lam(1:end))
        ylabel('$\lambda$','interpreter','latex','fontsize',20)
        xlabel('n','interpreter','latex','fontsize',20)
        savefig('lambda')
        saveas(gcf,'lamda.png')
        
        figure()
        semilogx(lam(1:end)./sum(lam(1:end)),'k:o')
        ylabel('$\lambda / \sum{\lambda}$','interpreter','latex','fontsize',20)
        xlabel('n','interpreter','latex','fontsize',20)
        savefig('norm_lambda')
        saveas(gcf,'norm_lamda.png')
        
    case 'off'
end


end



