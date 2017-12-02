%Script to load IOP10 data into workable matrices
clear; clc;
camera_freq = 20; %[Hz]
chunk_time = .5; %[minutes] length of saved matrices 
total_time = 5; %[minutes] total length of all the saved chunks added together
nx = 256;
ny = 320;
chunk_frames = round(chunk_time*camera_freq*60); 
start_frame = 100000; %beginning of workable data from IOP10, time of day?
end_frame = start_frame + (total_time*camera_freq*60);
data_path = 'E:\FLIR_IOP10\1\';
%
%preallocate saved matrix
data = zeros(nx,ny,chunk_frames);
nx_useful = nx-52; %trims the horizen
save_data = zeros(nx_useful,ny,chunk_frames);

for num_frame = start_frame:end_frame
    mat_file = strcat('IMGF',num2str(num_frame));
    load(strcat(data_path,mat_file,'.MAT'));
    data(:,:,num_frame-start_frame+1) = eval(sprintf(mat_file));
    
    %print frames 
    if mod(num_frame,200) == 0
        completed_frames = num_frame-start_frame
    end
    %save data every chunk times
    if mod((num_frame-start_frame),chunk_frames) == 0 && num_frame ~= start_frame
        %fprintf('here')
        %trim horizen
        save_data = flip(data(52:end,:,:));
        save_name = strcat('IOP10_frames',num2str(num_frame-chunk_frames),'_',num2str(num_frame));
        save(sprintf(save_name),'save_data','-v7.3')
        %clear loaded 
       
    end
     clearvars -except chunk_frames chunk_time num_frame start_frame data data_path end_frame
end

fprintf('Loading data complete')