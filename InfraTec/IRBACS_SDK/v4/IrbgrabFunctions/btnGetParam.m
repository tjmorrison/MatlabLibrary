function Result=btnGetParam(hObject, handles)
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
        paramValue = int32(0);
    case 2
        paramType = IRBG_DATATYPE_INT64;
        paramValue = int64(0);
    case 3
        paramType = IRBG_DATATYPE_SINGLE;
        paramValue = single(0);
    case 4
        paramType = IRBG_DATATYPE_DOUBLE;
        paramValue = double(0);
    case 5
        paramType = IRBG_DATATYPE_STRING;
        paramValue = '';
    case 6
        % select returned content by paramValue 
        paramType = IRBG_DATATYPE_IDXString;
        paramValue=uint32(str2num(get( handles.edtValue, 'String' )));
    otherwise
        return;
end;

[Result, paramValue] = GetParam( glbData.devHandle, paramWhat, paramValue, paramType );
if ~Result;
    return 
end
switch paramTypeIdx
    case {1,2,3,4}
        set( handles.edtValue, 'String', num2str(paramValue) );        
    case {5,6}
        set( handles.edtValue, 'String', paramValue);        
    otherwise
        return;
end;

Result=true;



