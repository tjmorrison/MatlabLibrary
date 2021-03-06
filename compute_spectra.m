function [freq,avgPDens,avgPDens_sig]=compute_spectra(var1,var2,Fs)


%interpolate nans
if sum(isnan(var1(:)))>0
    var1(:)=inpaint_nans(var1(:),0);
end
if sum(isnan(var2(:)))>0
    var2(:)=inpaint_nans(var2(:),0);
end

%Ntotal=length(var1);
if detrend(squeeze(var1)) == 0 
    fluct_var1 = var1;
else
    fluct_var1 = detrend(squeeze(var1));
end

if detrend(squeeze(var2)) == 0 
    fluct_var2 = var2;
else
    fluct_var2 = detrend(squeeze(var2));
end


% figure()
% plot(squeeze(fluct_var1))
% hold on
% plot(squeeze(fluct_var2))
% 

%We compute the Variance directly from the Time series data. Two
%Methodologies, the MatLab "var" function, or the direct definition of
%Variance. Both produce the same result, as one would expect.
tmp=nancov(fluct_var1,fluct_var2);
Covariance1 = tmp(1,2);


%Computing the Fourier Transform and the Power Spectral Density:
N = length(fluct_var1);
xdft1 = fft(fluct_var1);
xdft2 = fft(fluct_var2);

xdft=real(xdft1.*conj(xdft2));
psdx = (1/(Fs*N)) *xdft(1:N/2+1);
psdx(2:end-1) = 2*psdx(2:end-1);

freq = 0:Fs/length(fluct_var1):Fs/2;

%Compute the Variance integrating the spectra
Covariance2 = trapz(freq',psdx); %(We multiply by two because I only integrate half the length of the FFT)


%Collocate the FFT in a new vector that keeps track of the gate-range.
%PDens1 = zeros(length(psdx));
%PDens2 = zeros(length(psdx));




avgPDens = psdx;
avgPDens_sig=mean(psdx./Covariance1);




%compute binned average
% x_axis=freq;
% xbin=logspace(log10(x_axis(2)),log10(x_axis(end)),binNum);xbin= [0 xbin];
% y_axis=avgPDens;
% [xx1,yy1] = histcounts(y_axis,xbin);
% 


%axis([-inf inf 0 10])


%plot binned spectra
% figure()
% loglog(xx1,yy1)
% xlabel('$f$ $(Hz)$','interpreter','latex','fontsize',30)
% ylabel('$E$','interpreter','latex','fontsize',30)


end
