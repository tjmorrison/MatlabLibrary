%--------------------------------------------------------------------------
%                       SKEWT_OWLES.M
%--------------------------------------------------------------------------
% Leah Campbell

% uses skewt_plot.m, created by Ryan Torn, U. Washington
%     
% Uses the following functions and scripts:
% atmos_const.mat
% claus_clap.m
% satur_mix_ratio.m
% skewt.m
% thetae.m
% windbarb.m
% temp_to_theta.m
% speed2feathers.m
% 

close all
clear all

skewtname='20131207_2015UTC.northredfield_sounding.txt';
filename='20131207_2015UTC.northredfield_sounding.txt';
% this info is for saving the file at the end
%location = 'North Redfield';
%iop = 'IOP1';
% location of skewt text file
%filename=['/uufs/chpc.utah.edu/common/home/steenburgh-group3/owles/soundings/north-redfield/smoothed_data/' iop '/' skewtname ];

% elevation of launch site
isselev=385;
% define temp range for x axis
    temprange=[-30 5];
% define pressure range for y axis    
    plow=1000;
    phigh=400;
% not sure what these do but I'm afraid to mess with them.
    slab=0;
    titlestr=' ';
    BWoC=1;
    a=1;
% define fontsize for labels    
    fontsize = 14;
    
year = skewtname(1:4);
month = skewtname(5:6);
day = skewtname(7:8);
hour = skewtname(10:11);
min = skewtname(12:13);
sec = skewtname(14:15);

Lv = 2.257e6;  % latent heat of vaporization
L0 = 2.69e6; % J/kg latent heat of vaporization, optimum constant value
R = 287.04; % J/(kgK) gas constant for dry air
cp = 1005.7; % J/(kgK) specific heat of dry air at constant pressure
g = 9.81; % m/s^2gravity
epsilon = 6.11; % R/Rv unitless

%--------------------------------------------------------------------------   
% read in data from textfile

fname=strcat('filename');

ndata=importdata(filename);
ndata=ndata.data;

 ptmp=ndata(:,2); % hPa                   
tair=ndata(:,3); % degrees C
rh=ndata(:,4); % relative humidity
tdew=ndata(:,13); % dewpoint
ghght=ndata(:,10)+isselev; % geopotential height
altitude = ndata(:,9) + isselev; % altitude above sea level
pwnd=ptmp; % pressure for use plotting wind barbs
wdir=ndata(:,6);
wspd=ndata(:,5); % m/s

load atmos_const.mat

if ~exist('BWoC')
    BWoC=0;
end

%titlestr=num2str(BWoC);

trange = -150:5:60;
plim = phigh:10:plow;

% calculate temperature, mixing ratio and potential temperature values
for ii = 1:length(trange) ; for jj = 1:length(plim)
  tax(ii,jj) = skewt(trange(ii), plim(jj));
  tplot(ii,jj) = trange(ii);
  pax(ii,jj) = plim(jj);
end; end;
ptemp = temp_to_theta(tplot + 273.15, pax*100);
wsat = satur_mix_ratio(claus_clap(tplot + 273.15), pax*100) * 1e3;
thtae = thetae(ptemp, tplot+273.15, wsat * 0.001);



%--------------------------------------------------------------------------
%                   PLOT 
%---------------------------------------------------------------------------

% set up whole figure;
f=figure(a);
  width =6.5;
  height=6.5; 
  set(gcf, 'PaperUnits', 'inches'); 
        set(gcf, 'PaperSize', [8.5 11]);
        papersize = get(gcf, 'PaperSize');
        set(gcf, 'PaperPositionMode', 'manual');                                      
        left = (papersize(1)- width)/2;
        bottom = (papersize(2)- height)/2;
        set(gcf, 'PaperPosition', [left bottom width height]);
  set(gcf,'Position',[1 1 1000 500])
set(gcf,'color','w');

% All these calculations are to plot the crazy lines on the skewt axis
hbig=axes;

% plot solid lines for specific pressure values
ccolor=[0 0 0];
presplot = [100 150 200:100:1000];
for ii = 1:length(presplot)
  plot([trange(1) trange(end)],[presplot(ii) presplot(ii)],...
           '-','color',ccolor,'linewidth',1);
  hold on;
end;

% plot the temperature lines
if BWoC==1
    ccolor=[1 0.5 0];
    %ccolor=[1 1 1].*0.2;
else
    ccolor=[1 0.5 0];
end
[c h]=contour(tax,pax,tplot,-150:10:50,'-'); hold on;
set(gca,'ydir','reverse','yscale','log');
set(h,'color',ccolor);
if slab ==1
  h=clabel(c,h,'labelspacing',1000,'fontsize',fontsize,'fontname','times',...
          'color',ccolor,'fontweight','bold','rotation',45);
end;

% plot the potential temperature values
if BWoC==1
    ccolor=[0 0 1];
    %ccolor=[1 1 1].*0.7;
else
    ccolor=[0 0 1];
end
[c h]=contour(tax,pax,ptemp,200:20:500,'-'); hold on;
set(h,'color',ccolor,'linewidth',1);
if slab==1
  h=clabel(c,h,'labelspacing',1000,'fontsize',fontsize,'fontname','helvetica',...
          'color',ccolor,'fontweight','bold');
end;

% plot the saturation water vapor mixing ratio values
if BWoC==1
    ccolor=[0 1 0];
    wscont=[0.1 0.2:0.2:1 1.5:0.5:3 4:10 12:2:20 24:8:56];
    %ccolor=[1 1 1].*0.001;
    %wscont=[0.4:0.8:3.2 4:2:20 24:4:60];
else
    ccolor=[0 1 0];
    wscont=[0.1 0.2:0.2:1 1.5:0.5:3 4:10 12:2:20 24:8:56];
end

[c h]=contour(tax,pax,wsat,wscont,':'); hold on;
set(h,'color',ccolor);
if slab==1
  h=clabel(c,h,'labelspacing',1000,'fontsize',fontsize,'fontname','helvetica',...
          'color',ccolor,'fontweight','bold');
end;

% plot the thetae values
if BWoC==1
    ccolor=[1 0 1];
    %ccolor=[1 1 1].*0.2;
else
    ccolor=[1 0 1];
end
[c h]=contour(tax,pax,thtae,200:20:500,'-k'); hold on;
set(h,'color',ccolor,'LineWidth',1);
%set(h,'color',ccolor);
if slab==1
  h=clabel(c,h,'labelspacing',1000,'fontsize',fontsize,'fontname','helvetica',...
          'color',ccolor,'fontweight','bold');
end;

% scale the plot to the appropriate size
set(gca,'xlim',temprange,'ylim',[phigh plow],'fontname','helvetica','fontsize',fontsize,...
        'xtick',[-30 -20 -10 0],'ytick',[phigh:100:plow],'yminortick','off');
 xl = get(gca,'xlim'); yl = get(gca,'ylim');
 xpos = get(gca,'position');
 set(gca,'position',[xpos(1:2) (xpos(3)-0.1) xpos(4)]); 

% plot the temperature and dew point profile
a=plot(skewt(tair, ptmp), ptmp, 'linewidth', 3, 'Color','r');%[1 1 1].*0.001);
b=plot(skewt(tdew, ptmp), ptmp,'--' ,'linewidth', 3, 'Color','k');%[1 1 1].*0.001);

titlestr = [ hour min ' UTC,' month '-' day '-' year];


% add the text to the plot
xlabel('Temperature (\circC)','fontname','helvetica','fontsize',fontsize);
ylabel('Pressure (hPa)','fontname','helvetica','fontsize',fontsize);
ht=title({location,titlestr},'fontname','helvetica','fontsize',fontsize);
set(ht,'Interpreter','none');
hl=legend([a,b,gcf],'Temperature','Dewpoint','location','northeast');
set(hl,'fontname','helvetica','fontsize',fontsize);

% create another axes to be used for plotting winds

axes('position',[xpos(4) xpos(2) 0.1 xpos(4)]); axis off;
mw = 1 ./ (log(yl(1)) - log(yl(2)));
bw = - mw * log(yl(1)) + 1;
set(gca,'xlim',[-1 1],'ylim',[0 1],'xtick',[],'ytick',[],...
    'xcolor',[1 1 1],'ycolor',[1 1 1],'color','w');

% plot each wind barb at the correct location
load atmos_const.mat;



for j = 1:length(wspd)
    if wspd(j) < 2.5
        wspd(j) = 2.5;
    end
end

for ii = 1:55:length(pwnd)
    if ~isnan(wdir(ii)+wspd(ii))
        vpt = mw * log(pwnd(ii)) + bw;

        uin = wspd(ii) .* cos(pid .* (90.+wdir(ii)));
        vin = -wspd(ii) .* sin(pid .* (90.+wdir(ii)));
        h=windbarb(uin,vin,vpt,0,1.5,'ms');
        set(h,'linewidth',1)
    end
end
 


% save fig
%saveas(gcf,filename='/uufs/chpc.utah.edu/common/home/u0198116/Desktop/Class_radiosonde/skewt.eps','epsc')


