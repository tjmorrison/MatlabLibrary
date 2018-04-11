function [ Pr_t_neutral, Pr_t ] = Compute_Prt( Rg, zeta )
%Compute the turbulent Pr number using Gaby's formulation 
%Katul et al 2014 for neutral cases 
%Li et al 2015 for unstable cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List of Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rg- Flux gradient Richardson Number
% zeta - stability


% Other constants in the theory
% C_IT,C_IU - Rotta constants (3/5)
% C_O = 0.65, C_T = 0.8, C_K = 1.5 - Kolmogorov and
% Kolmogorov-Obukvov-Corrsin Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate the Pr number based on Katul et al 14', Eqn. 37
%where omega1 = (1-C_IT)^-1(C_T/C_O)~3, and omega2 = omega1+1 ~4
omega2 = 4;
Pr_t_neutral = (2*Rg)./(1+omega2.*Rg-sqrt(-4*Rg+(-1-omega2*Rg)^2));

%now compute the adjusted Pr# for non stable cases
C_IU = 3/5; C_IT = 3/5;
D1 = (A_U/AUU)+(5/3);
D2 = -(1-C_IU).*(S/A_UU.*epsilon.^(1/3));
D3 = (A_T/A_TT) + (5/3);


g1 =;
g2 =;

%Compute omega1
C_IT = 3/5;
C_T = 0.8;
C_O = 0.65;
omega1 = (1/(1-C_IT))*(C_T/C_O)*(g2/g1) ;

%compute the stability correction function from Businger-Dyer 1971
gamma1 = 15; %Garratt [1992] Appendix 4, Hogstrom 1988
gamma2 = 9;      
beta1M =4.7;                  
if (zeta <= 0)
    x = (1-gamma1.*zeta).^(1/4);
    psi_m = 2.*log((1+x)./2) + log((1+x.^2)/2)-2.*atan(x)+pi./2;    
elseif zeta>0
    psi_m = -beta1M.*zeta;
end

Pr_t = Pr_t_neutral.*(1-(omega1*(zeta./(psi_m-zeta)))).^(-1);
end

