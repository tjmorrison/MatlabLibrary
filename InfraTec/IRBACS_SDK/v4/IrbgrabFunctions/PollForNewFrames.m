function Result=PollForNewFrames(hObject, handles)
global glbData;
Result=false;

%frame polling loop
glbData.pollingActive=true;
glbData.stopPollingReq=false;

%irbg_dll_pollframegrab returns Handle and Stream of grabbed frame
DevHandle = uint64(0);
pDevHandle = libpointer( 'voidPtr', DevHandle);
StreamIdx = uint64(0);
pStreamIdx = libpointer( 'int32Ptr', StreamIdx);

while ~glbData.stopPollingReq
    retval=irbg_dll_pollframegrab(pDevHandle, pStreamIdx);
    if retval==IRBG_RET_OK
        GetFrame(pDevHandle.Value, pStreamIdx.Value, hObject, handles);
        irbg_dll_pollframefinish;
    end
    drawnow ;    
    guidata(hObject, handles) ;          
end
glbData.pollingActive=false;

Result=true;

