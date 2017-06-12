function [u_bot,u_top] = load_xwire_udata(path)

%add path
addpath(path);

%allocate memory
u_bot = zeros(1,54000000);
u_top = zeros(1,54000000);

%Indexes
TIR_offset = 675000;
N = 10*60*15000;
index_start = 1;
index_end = N - TIR_offset + index_start;

%load first file
fID = fopen('U2_mean43.bin');
temp = fread(fID,'float');
u_bot(1,index_start:index_end) = temp(TIR_offset:end,1);
fclose(fID);

fID = fopen('U_mean43.bin');
temp = fread(fID,'float');
u_top(1,index_start:index_end) = temp(TIR_offset:end,1);
fclose(fID);

%load remaining hour
index_start = index_end + 1;
index_end = index_end + N ;
for i = 44:48
    file = strcat('U2_mean', num2str(i),'.bin');
    fID = fopen(file);
    temp = fread(fID,'float');
    u_bot(1,index_start:index_end) = temp';
    fclose(fID);
    index_start = index_end+1;
    index_end = index_end + N ;
end

fID = fopen('U2_mean48.bin');
temp = fread(fID,'float');
u_bot(1,index_start:end) = temp(1:TIR_offset-1,1);
fclose(fID);


index_start = N - TIR_offset + 2;
index_end = index_start + N -1;
for i = 44:48
    file = strcat('U_mean', num2str(i),'.bin');
    fID = fopen(file);
    temp = fread(fID,'float');
    u_top(1,index_start:index_end) = temp';
    fclose(fID);
    index_start = index_end+1;
    index_end = index_end + N ;
end
%load last chunk of data
fID = fopen('U_mean48.bin');
temp = fread(fID,'float');
u_top(1,index_start:end) = temp(1:TIR_offset-1,1);
fclose(fID);
end

