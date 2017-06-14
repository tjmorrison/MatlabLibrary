function [freq,avgPDens,avgPDens_sig]=compute_spectra(var1,var2,Fs)


Ntotal=length(var1);

fluct_var1 = detrend(var1);
fluct_var2 = detrend(var2);

% figure()
% plot(fluct_var1)

%interpolate nans
if sum(isnan(fluct_var1(:)))>0
    fluct_var1(:)=inpaint_nans(fluct_var1(:),0);
end
if sum(isnan(fluct_var2(:)))>0
    fluct_var2(:)=inpaint_nans(fluct_var2(:),0);
end

filt_var1=fluct_var1(:);
filt_var2=fluct_var2(:);

%We compute the Variance directly from the Time series data. Two
%Methodologies, the MatLab "var" function, or the direct definition of
%Variance. Both produce the same result, as one would expect.
tmp=nancov(filt_var1,filt_var2);
Covariance1 = tmp(1,2);


%Computing the Fourier Transform and the Power Spectral Density:
N = length(filt_var1);
xdft1 = fft(filt_var1);
xdft2 = fft(filt_var2);

xdft=real(xdft1.*conj(xdft2));
psdx = (1/(Fs*N)) *xdft(1:N/2+1);
psdx(2:end-1) = 2*psdx(2:end-1);

freq = transpose(0:Fs/length(filt_var1):Fs/2);

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
