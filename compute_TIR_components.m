function [T_fluct, T_patch, T_mean] = compute_TIR_components(T,avg_window)
%make sure num_chunks is 
nt = size(T,3);
num_chunks = nt/avg_window;

index_start = 1;index_end = avg_window;
for i = 1:num_chunks
    T_mean = mean(mean(mean(T(:,:,index_start:index_end),1),2),3);

    index_start = index_end+1;
    index_end = index_en
end



end
