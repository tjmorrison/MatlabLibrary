function OnButtonLoadFile(hObject,handles)

% so user is pleased to be patient to wait for the end of initialization
% process
set(handles.ButtonClose,'Enable','off');
drawnow

global  glbIRBFileHnd ;
global  glbIRBFrameCount ;
global  glbFrameNumber ;
global  glbDemoWorkDir ;

bDown = get(handles.ButtonLoad,'Value');
glbIRBFileHnd=0;
if bDown
    cd( [handles.irbacsDllDir, filesep, '..']) ;
    [filename, pathname] = uigetfile('*.irb','Select the IRB-file');
    cd( glbDemoWorkDir );    
    if length( filename ) > 1
        glbIRBFileHnd = irbacs_LoadIRB([pathname, filename]);
        set(handles.LblIRBFilename, 'String', [pathname, filename] ) ;
        % get number of frames in IRB-sequence
        glbIRBFrameCount = irbacs_GetFrameCount ( glbIRBFileHnd ) ;
        disp([int2str(glbIRBFrameCount), ' frame[s] found in IRB-file.'])
        set(handles.LblFrameCount, 'String', glbIRBFrameCount );
        if glbIRBFrameCount > 1
            % jump to first frame
            index = 0 ;
            irbacs_SetFrameNbByArrayIdx(glbIRBFileHnd, index) ;
        end 
        set(handles.ButtonLoad,'String','Release IRB-File');
        ReadAndShowFrame( handles, 0 ) ;
    else
      set(handles.ButtonLoad,'Value',0);  
    end
else
    set(handles.ButtonLoad,'String','Load IRB-File');
    ReleaseIRBFile( hObject, handles) ;
end
set(handles.ButtonClose,'Enable','on');
guidata(hObject, handles);
drawnow
