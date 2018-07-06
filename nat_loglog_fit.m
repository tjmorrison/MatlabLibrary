function [ fity, a0,a1, dxdy ] = nat_loglog_fit( x,y )
%Should switch to base 10....
%see Eric Pardyjak's Numerical methods notes on logfitting 
% Written by Travis Morrison Spring 18'
N = length(x);
logx = log(x);
logy = log(y);
logxy = logx.*logy;
logx2 = logx.^2;
%a1 = (N.*sum(x.*y) - sum(x).*sum(y))./(N.*sum(x.^2) - sum(x).^2);
a1 = (N.*(sum(logxy)) - sum(logx).*sum(logy))./(N.*(sum(logx2)) - sum(logx).^2);
a0 = mean(logy) - a1.*mean(logx);

a = exp(a0);
b = a1;

fity = a.*x.^b;

end

