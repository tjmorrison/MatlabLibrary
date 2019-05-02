function [T_fluct, T_patch, T_trend, T_mean] = compute_TIR_components(T,avg_window,fluct_calc)
%Decomposes TIR time series based on method from Travis Morrison
%Method is similiar to Christen et al 2012

%T is TIR time series
%avg_window is index number relating to size of averaging chunk
%(ie data at 20hz averaged every 2 seconds will have avg_window=40)
%fuct_calc -options 'detrend' or 'Andres2012'
%Establish vars %matrix size
nx = size(T,1);
ny = size(T,2);
nt = size(T,3);


%Compute mtrend since it's math does not depend on temporal trend

num_chunks = nt/avg_window;
T_patch = zeros(nx,ny,num_chunks);
T_mean = zeros(1,num_chunks);
T_fluct = zeros(nx,ny,nt);
T_trend = zeros(1,nt);
index_start = 1;index_end = avg_window;

for i = 1:num_chunks
    %space and temporal mean
    T_mean(i) = mean(mean(mean(T(:,:,index_start:index_end),1,'omitnan'),2,'omitnan'),3,'omitnan');
    %calc patchiness
    T_patch(:,:,i) = mean(T(:,:,index_start:index_end),3,'omitnan') - T_mean(i);
    %Calc trend
    T_trend(index_start:index_end)= squeeze(mean(mean(T(:,:,index_start:index_end),1,'omitnan'),2,'omitnan')) - T_mean(i);
    %calc the fluctuations for a chunk
    switch fluct_calc
        case 'detrend'
            for x = 1:nx
                for y = 1:ny
                    T_fluct(x,y,index_start:index_end) = detrend(squeeze(T(x,y,index_start:index_end)));
                end
            end
        case 'Andres2012'
            for x = 1:nx
                for y = 1:ny
                    for t = 1:nt
                        T_fluct(x,y,t) =  squeeze(T(x,y,t))-...
                            squeeze(T_patch(x,y,i)) - squeeze(T_trend(t))-T_mean(i);
                    end
                end
            end
        case 'Calaf2019'
  
            for x = 1:nx
                for y = 1:ny
                    
                    T_fluct(x,y,index_start:index_end) =  detrend(squeeze(T(x,y,index_start:index_end)-squeeze(T_patch(x,y,i))));
                    
                end
            end
            
    end
    
    %increase index
    Percent_complete = ((i*avg_window)/nt)*100
    index_start = index_end+1;
    index_end = index_end + avg_window;
end

%Calc T_patch over whole time
%T_patch = squeeze(mean(T_patch,3));
end
