function Result=ConnectDevice
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

retval=irbg_dev_connect( glbData.devHandle );
if retval ~= IRBG_RET_OK
    disp(['connect device failed (Result=0x',sprintf('%x',retval),')']);
    disp(['connect device:', ErrorCodeToString(retval)]);
    return 
end

glbData.connected = true;
Result=true;

