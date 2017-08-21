function [  ] = compute_1D_wavelet( var ,Dt, Wlet_type, figure_opt)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%figure() %In case we want to plot, a 'running' plot at each gate distance.

    p = (nextpow2(length(var)))+1;
    scales = 2.^(1:p);  %The number of scales is 'for us' given by the 
                        %length of the signal, since we want the points to
                        %be equidistant, in order to have an homogeneous
                        %representation of the spectra over all the
                        %frequencies.
                        
    freq = scal2frq(scales,Wlet_type,Dt); %Computes the "Pseudo-frequency" associated
                                     %with each Wavelet at each scale.

    %------------------------------------
    %Padding the Signal, avoids end/border effects:
    diff = (2^p)-length(var);
    tmpU = padarray(var,[0 floor(diff/2)],'pre');
    tmpdiff = diff - floor(diff/2);
    tmpU = padarray(tmpU,[0 tmpdiff],'post');
    %------------------------------------
    
    %Computing the Wavelet of the actual signal.
    coefs = cwt(tmpU,scales,Wlet_type);
    Energy = (abs(coefs)).^2;
    tmpSpectra = (mean(Energy,2));
    
    %Grouping all the transforms along the different gates in a single
    %Variable.
    
    for j = 1:length(tmpSpectra)
        Spectra(j) = tmpSpectra(j);
        MSpectra(j) = freq(j)*tmpSpectra(j);
    end
    
    %IN case we want to plot, a 'running' plot at each gate distance.
    switch figure_opt
        case 'on'
            figure()
            semilogx(freq,freq'.*tmpSpectra,'-k')
            ylabel('E$f$','interpreter','latex','fontsize',20)
            xlabel('$f (Hz)$','interpreter','latex','fontsize',20)
            hold on;
            pause;
        case 'off' 
            %do nothing            
    end
    
    

%Spectra in a log-log plot:
%---------------------------------------
avgSpectra = squeeze(mean(Spectra,1));

figure()
loglog(freq,avgSpectra,'-k')

f = 0.0007:0.001:0.06; %We add the k^-1 section.
%f = 0.01:0.001:0.06; %We add the k^-1 section.
hold on;loglog(f,0.0074*(f.^(-1)),'-b')

ff = 0.05:0.01:0.25;  %We add the k^-(5/3) section.
hold on;loglog(ff,0.001*(ff.^(-5/3)),'-r')
ylabel('$|Y(f)|$','Interpreter','latex','fontsize',14,'FontName','Arial');
xlabel('$f\,[Hz]$','Interpreter','latex','fontsize',14,'FontName','Arial');

%Premultiplied Spectra in a semilogx plot:
%------------------------------------------

figure()
semilogx(freq,freq.*avgSpectra,'-k')
ylabel('$f\cdot|Y(f)|$','Interpreter','latex','fontsize',14,'FontName','Arial');
xlabel('$f\,[Hz]$','Interpreter','latex','fontsize',14,'FontName','Arial');


% Plotting the same spectra in Wavenumbers:
% %------------------------------------------
% Z = 15;
% meanU = mean(Umean(30:40));
% wnum = (2*pi/meanU)*freq;
% xAx = wnum*Z;
% 
% %Downstream check of the inclination of the beam:
% gate = 30; %The good spectra was obtained betw. gates 30 and 40.
% theta_shift = 2; %[deg]
% Zshift = (gate*18)*sin(theta_shift*(pi/180))
% 
% 
% figure()
% loglog(xAx,avgSpectra,'-k')
% ylabel('$E_{u}(k)$','Interpreter','latex','fontsize',14,'FontName','Arial');
% xlabel('$kz$','Interpreter','latex','fontsize',14,'FontName','Arial');
% 
% wnum_1 = (2*pi/meanU)*f*Z;
% wnum_2 = (2*pi/meanU)*ff*Z;
% 
% hold on;loglog(wnum_1,0.0074*(f.^(-1)),'-b')
% hold on;loglog(wnum_2,0.001*(ff.^(-5/3)),'-r')
% 
% line([1 1], [0.01 100],'LineStyle','--','color','k','LineWidth',1)
% line([0.015 0.015], [0.01 100],'LineStyle','--','color','k','LineWidth',1)


end

