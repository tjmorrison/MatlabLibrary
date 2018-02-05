function [data] = Preparedata(file,start_index,end_index,freq,...
    WD_max,WD_min,ratio_fluct_mean,height_index)

%   File        - data path 
%   start_index - start of data load
%   end_index   - start of data load
%   height_index - tower height, 1-25.5 m, .., 6 - 0.61 m 

load('./Materhorn_data/playaSpring30minLinDetUTESpac3.mat')
fprintf('30 min Spring Playa data loaded \n')
height_index = 5; 

%filter for winddir from West to Northeast
WD = rearrangeHeights(playaSpring.spdAndDir(:,2:3:17));
%Vars from UtesPac 
U_mean = rearrangeHeights(playaSpring.spdAndDir(:,3:3:18));
u = rearrangeHeights(playaSpring.Playa_20HZ(:,2:5:27));
v = rearrangeHeights(playaSpring.Playa_20HZ(:,3:5:28));
w = rearrangeHeights(playaSpring.Playa_20HZ(:,3:5:29));
tke = rearrangeHeights(playaSpring.tke(:,2:7));
L = rearrangeHeights(playaSpring.L(:,2:7));

WD_bool = zeros(size(WD,1),1);
cnt = 1;
for i = 1:length(WD(:,1))
    if WD(i,height_index) > 270 || WD(i,height_index) < 27
        WD_bool(i) = 1;
        WD_north(cnt) = WD(i);
        %Get vars for Northly Flow
        U_north (cnt) = U_mean(i);
        U_mean = rearrangeHeights(playaSpring.spdAndDir(:,3:3:18));
        u = rearrangeHeights(playaSpring.Playa_20HZ(:,2:5:27));
        v = rearrangeHeights(playaSpring.Playa_20HZ(:,3:5:28));
        w = rearrangeHeights(playaSpring.Playa_20HZ(:,3:5:29));
        tke = rearrangeHeights(playaSpring.tke(:,2:7));
        L = rearrangeHeights(playaSpring.L(:,2:7));
        
        %Saving time stamp of northerly flow vars
        t(cnt) = playaSpring.spdAndDir(i,1);
        cnt = cnt+1;
    end
end

% Look at polar histogram of points filtered from the North
% figure()
% polarhistogram(WD_north.*(pi./180),180,'FaceColor','black')
% title('Data points filtered for Northerly Flow','Fontsize',30)


clear WD; 







end