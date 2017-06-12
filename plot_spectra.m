function [] = plot_spectra(freq,spectra,xmax,xmin,ymax,ymin)

if nargin < 3
    figure()
    loglog(freq,spectra)
    grid on 
end

if nargin < 6 && nargin > 2 
    axis([xmin xmax ymin ymax])
end

    