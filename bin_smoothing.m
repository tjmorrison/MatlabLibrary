function [midpoints, y_bin ] = bin_smoothing(x,y,num_bins)

N = length(y);

%create bins
edges = logspace(log(x(2,1)),log(x(end,1)),num_bins);

%get midpoints of bin (x axis)
midpoints = zeros(1,num_bins-1);
midpoints(1) = edges(1,1)/2;

for i = 2:num_bins-1
    midpoints(i) = ((edges(1,i) - edges(1,i+1))/2) + edges(1,i);
end

N_per_bin = histcounts(x,edges);
y_bin = zeros(num_bins-1,1);
cnt = 1; 
for i = 1:num_bins-1
    if N_per_bin(i) == 0
        %do nothing
        y_bin(i) = 0;
    else
        y_bin(i) = mean(y(cnt:(cnt+N_per_bin(i)),1));
    end
    cnt = cnt + N_per_bin(i);
end
 y_bin = transpose(y_bin);

end