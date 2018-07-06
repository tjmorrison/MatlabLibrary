function UnloadIrbacsDll(hObject,handles)

global	glbIRBLoaded ;
global  glbDemoWorkDir ;

if (libisloaded ('irbacslib')) 
    unloadlibrary 'irbacslib';
    glbIRBLoaded=false ;
    cd(glbDemoWorkDir);
    guidata(hObject, handles);
    disp('irbacs.dll unloaded')
    delete( gcf );
end


