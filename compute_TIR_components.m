function [T_fluct, T_patch, T_trend, T_mean] = compute_TIR_components(T,avg_window)
%make sure num_chunks is 

%Establish vars 

%matrix size
nx = size(T,1);
ny = size(T,2);
nt = size(T,3);
%T_fluct
T_fluct = zeros(nx,ny,nt);
%n_tot = nt*ny*nx;
%T_vector = reshape(T, [1,n_tot]); 


%Compute mtrend since it's math does not depend on temporal trend
T_trend = squeeze(mean(mean(T,1),2));

num_chunks = nt/avg_window;
T_patch = zeros(nx,ny,num_chunks);
index_start = 1;index_end = avg_window;
for i = 1:num_chunks
    %space and temporal mean
    T_mean = mean(mean(mean(T(:,:,index_start:index_end),1),2),3);
    %calc patchiness
    T_patch(:,:,i) = mean(T(:,:,index_start:index_end),3);
    %calc the fluctuations for a chunk
    for j = index_start:index_end
        T_fluct(:,:,j) = T(:,:,j) - T_patch(:,:,i) - T_trend(j) + (T_mean); 
    end
    %increase index
 
    Percent_complete = ((i*avg_window)/nt)*100
    index_start = index_end+1;
    index_end = index_end + avg_window;
end

%Calc T_patch over whole time
T_patch = squeeze(mean(T_patch,3));


end
