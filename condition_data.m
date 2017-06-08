function [x_cond] = condition_data(x) 
% Condition data based on Stull pg 310
N = length(x);
ten_percent = ceil(N/10);
nintey_percent = ceil((9/10)*N);

for i = 1:ten_percent
    x_cond(i) = sin((5.*pi.*x(i))./N).^2;
end

x_cond((ten_percent+1):(nintey_percent-1)) = x((ten_percent+1):(nintey_percent-1));

for i = nintey_percent:N
    x_cond(i) = sin((5.*pi.*x(i))./N).^2;
end
