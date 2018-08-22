function Result=LoadIrbacsDll(hObject,handles)

global glbDemoWorkDir ;
global glbIrbAcsDllLoaded ;

Result = false ;
if libisloaded ('irbacslib')
    UnloadIrbacsDll(hObject, handles);
    return
end

irbacsHeader = [handles.IrbacsfunctionsDir, filesep ,'Irbacs_v2.h'];

if( exist(handles.irbacsDllDir,'dir') ~= 7 )
    disp('Error: directory %s not found', irbacsDllDir)
    return
end
if( exist( irbacsHeader, 'file') ~= 2 )
    disp('Error: file %s not found', irbacsHeader)
    return
end
% the result of exist(irbacsDll, 'file') depends from Matlab-version
if( exist(handles.irbacsDll, 'file') ~= 2 ) && ( exist(handles.irbacsDll, 'file') ~= 3 ) 
    disp('Error: file %s not found', irbacsDll)
    return
end

cd(glbDemoWorkDir);
% For debugging
%[notfound,warnings]=loadlibrary(irbacsDll, irbacsHeader, 'alias','irbacslib' );
loadlibrary( handles.irbacsDll, irbacsHeader, 'alias' ,'irbacslib' );

if libisloaded ('irbacslib')
    disp('irbacs.dll loaded')
    cd(handles.irbacsDllDir); 
    glbIrbAcsDllLoaded = true ;
else
    set(handles.ButtonBack,'Enable','off');
    set(handles.ButtonNext,'Enable','off');
    glbIrbAcsDllLoaded = false ;
end
Result = true ;






