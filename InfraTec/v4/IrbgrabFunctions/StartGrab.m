function Result=StartGrab(hObject, handles)
global glbData;
Result=false;

glbData.frameWidth    = 0;
glbData.frameHeight   = 0;
glbData.framePixType  = 0;
glbData.frameCount    = 0;
glbData.frameRate     = 0;
glbData.frameCountOld = 0;
glbData.triggerCnt    = 0;

if ~glbData.connected
    disp('Error. Device is not connected.');
    Result=false;
    return
end

%Since it is not possible to pass function pointers of a shared library to
%Matlab, grabbing by Callback routine (OnNewFrame etc.) is not available.
%There is no other way then polling for new frames Matlab. For that reason
%an internal Callback-routine in irbgrab.dll have to be used. Before we
%start grabbing we have to prepare it

%Prepare variable for callback function pointer
CBfuncptr = uint64(0);
pCBfuncptr = libpointer( 'uint64Ptr', CBfuncptr);

%Get function pointer to internal CB-function 
retval=irbg_dll_pollframefuncptr( pCBfuncptr );
if retval ~= IRBG_RET_OK
    disp(['irbgrab_dll_pollframefuncptr failed (Result=0x',sprintf('%x',retval),')']);
    disp(['irbgrab_dll_pollframefuncptr: ', ErrorCodeToString(retval)]);
    return 
end

%Set OnNewFrame-CB to internal CB-function 
CBData = libstruct( 'TIRBG_CallBack') ;
CBData.FuncPtr=pCBfuncptr.Value;
CBData.Context=0;

paramWhat=uint32(IRBG_PARAM_OnNewFrame);
paramType=uint32(IRBG_DATATYPE_CALLBACK);

if ~SetParamStruct( glbData.devHandle, paramWhat, CBData, paramType );
    return 
end


retval=irbg_dev_startgrab(glbData.devHandle);
if retval ~= IRBG_RET_OK
    disp(['irbgrab_dev_startgrab failed (Result=0x',sprintf('%x',retval),')']);
    disp(['irbgrab_dev_startgrab: ', ErrorCodeToString(retval)]);
    return 
end

Result=true;

