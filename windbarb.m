function [h_barb_handles,brbindx] = windbarbm(uin,vin,lat,lon,scale,units);
%
% [h_barb_handles,brbindx] = windbarbm(u,v,lat,lon,scale,units);
%
% plot_windbarb takes u,v components of the windfield
% and plots them as standard meteorological wind-barbs.
% Scale adjusts the size(s) of the barbs while lat determines
% if the barbs are clockwise (northern hemisphere) or
% anti-clockwise pointing.
%
% input:
% uin, vin - grid relative u and v components.
% lat,lon - the latitude, longitude (or x,y) coordinates of the u,v data.
% scale - the length in centimeters that the barb should be on the page.
% [default = 1].
% units - 'kt' or 'ms' units of u,v. Program assumes the standard
% 5|10|50 knot speeds for half|full|flag feathers. If the data
% are in m/s it multiplies them by 2 to get barbs that conform
% to the 2.5|5|25 m/s standard. [default = 'kt'];
%
% output:
% h_barb_handles the handles to the patch objects plotted.
% brbindx the indices for the u,v obs that are actually plotted
% (NaNs, if there are any, are removed before plotting)
%

% james foster 17 July 2003
% Modified Ryan Torn, UW, 9 December 2004

if nargin < 6 | isempty(units)
     units = 'kt';
end

if nargin < 5 | isempty(scale)
     scale = 1; % default scale = 1 cm.
end

% define default dimensions for the barb * feather components:
shaft_length = 1;
half_length = .2;
full_length = .4;
flag_length = .4;
feather_ang = 30.*pi./180;
feather_sep = sin(feather_ang).*flag_length; % defined so that the base of a 
                                             % flag is exactly one separation wide.

% first check the vectors and remove any NaN observations:
allindx = 1:length(uin);
nanindx = find(isnan(uin+vin+lat+lon));
%display(nanindx)
brbindx = setxor(allindx,nanindx);
%u(nanindx)=[];
%v(nanindx)=[];
%lat(nanindx)=[];
%lon(nanindx)=[];

% test the axes properties to find out what the scaling is so that
% we can plot 1 cm:
oldunits = get(gca,'Units');
set(gca,'Units','centimeters');
cmposn = get(gca,'Position');
set(gca,'Units',oldunits);

xcmrange = cmposn(3);
ycmrange = cmposn(4);

% get the Xlims and Ylims so that we can define coordinates in proper
% units:
xlims = get(gca,'XLim');
ylims = get(gca,'YLim');

xrange = diff(xlims); yrange = diff(ylims);
xscale = (xrange./xcmrange);
yscale = (yrange./ycmrange);

% use this scalings to form a scale matrix that will convert a unit vector
% into one that is "scale" centimeters long when plotted in these axes:

scalemat = scale.*[xscale 0;0 yscale];

% too tricky to make the call as a matrix/vector. Swallow it and do a loop:
nbarbs = length(uin(:));

for ibarb = 1:nbarbs

   barb_patch=[];
   flag_patch=[];
   full_patch=[];
   half_patch=[];

   % First work out what combination
   % of flag/full/half feathers are needed to represent the speed

   speed = sqrt(uin(ibarb).^2 + vin(ibarb).^2);
   if strmatch(units,'ms')
     speed = 2.*speed;
   end;

   [nflag,nfull,nhalf] = speed2feathers(speed);

   wuvec=-[uin(ibarb) vin(ibarb)] ./ speed;
   flv = [(-wuvec(2)) wuvec(1)] .* sign(-lat(ibarb));

   % now trace out the whole barb as a patch object making sure to
   % catch the special cases:

   if nflag+nfull+nhalf == 0 % no feathers:
     % just plot a point:
     barb_patch = [0.00001 0];
     %disp(['Barb #',int2str(ibarb),': (rounded) speed = 0: simply drawing a point']);
   elseif nhalf==1 & nflag+nfull==0 % only a 5 m/s feather:
     % place the half-feather in the second feather spot, not at the end:
     barb_patch = [0  0
                   (wuvec * shaft_length)
		   (wuvec * (shaft_length-feather_sep))
		   (wuvec * (shaft_length-feather_sep) + flv * half_length)
		   (wuvec * (shaft_length-feather_sep))];
     %disp(['Barb #',int2str(ibarb),': (rounded) speed = 5; drawing half-feather in from the end']);
   else % all other cases:
     shaft_lengthl = shaft_length  + nflag * feather_sep / shaft_length;  

     ifeather = 0;
     barb_patch = [0 0; wuvec]*shaft_lengthl;
     %disp(['Barb #',int2str(ibarb),': (rounded) speed = ',int2str(speed(ibarb))]);
     for iflag = 1:nflag
       flag_patch = [0 0
                    (flv*flag_length + feather_sep * wuvec / 2)
                    (wuvec*feather_sep)] + ...     
                    repmat(wuvec,3,1) * (shaft_lengthl-ifeather.*feather_sep);
       barb_patch = [barb_patch;flag_patch];
       ifeather=ifeather+1;
       %disp([' ',int2str(ifeather),': drawing a 50 m/s flag']);
     end;
     for ifull = 1:nfull
       full_patch = [0 0; flv; 0 0] *full_length + ...
       repmat(wuvec,3,1) * (shaft_lengthl-ifeather.*feather_sep);
       barb_patch = [barb_patch;full_patch];
       ifeather=ifeather+1;
       %disp([' ',int2str(ifeather),': drawing a 10 m/s feather']);
     end;
     if nhalf == 1
       half_patch = [0 0; flv; 0 0] *half_length + ...
       repmat(wuvec,3,1) * (shaft_lengthl-ifeather.*feather_sep);
       barb_patch = [barb_patch;half_patch];
       ifeather=ifeather+1;
       %disp([' ',int2str(ifeather),': drawing a 5 m/s feather']);
     end;
   end;

   % tack on a final closing vertex:
   barb_patch = [barb_patch;0 0];

   % check how many vertices we have
   [nverts,ndims]=size(barb_patch);
   %disp([' We have ',int2str(nverts),' vertices for the final barb patch']);

   % should now have a patch in cart-xy of unit length and with correct
   % direction. Need scale it up so that it is "scale" centimeters long
   % in the current axes and to move it to the correct lat lon point:

   barb_patch_lonlat = barb_patch*scalemat + repmat([lon(ibarb) lat(ibarb)],nverts,1);
   %disp([' Scaled and translated the patch to be ',num2str(scale),' cm long and rooted at correct location']);

   h_temp = patch(barb_patch_lonlat(:,1),barb_patch_lonlat(:,2),[0 0 0]);
   
   h_barb_handles(ibarb)=h_temp;
    
end;
