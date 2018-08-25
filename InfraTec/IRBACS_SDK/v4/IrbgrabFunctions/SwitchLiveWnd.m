function Result=SwitchLiveWnd(hObject, handles)
global glbData;
Result=false;

if glbData.devHandle == 0
    disp('Error. Device is not created.');
    Result=false;
    return
end

paramWhat=uint32(IRBG_PARAM_LiveWindow);
paramType=uint32(IRBG_DATATYPE_INT32);

index=get( handles.cbxLiveWindow, 'Value' );
switch index
    case 1
        cmd = IRBG_WINDOW_SHOW;
    case 2
        cmd = IRBG_WINDOW_TOGGLE;
    otherwise
        cmd = IRBG_WINDOW_CLOSE;
end;

%Prepare variable for SetParam 
SetParamData = int32(cmd);
pSetParamData = libpointer( 'uint32Ptr', SetParamData);

if ~SetParam( glbData.devHandle, paramWhat, pSetParamData, paramType );
    return 
end

Result=true;

