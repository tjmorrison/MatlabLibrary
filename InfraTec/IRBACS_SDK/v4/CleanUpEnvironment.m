function [] = CleanUpEnvironment

global glbData;

if exist('glbData.devHandle')
    if glbData.devHandle ~= 0
        FreeDevice;  
    end
end

if libisloaded ('irbgrablib')
    UnloadIrbgrabDll;
end

if glbData.initEnv
    %remove path to irbgrab.dll 
    rmpath(glbData.irbgrabDllDir);
    cd(glbData.demoWorkDir);

    %remove path to constants
    cd('IrbGrabConstants'); 
    rmpath(pwd);
    cd(glbData.demoWorkDir);

    %add path to Irbgrabfunctions
    cd('IrbgrabFunctions'); 
    rmpath(pwd);
    cd(glbData.demoWorkDir);
end;

% in case of errors "fclose all" can be very useful
% if this code is integrated in greater projects, then better comment this out 
fclose all;

clear glbData;









