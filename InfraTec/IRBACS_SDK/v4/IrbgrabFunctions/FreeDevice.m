function Result=FreeDevice
global glbData;

Result=false;
if ~libisloaded ('irbgrablib')
    disp('Error. IRBgrab Library is not loaded.');
    return
end

if exist('glbData')
    if glbData.devHandle == 0
      Result=true;
      return;  
    end
    if glbData.connected 
        Result=DisconnectDevice;
    end
end

retval=irbg_dev_free( glbData.devHandle );
if retval ~= IRBG_RET_OK 
    disp(['Error. FreeDevice failed (Result=0x',int2str( dec2hex(retval,8)),')']);
    disp(['Free device: ', ErrorCodeToString(retval)]);
    return 
end

glbData.devHandle = 0; 

Result=true;
