function Result=InitEnvironment

global glbData;

glbData=struct( 'initEnv',false, 'demoWorkDir',pwd,'irbgrabHeader',pwd, ...
                'irbgrabDllDir',pwd,'deviceId',0, 'devHandle',0, ...
                'deviceCount',0,'connected',false, 'stopPollingReq', false, ...
                'pollingActive', false, 'grabType', 0, 'frameWidth', 0, ...
                'frameHeight', 0, 'framePixType', 0, 'buffer', 0, ...
                'frameCount', 0, 'frameCountOld', 0, 'frameRate', 0, ...
                'hImage', 0, 'visDelayToc', 0, 'triggerCnt', 0);

%add path to irbgrab_win64.dll 
glbData.demoWorkDir=pwd;
relPath=['..', filesep];
cd(relPath);
glbData.irbgrabDllDir=pwd;
addpath(glbData.irbgrabDllDir);
cd(glbData.demoWorkDir);

%add path to Irbgrabfunctions
cd('IrbgrabFunctions'); 
addpath(pwd);
glbData.irbgrabHeader=[pwd,filesep,'Matlab_compatible_IrbGrab.h'];
cd(glbData.demoWorkDir);

%add path to constants
cd('IrbGrabConstants'); 
addpath(pwd);
%generate constants in folder IrbGrabConstants
InitConstants;
cd(glbData.demoWorkDir);

glbData.initEnv = true;






