function ReadAndShowFrame( handles, clearFrame )

global  glbIRBLoaded ;
global  glbIRBFileHnd ;
global  glbIRBFrameCount ;
global  glbFrameNumber ;

FrameNumber=irbacs_GetFrameNbByArrayIdx(glbIRBFileHnd);
set(handles.LblActualFrame, 'String', FrameNumber );
if (glbIRBFrameCount-1)>FrameNumber % 0-based counting
    set(handles.ButtonNext, 'Enable', 'on' );
else
    set(handles.ButtonNext, 'Enable', 'off' );
end
if FrameNumber>0
    set(handles.ButtonPrevious, 'Enable', 'on' );
else
    set(handles.ButtonPrevious, 'Enable', 'off' );
end
% 0 = pavWidth (TParamValue in irbacsfunctions\irbacs.h)
floatValue=double(0);
pfloatValue = libpointer( 'doublePtr', floatValue) ;
result=calllib('irbacslib', 'getParam', glbIRBFileHnd, 0, pfloatValue );
if result == 0
    disp('Unvalid frame width.') ;    
    irbacs_UnLoadIRB( glbIRBFileHnd ) ;        
    unloadlibrary 'irbacslib';
    cd(handles.CurrenWorkDir);    
    return
end
floatValue = pfloatValue.Value;
handles.irbframeWidth = int32( floatValue ) ;

% 1 = pavHeight (TParamValue in irbacsfunctions\irbacs.h)
result=calllib('irbacslib', 'getParam', glbIRBFileHnd, 1, pfloatValue );
if result == 0
    disp('Unvalid frame height.') ;    
    irbacs_UnLoadIRB( glbIRBFileHnd ) ;        
    unloadlibrary 'irbacslib';
    cd(handles.CurrenWorkDir);    
    return
end
floatValue = pfloatValue.Value;    
handles.irbframeHeight = int32(floatValue) ;
% now we have the USABLE frame size, but depending on the used camera some
% more data (header info) is transfered, so the buffer has to be bigger
% determine the full size of frame
% 35 = pavHeightWithHdr (TParamValue in irbacsfunctions\irbacs.h)
result=calllib('irbacslib', 'getParam', glbIRBFileHnd, 35, pfloatValue );
if result == 0
    disp('Unvalid full frame height.') ;    
    irbacs_UnLoadIRB( glbIRBFileHnd ) ;        
    unloadlibrary 'irbacslib';
    cd(handles.CurrenWorkDir);    
    return
end
floatValue = pfloatValue.Value;    
handles.irbfullframeHeight = int32(floatValue) ;
%outstr = ['Usable frame dimensions = ', ...
%           int2str(handles.irbframeWidth),' x ', ...
%           int2str(handles.irbframeHeight), ...
%           '   (Full transfered frame dimensions = ', ...
%           int2str(handles.irbframeWidth),' x ', ...
%           int2str(handles.irbfullframeHeight), ')'] ;
%disp(outstr) ;
Dimensions = [int2str(handles.irbframeWidth),' x ', int2str(handles.irbframeHeight)] ;
set(handles.LblDimensions, 'String', Dimensions ) ;
    
Buffer=single(zeros(1, handles.irbframeWidth * handles.irbfullframeHeight));
pBuffer = libpointer('voidPtr',Buffer);
image=reshape(Buffer,handles.irbframeWidth,handles.irbfullframeHeight);
% cut off header lines (exist depending on camera, some saves the frames with additional header)
image=image(:,1:handles.irbframeHeight) ;
image=rot90(image,-1);
hImage=imagesc( image );
drawnow ;
if clearFrame ~= 1
    % TPixelValue = pvTempBBSi bzw. 3 -> black body temperatures in single
    % Values
    result = irbacs_ReadPixelData( glbIRBFileHnd, pBuffer, 3 ) ;
    image=single(get(pBuffer, 'value'));
    if result > 0    
        image=reshape(image,handles.irbframeWidth,handles.irbfullframeHeight);
        % cut off header lines (exist depending on camera, some saves the frames with additional header)
        image=image(:,1:handles.irbframeHeight) ;
        image=rot90(image,-1);
        image=fliplr(image);
        set(hImage,'Cdata',image);
    end
 end
    