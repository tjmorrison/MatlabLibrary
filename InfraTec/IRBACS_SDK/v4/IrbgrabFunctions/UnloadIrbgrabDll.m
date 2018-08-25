function Result=UnloadIrbgrabDll
Result = false;
global glbData;

if ~libisloaded ('irbgrablib')
    Result=true;
end

if exist('glbData')
    if  glbData.devHandle ~= 0
        FreeDevice;  
    end
    if  glbData.connected
        irbgrabDisconnect(glbData);
    end
end

if (libisloaded ('irbgrablib')) 
    unloadlibrary 'irbgrablib';
    disp('irbgrab_win64.dll unloaded');
end
glbData.glbConnected=false;
Result=true;


