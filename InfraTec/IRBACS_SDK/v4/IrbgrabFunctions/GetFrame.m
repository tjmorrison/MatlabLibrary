function Result=GetFrame(DevHandle, StreamIdx, hObject, handles);
global glbData;
Result=false;

if ~glbData.pollingActive
    return
end

MemHnd = uint64(0);
pMemHnd = libpointer('uint64Ptr', MemHnd) ;

% Get memory object handle
retval = irbg_dev_getdata( DevHandle, glbData.grabtype, pMemHnd );
if retval ~= IRBG_RET_OK 
    disp(['irbgrab_dev_getdata failed (Result=0x', sprintf('%x', retval),')']);
    disp(['irbgrab_dev_getdata: ', ErrorCodeToString(retval)]);    
    return 
end

FramePtr = uint64(0);
pFramePtr = libpointer('uint64Ptr', FramePtr);

FrameSz = int32(0);
pFrameSz = libpointer('uint32Ptr', FrameSz);

% Get memory object pointer to image
retval = irbg_mem_getdataptr( pMemHnd.Value, pFramePtr, pFrameSz );
if retval ~= IRBG_RET_OK 
    disp(['irbg_mem_getdataptr failed (Result=0x', sprintf('%x', retval),')']);
    disp(['irbg_mem_getdataptr: ', ErrorCodeToString(retval)]);    
    return 
end

% determine size of frame resp. necessary buffersize
Width = uint32(0);
pWidth = libpointer('uint32Ptr', Width);
Height = uint32(0);
pHeight = libpointer('uint32Ptr', Height);
PixelType = uint32(0);
pPixType = libpointer('uint32Ptr', PixelType);

retval = irbg_mem_getdimension( pMemHnd.Value, pWidth, pHeight, pPixType );
if retval ~= IRBG_RET_OK 
    disp(['irbgr_mem_getdimension failed (Result=0x', sprintf('%x', retval),')']);
    disp(['irbgr_mem_getdimension: ', ErrorCodeToString(retval)]);    
    return 
end

% prepare buffer for frame data
if      (glbData.frameWidth ~= pWidth.Value) ...
     || (glbData.frameHeight ~= pHeight.Value) ...
     || (glbData.framePixType ~= pPixType.Value)
 
    % prepare frame buffer if necessary
    glbData.frameWidth  = pWidth.Value;
    glbData.frameHeight = pHeight.Value;
    glbData.framePixType= pPixType.Value;

    frameSize = glbData.frameWidth * glbData.frameHeight * bitand( glbData.framePixType, uint32(hex2dec( 'FF' )));
      
    switch glbData.framePixType
        case IRBG_DATATYPE_INT32
            glbData.buffer=int32(zeros(1, glbData.frameWidth * glbData.frameHeight));
        case IRBG_DATATYPE_INT64   
            glbData.buffer=uint64(zeros(1, glbData.frameWidth * glbData.frameHeight));
        case IRBG_DATATYPE_UINT16  
            glbData.buffer=uint16(zeros(1, max( pFrameSz.Value, glbData.frameWidth * glbData.frameHeight ) )); % sometimes the frame has a footer (VC3 that is sth. like a header)
        case IRBG_DATATYPE_SINGLE     
            glbData.buffer=single(zeros(1, glbData.frameWidth * glbData.frameHeight));
        case IRBG_DATATYPE_DOUBLE     
            glbData.buffer=double(zeros(1, glbData.frameWidth * glbData.frameHeight));
        otherwise
            glbData.buffer=uint16(zeros(1, glbData.frameWidth * glbData.frameHeight));
    end

% prepare scaled image with correct dimension
    % prepare image
    glbData.hImage=imagesc(glbData.buffer);
    %important for correct presentation of different frame sizes
    set(handles.axesIRBFrame, 'XLimMode', 'auto');
    set(handles.axesIRBFrame, 'YLimMode', 'auto');
    set(handles.axesIRBFrame, 'YDir', 'normal');
    set(handles.axesIRBFrame, 'DataAspectRatioMode','manual')
    set(handles.axesIRBFrame, 'DataAspectRatio', [1 1 1])
    set(handles.axesIRBFrame, 'XLimMode', 'manual' )
    set(handles.axesIRBFrame, 'XLim', [1 glbData.frameWidth] )
    set(handles.axesIRBFrame, 'YLimMode', 'manual' )
    set(handles.axesIRBFrame, 'YLim', [1 glbData.frameHeight] )
    set(handles.axesIRBFrame, 'Visible', 'on' )
    % Show palette
    colbar=colorbar(handles.axesIRBFrame);
    % Switch to palette 'jet'
    colormap(handles.axesIRBFrame, 'jet');
    tic ;
end;

% rerieve more information from frame 
aInfo = libstruct('TIRBG_MemInfo');
aInfo.StructSize = 28;
retval = irbg_mem_getinfo( pMemHnd.Value, aInfo );
if retval ~= IRBG_RET_OK 
    disp(['irbg_mem_getinfo (Result=0x', sprintf('%x', retval),')']);
    disp(['irbg_mem_getinfo: ', ErrorCodeToString(retval)]);    
    return 
end
if aInfo.Triggered ~= 0
    glbData.triggerCnt = glbData.triggerCnt + 1;
end

% Copy frame from ibgrab-library internal memory object to Matlab-buffer
pBuffer = libpointer('voidPtr', glbData.buffer);
irbg_mem_copy( pFramePtr.Value, pBuffer, pFrameSz.Value ); % No return value
% Now pBuffer.Value contains image data and original irbgrab-lib internal

% ibgrab-library internal memory object has to be freed
retval = irbg_mem_free( pMemHnd.Value );
if retval ~= IRBG_RET_OK 
    disp(['irbgrab_mem_free failed (Result=0x', sprintf('%x', retval),')']);
    disp(['irbgrab_mem_free: ', ErrorCodeToString(retval)]);    
    return
end

% Show frame
switch glbData.framePixType
    case IRBG_DATATYPE_INT32
        image=int32(get(pBuffer, 'value'));
    case IRBG_DATATYPE_INT64   
        image=uint64(get(pBuffer, 'value'));
    case IRBG_DATATYPE_UINT16  
        image=uint16(get(pBuffer, 'value'));
    case IRBG_DATATYPE_SINGLE     
        image=single(get(pBuffer, 'value'));
    case IRBG_DATATYPE_DOUBLE     
        image=double(get(pBuffer, 'value'));
    otherwise
        image=uint16(get(pBuffer, 'value'));
end
    
glbData.frameCount = glbData.frameCount + 1;  
image=image(1,1:glbData.frameWidth * glbData.frameHeight); % cut off additional data (footer)

image=reshape(image, glbData.frameWidth, glbData.frameHeight);
image=rot90(image,-1);
image=flipud(image);

% #################################################################
% At this point is the image as a well formated matrix available
% #################################################################

%Since visualization generates heavy load on cpu it is better to reduce
%visualization rate to 10Hz for example (depending on cpu power)

delayToc = toc;
delay = (delayToc - glbData.visDelayToc) * 1000;
if delay > 200  % visualization delay is 200ms, means approx. 5Hz
    glbData.visDelayToc = delayToc;
    set(glbData.hImage,'Cdata',image);
end;
if delayToc >= 1
    glbData.frameRate = glbData.frameCount - glbData.frameCountOld ;
    tic ;
    glbData.visDelayToc = 0;
    glbData.frameCountOld = glbData.frameCount ;
end
set( handles.edtFramerate, 'String', num2str(glbData.frameRate) );
set( handles.edtTriggerCount, 'String', num2str(glbData.triggerCnt) );

Result=true;





