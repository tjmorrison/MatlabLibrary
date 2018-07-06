%   File        - data path 
%   start_index - start of data load
%   end_index   - start of data load
%   height_index - tower height, 1-25.5 m, .., 6 - 0.61 m 

load('./Materhorn_data/playaSpring30minLinDetUTESpac3.mat')
fprintf('30 min Spring Playa data loaded \n')
height_index = 5; 

%filter for winddir from West to Northeast
WD = rearrangeHeights(playaSpring.spdAndDir(:,2:3:17));

WD_bool = zeros(size(WD,1),1);
cnt = 1;
for i = 1:length(WD(:,1))
    if WD(i,height_index) > 270 || WD(i,height_index) < 27
        WD_bool(i) = 1;
        WD_north(cnt) = WD(i);
        %Get vars for Northly Flow
        U_north (cnt,:) = rearrangeHeights(playaSpring.spdAndDir(i,3:3:18));
        u(cnt,:) = rearrangeHeights(playaSpring.Playa_20HZ(i,2:5:27));
        v(cnt,:) = rearrangeHeights(playaSpring.Playa_20HZ(i,3:5:28));
        w(cnt,:) = rearrangeHeights(playaSpring.Playa_20HZ(i,3:5:29));
        tke(cnt,:) = rearrangeHeights(playaSpring.tke(i,2:7));
        L(cnt,:) = rearrangeHeights(playaSpring.L(i,2:7));
        Temp(cnt,:) = rearrangeHeights(playaSpring.derivedT(i,2:4:22));
        %Saving time stamp of northerly flow vars
        t(cnt) = playaSpring.spdAndDir(i,1);
        cnt = cnt+1;
    end
end

clear playaSpring;

% Look at polar histogram of points filtered from the North
% figure()
% polarhistogram(WD_north.*(pi./180),180,'FaceColor','black')
% title('Data points filtered for Northerly Flow','Fontsize',30)

%30 min time index
t30min_index = 47;

%Velocity "keep" index for raw variables
vel_index_start = 1;
vel_index_end = 20*60*30;

path = '/Users/travismorrison/Documents/Local_Data/MATERHORN/data/tower_data/Playa_tower_raw/Raw_planar_fit/PlayaSpring_raw_GPF_LinDet_2013';
path_endings = ["_05_02","_05_04","_05_06","_05_08","_05_10","_05_12","_05_14",...
    "_05_16","_05_18","_05_20","_05_22","_05_24","_05_26","_05_28","_05_30","_06_01","_06_03","_06_05"];

file_30min_chunks = 3456000/(20*30*60);

%starts at 2 because the _05_02 data is currupt 
for i = 2:length(path_endings)-1
    %load file
    load(strcat(path,path_endings(i),'.mat'))
    
    %define index for rawFlux files
    raw_flux_indexStart = 1;
    raw_flux_indexEnd = 20*60*30;
    t20Hz_index = 1;
    
    %loop through rawFlux looking for times matching up to Northly winds
    for j = 1:file_30min_chunks
        if datevec(t(t30min_index))==floor(datevec(rawFlux.t(t20Hz_index)))
            u_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.uPF(raw_flux_indexStart:raw_flux_indexEnd,:));
            v_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.vPF(raw_flux_indexStart:raw_flux_indexEnd,:));
            w_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.wPF(raw_flux_indexStart:raw_flux_indexEnd,:));
            T_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.fwT(raw_flux_indexStart:raw_flux_indexEnd,:));
            Th_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.fwTh(raw_flux_indexStart:raw_flux_indexEnd,:));
            
            uprime_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.uPF_Prime(raw_flux_indexStart:raw_flux_indexEnd,:));
            uprime_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.uPF_Prime(raw_flux_indexStart:raw_flux_indexEnd,:));
            vprime_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.vPF_Prime(raw_flux_indexStart:raw_flux_indexEnd,:));
            wprime_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.wPF_Prime(raw_flux_indexStart:raw_flux_indexEnd,:));
            Tprime_20Hz(vel_index_start:vel_index_end,:) = rearrangeHeights(rawFlux.fwThPrime(raw_flux_indexStart:raw_flux_indexEnd,:));
            
            %incriments the index of the Northerly winds
            vel_index_start = vel_index_end+1;
            vel_index_end = vel_index_end+(20*30*60);
            t30min_index = t30min_index+1;
        end
        %inciments the raw file index
        raw_flux_indexStart = raw_flux_indexEnd+1;
        raw_flux_indexEnd = raw_flux_indexEnd+(20*30*60);
        t20Hz_index = t20Hz_index+(20*30*60);
        
    end
    Files_filtered = i
    
    clear rawFlux;
end


% Chunking our raw variables in 30 minute chunks
u_prime = reshape(uprime_20Hz,[36000,739,6]);
v_prime = reshape(vprime_20Hz,[36000,739,6]);
w_prime = reshape(wprime_20Hz,[36000,739,6]);
T_prime = reshape(Tprime_20Hz,[36000,739,6]);
T_20Hz = reshape(T_20Hz,[36000,739,6]);
Th_20Hz = reshape(Th_20Hz,[36000,739,6]);
u_20Hz = reshape(u_20Hz,[36000,739,6]);
v_20Hz = reshape(v_20Hz,[36000,739,6]);
w_20Hz = reshape(w_20Hz,[36000,739,6]);

%cleaning some space
clear uprime_20Hz vprime_20Hz wprime_20Hz Tprime_20Hz 
fprintf('turbulence variables loaded')

%Now filter for Taylors hypthesis, u_prime_U < 0.3
threshold = 0.3;
for i = 1:size(u_prime,2)
    Taylors_ratio(:,i) = sqrt((1./3).*(u_prime(:,i,5).^2+v_prime(:,i,5).^2+w_prime(:,i,2).^2))./U_north(i);
    
end

Taylors_ratio = squeeze(mean(abs(Taylors_ratio),1,'omitnan'));
%look at taylors ratio with time
% start = 150;
% figure()
% semilogy(datetime(datevec(t(start:785))),Taylors_ratio(start:end),'k*')
% hold on 
% plot(datetime(datevec(t(start:785))),linspace(0.5,0.5,(785-start+1)),'k-')
% plot(datetime(datevec(t(start:785))),linspace(0.3,0.3,(785-start+1)),'k--')
% legend('$|u^{\prime}/\bar{U}|$','0.5','0.3')
% axis tight
% ylabel('$|u^{\prime}/\bar{U}|$')
% grid on

%Filter all of the variables for Taylor's ratio > 0.3
cnt = 1;
for i = 1:size(Taylors_ratio,2)
    if Taylors_ratio(i)< threshold
        u_prime_filt(:,cnt,:) = u_prime(:,i,:);
        v_prime_filt(:,cnt,:) = v_prime(:,i,:);
        w_prime_filt(:,cnt,:) = w_prime(:,i,:);
        T_prime_filt(:,cnt,:) = T_prime(:,i,:);
        T_20Hz_filt(:,cnt,:) = T_20Hz(:,i,:);
        Th_20Hz_filt(:,cnt,:) = Th_20Hz(:,i,:);
        u_20Hz_filt(:,cnt,:) = u_20Hz(:,i,:);
        v_20Hz_filt(:,cnt,:) = v_20Hz(:,i,:);
        w_20Hz_filt(:,cnt,:) = w_20Hz(:,i,:);
        
        U_north_filt(cnt,:) = U_north(i,:);
        u_filt(cnt,:) = u(i,:);
        v_filt(cnt,:) =  v(i,:);
        w_filt(cnt,:) =  w(i,:);
        tke_filt(cnt,:) =  tke(i,:);
        L_filt(cnt,:) =  L(i,:);
        Temp_filt(cnt,:) = Temp(i,:);
        %Saving time stamp of northerly flow vars
        t_filt(cnt) =  t(i);
        cnt = cnt+1;
    end 
end
fprintf('Filtering for Taylors Hypothesis \n')
fprintf('Data Loaded')

playa_filt.Hz_20.u_prime = u_prime_filt;
playa_filt.Hz_20.v_prime = v_prime_filt;
playa_filt.Hz_20.w_prime = w_prime_filt;
playa_filt.Hz_20.u = u_20Hz_filt;
playa_filt.Hz_20.v = v_20Hz_filt;
playa_filt.Hz_20.w = w_20Hz_filt;
playa_filt.Hz_20.T_prime = T_prime_filt;
playa_filt.Hz_20.T = T_20Hz_filt;
playa_filt.Hz_20.Th = Th_20Hz_filt;

playa_filt.min_30.U = U_north_filt;
playa_filt.min_30.u = u_filt;
playa_filt.min_30.v = v_filt;
playa_filt.min_30.w = w_filt;
playa_filt.min_30.tke = tke_filt;
playa_filt.min_30.L = L_filt;
playa_filt.min_30.T = Temp_filt;
playa_filt.min_30.t = t_filt;


