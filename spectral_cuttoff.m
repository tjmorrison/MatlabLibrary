function [x_cut, x] = spectral_cuttoff(Fs, x, lower_freq, upper_freq)

%prepare data for spectral cut off

%interpolate nans
if sum(isnan(x(:)))>0
    x(:)=inpaint_nans(x(:),0);
end

if detrend(squeeze(x)) == 0 
   
else
    x = detrend(squeeze(x));
end

dt = 1/Fs;
N = size(x,2);
dF = Fs/N;
f = (-Fs/2:dF:Fs/2-dF)';


% Band-Pass Filter:
BPF = ((lower_freq < abs(f)) & (abs(f) < upper_freq));
figure;
plot(f,BPF);

time = dt*(0:N-1)';
figure;
plot(time,x);

spektrum = fftshift(fft(x))/N;
figure;
subplot(2,1,1);
plot(f,abs(spektrum));
%apply filter
spektrum = BPF'.*spektrum;
subplot(2,1,2);
plot(f,abs(spektrum));
x_cut=ifft(ifftshift(spektrum),'symmetric')*N; %inverse ifft





%figures to see if it worked! 
figure()
title('spectras','interpreter','latex','fontsize',15)
plot(x)
hold on
plot(x_cut)
hold off
grid on
legend('orginal signal','spectral cut')
xlabel('$n$ (Hz)','interpreter','latex','fontsize',15)
ylabel('x','interpreter','latex','fontsize',15)










end