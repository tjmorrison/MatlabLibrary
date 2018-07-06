function Result=SetParamStruct( handle, what, dataPtr, dataType)
global glbData;
Result=false;

if ~glbData.connected
    disp('Error. Device is not connected.');
    Result=false;
    return
end

%For structure data no generation of pointer is necessary
retval=irbg_dev_setparam( handle, what, dataPtr, dataType );
if retval ~= IRBG_RET_OK
    disp(['SetParam  failed (Result=0x',sprintf('%x',retval),')']);
    disp(['SetParam: ', ErrorCodeToString(retval)]);
    return 
end

Result=true;

