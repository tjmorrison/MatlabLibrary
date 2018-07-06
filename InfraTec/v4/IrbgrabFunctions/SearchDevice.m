function Result=SearchDevice
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

%Prepare variable for device count
DevCount = uint64(0);
pDevCount = libpointer( 'uint32Ptr', DevCount);

retval=irbg_dev_search( glbData.devHandle, pDevCount );
if retval ~= IRBG_RET_OK
    disp(['search device failed (Result=0x',sprintf('%x',retval),')']);
    disp(['search device:', ErrorCodeToString(retval)]);
    return 
end

glbData.devDeviceCount = pDevCount.Value;

Result=true;

