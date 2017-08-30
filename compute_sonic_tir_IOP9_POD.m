function [ tower_phi, tower_lam, TIR_phi, TIR_lam ] = compute_sonic_tir_IOP9_POD()
%Compute pod
clear; clc; close all;

machine = 'imac_local';
%add paths
switch machine
    case 'imac_local'
        %code
        addpath('/Users/travismorrison/Documents/Code/functions_library');
        %data path
        data_path ='/Users/travismorrison/Local_Data/MATERHORN/data/';
        addpath(data_path); 
    case 'imac_Achilles'
        %code
        addpath('/Users/travismorrison/Documents/Code/functions_library');
        %data path
        data_path ='/Volumes/ACHILLES/MATERHORN/data/';
        addpath(data_path); 
    case 'linux'
        %code
        addpath('/home/tjmorrison/Research/function_library');
        %data path
        data_path = addpath('/media/tjmorrison/ACHILLES/MATERHORN/data');
end
% Plot xire and TIR Spectras
ft_size = 25;
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultTextInterpreter','latex'); 
set(0,'DefaultAxesFontSize',ft_size); 
% Load tower data
load(strcat(data_path,'tower_data/Playa_tower_raw/PlayaSpring_raw_GPF_LinDet_2013_05_24.mat'));
IOP9_start = 3236840;
IOP9_end = IOP9_start+(20*60*60); 
Temp= rearrangeHeights(detrend(inpaint_nans(rawFlux.sonTs(IOP9_start:IOP9_end,:))));
clear rawFlux;
tower.num_z = 6; 

% Load TIR filtered and detrended data
load('/Users/travismorrison/Documents/Code/TIR_xwire_spectral_analysis/IOP9_60minDetrend_1HzFilter.mat')
TIR.nx = size(T_prime_cut,1);
TIR.ny = size(T_prime_cut,2);
TIR.freq = 20;
%
fprintf('Data Loaded \n');

tower.T = [];
% spectral cut off to 1Hz
tower.Fs = 20;
TIR.T = [];
 
for z = 1:tower.num_z
    [tower.T_filt(:,z)] = spectral_cuttoff(tower.Fs,Temp(:,z)', 0 ,1);
    tower.T = [tower.T;tower.T_filt(:,z)];
    TIR.T = [TIR.T;squeeze(T_prime_cut(1+z*6,1+z*6,:))];
end

rmfield(tower,'T_filt');
%clear T_prime_cut;

% build matrix for sonic POD 
%clear w_POD; clear T_POD;
Nperiod = tower.Fs*60*60; %Nperiod
samp_interval = 60;

T = tower.T(1:samp_interval:end);
TC = TIR.T(1:samp_interval:end);

cnt = 1;
length = Nperiod/samp_interval;
shift = 1;
for Nsnap = 1:((size(T,1)-length)/shift)
    T_POD(Nsnap,:) = T(cnt:cnt + length-1);
    TIR_POD(Nsnap,:) = TC(cnt:cnt + length-1);
    cnt = cnt + shift ;
end

fprint('POD Matrix Built \n')

clear TC; clear T;
%
[ tower_phi(:,:),tower_lam(:) ] = compute_1D_POD( T_POD(:,:)','off');
[ TIR_phi(:,:),TIR_lam(:) ] = compute_1D_POD( squeeze(TIR_POD(:,:))','off');
fprintf('POD complete \n')

end

