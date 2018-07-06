function [ x,fity, dydx] = nat_log_x_fit( x,y )
%see Eric Pardyjak's Numerical methods notes on logfitting 
% Written by Travis Morrison Spring 18'

%remove the Nans to perform the fit
flagy = ~isnan(y);
flagx = ~isnan(x);
x_no_nan = x(flagx & flagy);
y_no_nan = y(flagx & flagy);

N = length(y_no_nan);
xlog=log(x_no_nan);


a1 = (N*(sum(xlog.*y_no_nan,'omitnan')) - sum(xlog,'omitnan').*sum(y_no_nan,'omitnan'))./(N*sum(xlog.^2,'omitnan') - sum(xlog,'omitnan').^2);
a0 = mean(y_no_nan,'omitnan') - a1.*mean(xlog,'omitnan');


fity_no_nan = a0 + a1*xlog;
dydx_no_nan = a1./x_no_nan;

%returns an array populated with Nans where they were orginally
cnt = 1;
for i = 1:length(y)
    if ~isnan(y(i))
        fity(i) = fity_no_nan(cnt);
        dydx(i) = dydx_no_nan(cnt);
        cnt = cnt+1;
    else
        fity(i) = nan;
        dydx(i) = nan;
    end
end

end

