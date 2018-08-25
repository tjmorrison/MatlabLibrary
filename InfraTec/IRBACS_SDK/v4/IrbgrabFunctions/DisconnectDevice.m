function Result=DisconnectDevice
global glbData;
Result=false;

if ~libisloaded ('irbgrablib')
    disp('Error. IRBgrab Library is not loaded.');
    Result=false;
    return
end

if glbData.devHandle == 0
    disp('Error. Device is not created.');
    Result=false;
    return
end

if ~glbData.connected
    Result = true;
    return
end

retval=irbg_dev_disconnect( glbData.devHandle );
if retval ~= IRBG_RET_OK
    disp(['disconnect device failed (Result=0x',sprintf('%x',retval),')']);
    disp(['disconnect device:', ErrorCodeToString(retval)]);
    return 
end
glbData.connected=false;

Result=true;

