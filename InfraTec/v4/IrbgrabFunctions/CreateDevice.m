function Result=CreateDevice
global glbData;

Result=false;

if glbData.devHandle ~= 0
  FreeDevice;  
end

if ~libisloaded ('irbgrablib')
    disp('Error. IRBgrab Library is not loaded.');
    return
end

%Prepare variable for device handle
DevHandle = uint64(0);
pDevHandle = libpointer( 'uint64Ptr', DevHandle) ;

retval=irbg_dev_create( pDevHandle, glbData.deviceId );
if retval ~= IRBG_RET_OK 
    disp(['create device failed (Result=0x',int2str( dec2hex(retval,8)),')']);
    disp(['Create device: ', ErrorCodeToString(retval)]);    
    return 
end

glbData.devHandle = pDevHandle.Value;
Result=true;

