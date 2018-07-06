function [ Pr_t_neutral, Pr_t ] = Compute_Prt_Spectral_approach( Rg, zeta , z)
%Compute the turbulent Pr number using Gaby's formulation 
%Katul et al 2014 for neutral cases 
%Li et al 2015 for unstable cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List of Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rg- Flux gradient Richardson Number
% zeta - stability (z/L)
% zi - boundary layer depth [m]
% z - instrument height [m]
% S - vertical gradient of the mean wind (dU/dz)
% Gamma - vertical gradient of the temperature (dT/dz)

% Other constants in the theory
% C_IT,C_IU - Rotta constants (3/5)
% C_O = 0.65, C_T = 0.8, C_K = 1.5 - Kolmogorov and
% Kolmogorov-Obukvov-Corrsin Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate the Pr number based on Katul et al 14', Eqn. 37
%where omega1 = (1-C_IT)^-1(C_T/C_O)~3, and omega2 = omega1+1 ~4
omega2 = 4;
Pr_t_neutral = (2*Rg)./(1+omega2.*Rg-sqrt(-4*Rg+(-1-omega2*Rg).^2));

%now compute the adjusted Pr# for non stable cases
C_IU = 3/5; C_IT = 3/5;C_T = 0.8;C_O = 0.65; %isotropzation constants (3/5)
A_U =1.8; A_T = 1.8; %Rotta constants [Pope 2000]
A_UU =0.99; A_TT=0.99; %AUU and ATT are model constants associated with
                        %the flux transfer terms. ).99 is used to create
                        %the ratio of 0.55 for ATT/AT and AUU/AU, (See
                        %Fig. 7)

D3 = (A_T/A_TT) + (5/3);

% Define wave number ranges, for now they are set equal (See Fig. 4)
K_a_T = 1/z; K_a_w = 1/z;
K_delta_T = K_a_T; K_delta_w = K_a_w; %-5/3 scaling begins


% Handle free convection case (FTT has different scaling, see Fig.1 from Li
% et al. 15)
if (zeta <= 0) %arbitary values (z/L->-inf)
    alpha1 =0; alpha2=5/3.*(1-exp(5.*zeta));alpha3=5/3;
    gamma1 =0; gamma2=2/3.*(1-exp(5.*zeta));gamma3=5/3;
else % handle other scaling (Fww and FTT has similiar scaling)
    alpha1 =0; alpha2=0;alpha3=5/3;
    gamma1 =0; gamma2=1;gamma3=5/3;
end


g1 =(((-alpha1-(2/3)+D3).*(-alpha1+(1/3))).^(-1).*K_delta_w.^(-alpha2+(1/3)).*K_a_w.^(alpha2-alpha3))+...
    (((-alpha2-(2/3)+D3).*(-alpha2+(1/3))).^(-1).*(K_a_w.^(-alpha3+(1/3))-(K_delta_w.^(-alpha2+(1/3)).*K_a_w.^(alpha2-alpha3))))+...
    (((-alpha3-(2/3)+D3).*(-alpha3+(1/3))).^(-1).*(-K_a_w.^(-alpha3+(1/3))));

g2 =(((-gamma1-(2/3)+D3).*(-gamma1+(1/3))).^(-1).*K_delta_T.^(-gamma2+(1/3)).*K_a_T.^(gamma2-gamma3))+...
    (((-gamma2-(2/3)+D3).*(-gamma2+(1/3))).^(-1).*(K_a_T.^(-gamma3+(1/3))-(K_delta_T.^(-gamma2+(1/3)).*K_a_T.^(gamma2-gamma3))))+...
    (((-gamma3-(2/3)+D3).*(-gamma3+(1/3))).^(-1).*(-K_a_T.^(-gamma3+(1/3))));

%Compute omega1
omega1 = (1/(1-C_IT))*(C_T/C_O)*(g2/g1) ;

%compute the stability correction function from Businger-Dyer 1971
gamma1_stab = 15; %Garratt [1992] Appendix 4, Hogstrom 1988     
beta1M =4.7;                  
if (zeta <= 0)
    x = (1-gamma1_stab.*zeta).^(1/4);
    psi_m = 2.*log((1+x)./2) + log((1+x.^2)/2)-2.*atan(x)+pi./2;    
elseif zeta>0
    psi_m = -beta1M.*zeta;
end

Pr_t = Pr_t_neutral.*(1-(omega1*(zeta./(psi_m-zeta)))).^(-1);
end

