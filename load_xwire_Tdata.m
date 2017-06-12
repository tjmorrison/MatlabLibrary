function [T_bot,T_top] = load_xwire_Tdata(path)

%add path
addpath(path);

%allocate memory
T_bot = zeros(1,54000000);
T_top = zeros(1,54000000);

%Indexes
TIR_offset = 675000;
N = 10*60*15000;
index_start = 1;
index_end = N - TIR_offset + index_start;

%load first file
fID = fopen('Bottom_T_cs43.bin');
temp = fread(fID,'float');
T_bot(1,index_start:index_end) = condition_data(detrend(temp(TIR_offset:end,1)));
fclose(fID);

fID = fopen('Top_T_cs43.bin');
temp = fread(fID,'float');
T_top(1,index_start:index_end) = condition_data(detrend(temp(TIR_offset:end,1)));
fclose(fID);

%load remaining hour
index_start = index_end + 1;
index_end = index_end + N ;
for i = 44:48
    file = strcat('Bottom_T_cs', num2str(i),'.bin');
    fID = fopen(file);
    temp = fread(fID,'float');
    T_bot(1,index_start:index_end) = condition_data(detrend(temp'));
    fclose(fID);
    index_start = index_end+1;
    index_end = index_end + N ;
end

fID = fopen('Bottom_T_cs48.bin');
temp = fread(fID,'float');
T_bot(1,index_start:end) =condition_data(detrend(temp(1:TIR_offset-1,1)));
fclose(fID);


index_start = N - TIR_offset + 2;
index_end = index_start + N -1;
for i = 44:48
    file = strcat('Top_T_cs', num2str(i),'.bin');
    fID = fopen(file);
    temp = fread(fID,'float');
    T_top(1,index_start:index_end) = condition_data(detrend(temp'));
    fclose(fID);
    index_start = index_end+1;
    index_end = index_end + N ;
end

%load last chunk of data
fID = fopen('Top_T_cs48.bin');
temp = fread(fID,'float');
T_top(1,index_start:end) = condition_data(detrend(temp(1:TIR_offset-1,1)));
fclose(fID);
end
