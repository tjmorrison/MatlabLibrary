function Result=btnSetParam(hObject, handles)
global glbData;
Result=false;

if glbData.devHandle == 0
    disp('Error. Device is not created.');
    Result=false;
    return
end

paramWhat=uint32(str2num(get( handles.edtWhat, 'String' )));
paramTypeIdx=get( handles.cbxParamType, 'Value' );
switch paramTypeIdx
    case 1
        paramType = IRBG_DATATYPE_INT32;
        paramValue = int32(str2num(get(handles.edtValue, 'String')));
    case 2
        paramType = IRBG_DATATYPE_INT64;
        paramValue = int64(str2num(get(handles.edtValue, 'String')));
    case 3
        paramType = IRBG_DATATYPE_SINGLE;
        paramValue = single(str2double(get(handles.edtValue, 'String')));
    case 4
        paramType = IRBG_DATATYPE_DOUBLE;
        paramValue = double(str2num(get(handles.edtValue, 'String')));
    case 5
        paramType = IRBG_DATATYPE_STRING;
        paramValue = get(handles.edtValue, 'String');
    otherwise
        disp('Error in SetParam. This type is not supported.');
        return;
end;

if ~SetParam( glbData.devHandle, paramWhat, paramValue, paramType );
    return 
end

Result=true;


