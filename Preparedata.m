function [data] = Preparedata(file,start_index,end_index,freq,...
    WD_max,WD_min,ratio_fluct_mean,height_index)

%   File        - data path 
%   start_index - start of data load
%   end_index   - start of data load
%   height_index - tower height, 1-25.5 m, .., 6 - 0.61 m 

load('./Materhorn_data/playaSpring30minLinDetUTESpac3.mat')
fprintf('30 min Spring Playa data loaded \n')
height_index = 5; 
%filter for winddir
WD = rearrangeHeights(playaSpring.spdAndDir(:,2:3:17));
WD_bool = zeros(size(WD,1),1);

for i = 1:length(WD(:,1))
    if WD(i,height_index) > 270 && WD(i,height_index) < 27
        WD_bool(i,z) = 1;
    end
end






end