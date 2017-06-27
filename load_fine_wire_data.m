function [] = load_fine_wire_data(path)

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


end
