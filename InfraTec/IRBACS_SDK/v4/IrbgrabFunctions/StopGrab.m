function Result=StopGrab
global glbData;
Result=false;

if ~glbData.connected
    disp('Error. Device is not connected.');
    Result=false;
    return
end

%For StopGrab everything should be done reverse order. First StopGrab, then
%set OnNewFrame-CB to null

retval=irbg_dev_stopgrab(glbData.devHandle);
if retval ~= IRBG_RET_OK
    disp(['irbgrab_dev_stopgrab failed (Result=0x',sprintf('%x',retval),')']);
    disp(['irbgrab_dev_stopgrab: ', ErrorCodeToString(retval)]);
    return 
end

%Prepare variable with null pointer for callback function pointer
CBfuncptr = uint64(0);
pCBfuncptr = libpointer( 'uint64Ptr', CBfuncptr);

%Set OnNewFrame-CB to internal CB-function 
CBData = libstruct( 'TIRBG_CallBack') ;
CBData.FuncPtr=pCBfuncptr.Value;
CBData.Context=0;

paramWhat=uint32(IRBG_PARAM_OnNewFrame);
paramType=uint32(IRBG_DATATYPE_CALLBACK);

if ~SetParamStruct( glbData.devHandle, paramWhat, CBData, paramType );
    return 
end

glbData.startgrab = false;
Result=true;

