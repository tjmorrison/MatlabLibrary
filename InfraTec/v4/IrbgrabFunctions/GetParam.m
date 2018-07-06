function [Result, data]=GetParam( handle, what, data, dataType)
global glbData;
Result=false;

if glbData.devHandle == 0
    disp('Error. Device is not created.');
    Result=false;
    return
end

%Prepare variable for callback function pointer
switch dataType
    case {IRBG_DATATYPE_STRING, IRBG_DATATYPE_IDXString}
        if dataType == IRBG_DATATYPE_IDXString 
            % content of data is the index
            pData = libstruct( 'TIRBG_IdxString') ;
            pData.Index = int32(data);
        else
            pData = libstruct( 'TIRBG_String') ;
        end
        bufSz=100000;% yes, this is absolut to much, but that doen't matter
        buffer = blanks(bufSz-1);
        buffer(bufSz)=0;        
        paramStr = libpointer( 'uint8Ptr', uint8(buffer) );
        if dataType == IRBG_DATATYPE_IDXString 
            val64ptr=irbg_misc_PointerToInt64( paramStr );
            pData.ptr2TextLowerPart=uint32(val64ptr);
            pData.ptr2TextHigherPart=uint32(bitshift(val64ptr, -32));
        else
            pData.Text = paramStr; %irbg_misc_PointerToInt64( paramStr );
        end
        pData.Len  = length( buffer );
        % For structure data no generation of pointer is necessary
    otherwise
        pData = libpointer( 'voidPtr', data);
end

retval=irbg_dev_getparam( handle, what, pData, dataType );    
if retval ~= IRBG_RET_OK
    disp(['GetParam  failed (Result=0x',sprintf('%x',retval),')']);
    disp(['GetParam: ', ErrorCodeToString(retval)]);
    return 
end
if (dataType==IRBG_DATATYPE_STRING) || (dataType==IRBG_DATATYPE_IDXString)
    data = char(paramStr.Value);
else    
    data = pData.Value;
end

Result=true;

