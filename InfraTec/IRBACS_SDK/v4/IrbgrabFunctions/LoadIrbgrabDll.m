function Result=LoadIrbgrabDll
Result = false ;
global glbData;
if libisloaded ('irbgrablib')
    UnloadIrbgrabDll;
end

if( exist(glbData.irbgrabDllDir,'dir') ~= 7 )
    disp('Error: directory %s not found', glbData.irbgrabDllDir)
    return;
end
if( exist(glbData.irbgrabHeader,'file') ~=2 )
    disp('Error: file %s not found', glbData.irbgrabHeader)
    return;
end

glbData.irbgrabDll = [glbData.irbgrabDllDir,filesep,'irbgrab_win64.dll'];
res = exist(glbData.irbgrabDll,'file') ;
if( res ~=2 )
    disp('Error: file %s not found', glbData.irbgrabDll)
    return;
end

loadlibrary(glbData.irbgrabDll, glbData.irbgrabHeader, 'alias' ,'irbgrablib' );

if libisloaded ('irbgrablib')
    if irbg_dll_init == IRBG_RET_OK
        Result = true;
        disp('irbgrab_win64.dll loaded')
    else
        Result = false;        
        disp('irbgrab_win64.dll loaded, but irbgrab_dll_init failed.');
        unloadlibrary 'irbgrablib';
    end
    %drawnow
    %cd(glbData.irbgrabDllDir);
    % get handle of calling MS Windows application 
end






