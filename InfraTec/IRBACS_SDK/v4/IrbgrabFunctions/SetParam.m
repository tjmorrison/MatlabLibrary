function Result=SetParam( handle, what, data, dataType)
global glbData;
Result=false;

if glbData.devHandle == 0
    disp('Error. Device is not created.');
    Result=false;
    return
end

%Prepare variable for callback function pointer
if isstr(data)
    databuf=[data];
    paramStr = libpointer( 'voidPtr', uint8(databuf) );
    pData = libstruct( 'TIRBG_String') ;
    pData.Text = paramStr;
    pData.Len  = length( databuf );
    % For structure data no generation of pointer is necessary
else
    pData = libpointer( 'voidPtr', data);
end

retval=irbg_dev_setparam( handle, what, pData, dataType );    
if retval ~= IRBG_RET_OK
    disp(['SetParam  failed (Result=0x',sprintf('%x',retval),')']);
    disp(['SetParam: ', ErrorCodeToString(retval)]);
    return 
end

Result=true;

