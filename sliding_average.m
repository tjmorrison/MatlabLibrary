function [ x_avg ] = sliding_average( x, freq, avg_period)
%Function computes sliding average of window size equal to avg period
% x = signal
% freq = data frequency
% avg_period = length of averaging period in seconds

N = length(x);
x_avg = zeros(N-(avg_period*freq)+1,1);
end_ii = avg_period*freq;
for ii = 1:(N-(avg_period*freq-1))
    x_avg(ii) = mean(x(ii:end_ii),'omitnan');
    end_ii = end_ii+1;
end


end

