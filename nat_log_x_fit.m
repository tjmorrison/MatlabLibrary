function [ x,fity, dydx,a1,a0 ] = nat_log_x_fit( x,y )
%see Eric Pardyjak's Numerical methods notes on logfitting 
% Written by Travis Morrison Spring 18'
flagy = ~isnan(y);
flagx = ~isnan(x);
x = x(flagx & flagy);
y = y(flagx & flagy);

N = length(x);
logy = log(y);
xlogy = x.*logy;
x2 = x.^2;



a1 = (N.*(sum(xlogy,'omitnan')) - (sum(x,'omitnan').*sum(logy,'omitnan')))./(N.*(sum(x2,'omitnan')) - sum(x,'omitnan').^2);
a0 = mean(logy,'omitnan') - (a1.*mean(x,'omitnan'));

a = exp(a0);
b = a1;

fity = a.*exp(b.*x);
dydx = a.*b.*exp(b.*x);

end

