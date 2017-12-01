%Script to load IOP10 data into workable matrices
clear;
camera_freq = 20; %[Hz]
chunk_time = 8.3333e-04;%1/240;%5; %[minutes] length of saved matrices 
total_time = 1/240;%5; %[minutes] total length of all the saved chunks added together
nx = 256;
ny = 320;
chunk_frames = chunk_time*camera_freq*60; 
start_frame = 100000; %beginning of workable data from IOP10, time of day?
end_frame = start_frame + (total_time*camera_freq*60);
data_path = 'E:\FLIR_IOP10\1\';
%%
%preallocate saved matrix
data = zeros(nx,ny,chunk_frames);
save_data = zeros(nx-52,ny,chunk_frames);
for num_frame = start_frame:end_frame
    mat_file = strcat('IMGF',num2str(start_frame));
    load(strcat(data_path,mat_file,'.MAT'));
    data(:,:,num_frame-start_frame+1) = eval(sprintf(mat_file));
    if mod(num_frame,)
    if mod(num_frame,chunk_time) == 0
        fpintf(strcat('frames complete',num2str(num_frame)))
        %trim horizen
        save_data = flip(data(52:end,:,:));
        save(strcat('IOP10',num2str(num_frame-chunk_frame),'_',num2str(num_frame)),save_data)
    end
    
end
%%
setpref('Internet','E_mail','tjmorrison635@gmail.com');
sendmail('tjmorrison635@gmail.com','Loading IOP10 complete');
