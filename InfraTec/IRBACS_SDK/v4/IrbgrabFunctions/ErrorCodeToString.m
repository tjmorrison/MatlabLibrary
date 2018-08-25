function Result=ErrorCodeToString(hexcode)

Result='';

switch bitand(hexcode, IRBG_RET_TYPE_MASK)
    case IRBG_RET_TYPE_OK
        Result='OK returned/';
        switch bitand( hexcode,IRBG_RET_TYPE_MASK)
            case IRBG_RET_UNDEF
                Result=[Result,'Not a valid return value.'];
            case IRBG_RET_SUCCESS
                Result=[Result,'Success'];
            otherwise
                Result=[Result,'Unknown return ok code'];
        end        
    case IRBG_RET_TYPE_ERR
        Result='Error: ';
        switch hexcode
            case IRBG_RET_ERROR
                Result = [Result, 'unspecified error'];
            case IRBG_RET_NOT_SUPPORTED
                Result = [Result, 'feature is not supported'];
            case IRBG_RET_NOT_FOUND
                Result = [Result, 'generic -something- could not be found'];
            case IRBG_RET_OUT_OF_RANGE
                Result = [Result, 'argument is out of range'];
            case IRBG_RET_TIMEOUT
                Result = [Result, 'timeout elapsed'];
            case IRBG_RET_BLOCKED
                Result = [Result, 'failed to enter some critical section'];
            case IRBG_RET_UNASSIGNED
                Result = [Result, '-something- is unset/nil'];
            case IRBG_RET_INCOMPATIBLE
                Result = [Result, 'binary incompatibilities detected (e.g. struct sizes differ'];
            case IRBG_RET_BUFSIZE
                Result = [Result, 'buffer is too small bitor(is not neccessarily an error'];
            case IRBG_RET_CONFIG_ERROR
                Result = [Result, 'no connection could be established - device has never been connected'];
            case IRBG_RET_CONNECTION_ERROR
                Result = [Result, 'invalid uint64'];
            case IRBG_RET_INVALID_HANDLE
                Result = [Result, 'invalid DataSize'];
            case IRBG_RET_INVALID_DATASIZE
                Result = [Result, 'invalid DataPointer'];
            case IRBG_RET_INVALID_DATAPOINTER
                Result = [Result, 'invalid DataPointer'];
            case IRBG_RET_INVALID_PARAMETER
                Result = [Result, 'invalid Parameter'];
            case IRBG_RET_TERMINATED
                Result = [Result, 'Object is Terminated'];
            otherwise
                Result=[Result,'Unknown return error code'];                
        end
    case IRBG_RET_TYPE_STATUS
        Result='Status: ';
        switch hexcode
            case IRBG_RET_UNDEF
                Result=[Result,'Not a valid return value.'];
            case IRBG_RET_STATUS_OK
                Result=[Result,'Status ok'];
            case IRBG_RET_CONNECTING
                Result=[Result,'Establishing a connection'];
            case IRBG_RET_CONNECTED
                Result=[Result,'Connection is established, but no data has been exchanged yet'];
            case IRBG_RET_RUNNING
                Result=[Result,'Communication is up and running'];
            case IRBG_RET_COMM_ERROR
                Result=[Result,'Connection lost'];
            case IRBG_RET_DISCONNECTED
                Result=[Result,'Gracefully disconnected'];
            otherwise
                Result=[Result,'Unknown return ok code'];   
        end
    otherwise
        Result='Unvalid code';
end


