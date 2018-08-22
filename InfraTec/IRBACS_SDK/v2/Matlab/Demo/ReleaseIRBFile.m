function ReleaseIRBFile(hObject, handles)

global  glbIRBFileHnd

set(handles.ButtonLoad,'String','Load IRB-File');
if glbIRBFileHnd > 0 
    irbacs_UnLoadIRB( glbIRBFileHnd ) ;
    glbIRBFileHnd=0 ;
end
set(handles.ButtonNext, 'Enable', 'off' );
set(handles.ButtonPrevious, 'Enable', 'off' );
set(handles.LblIRBFilename, 'String', '' );
set(handles.LblFrameCount, 'String', '' );
set(handles.LblActualFrame, 'String', '' );
set(handles.LblDimensions, 'String', '' );        
guidata(hObject, handles);
