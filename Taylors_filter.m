function [ varFilt, filter_size,psedo_space ] = Taylors_filter( Umean, x, freq )
%Written by Travis Morrison 2-16-18

%Umean is the mean wind speed 
%freq is the frequency of the data to apply the filter
%avr is the tubulence variable to apply the filter


turbo_var_length = size(x,1);
npoints = size(Umean,1);
chunk = freq*60*30; %in frames
les_grid_size = 10; %[m]

t = (Umean./les_grid_size).^(-1);
filter_size = t.*freq; %[npoints for flux data]
taylors_window = chunk; %[npoints = to length of application of taylors hypothesis]


tmp =  turbo_var_length-sum(floor(filter_size)) - npoints;

varFilt = zeros(1,tmp);


start_index = 1;
nchunks = floor(size(x,1)./36000);
for i = 1:nchunks
    end_index = floor(start_index + filter_size(i));
    for j = 1:taylors_window-filter_size(i)
        
        %since we need theta for the finite difference in height
        varFilt(start_index) = squeeze(mean(x(start_index:end_index),'omitnan')); %this solves for the grid resolved
        
        start_index = start_index+1;
        end_index = end_index+1;
    end
    if mod(i,1)==0
        chunk_num = i
    end
end


psedo_space = zeros(1,turbo_var_length);
start_i = 1;
end_i = 20*30*60;
tmp = 0;
for i = 1:npoints-1
    psedo_space(start_i:end_i) = linspace(tmp,((20*30*60*10)/filter_size(i))+tmp,(20*30*60));
    tmp = psedo_space(end_i);
    start_i = end_i+1;
    end_i = end_i+(20*30*60);
end

end

