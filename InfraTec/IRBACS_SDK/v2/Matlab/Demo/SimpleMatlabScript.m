%function SimpleMatlabScript
global glbIRBFileHnd ;
global glbIRBLoaded ;

% add path to subdirs with other M-files and to irbacs.dll
glbIRBFileHnd=0 ;
glbIRBLoaded=false ;
% demo directory
handles.DemoWorkDir = pwd ;
addpath(handles.DemoWorkDir) ;
% directory irbacsfunctions
cd(['..',filesep,'Irbacsfunctions']) ;
handles.IrbacsfunctionsDir=pwd ;
addpath(handles.IrbacsfunctionsDir) ;
import ParamConst.*;

%  directory with irbacs.dll
cd(['..',filesep,'..',filesep]) ;
switch upper( computer )
    case 'PCWIN' 
        handles.irbacsDllDir = [pwd, filesep, 'Win32'];
        irbacsDll = [handles.irbacsDllDir, filesep, 'irbacs_w32.dll'];
    case 'PCWIN64'
        handles.irbacsDllDir = [pwd, filesep, 'Win64'];
        irbacsDll = [handles.irbacsDllDir, filesep, 'irbacs_w64.dll'];
    case 'GLNX86' 
        % still not supported
        handles.irbacsDllDir = [ handles.irbacsDllDir,filesep,'Linux32' ] ; 
        irbacsDll = [handles.irbacsDllDir, filesep, 'libirbacs_l32.so'];
    case 'GLNXA64'
        % still not supported
        handles.irbacsDllDir = [ handles.irbacsDllDir,filesep,'Linux64' ] ;
        irbacsDll = [handles.irbacsDllDir, filesep, 'libirbacs_l64.so'];
    otherwise
        disp('Error: Unsupported platform.');
        return
end
addpath(handles.irbacsDllDir) ;
cd(handles.DemoWorkDir);
irbacsHeader = [handles.IrbacsfunctionsDir, filesep ,'irbacs_v2.h'];

failurefound=false ;
if( exist( handles.irbacsDllDir, 'dir' ) ~= 7 )
    disp('Error: directory %s not found', irbacsDllDir) ;
    failurefound=true ;
end
if( exist( irbacsHeader, 'file') ~=2 )
    disp('Error: file %s not found', irbacsHeader) ;
    failurefound = true ;
end
% the result of exist(irbacsDll, 'file') depends from Matlab-version
if( exist(irbacsDll, 'file') ~= 2 ) && ( exist(irbacsDll, 'file') ~= 3 ) 
    disp('Error: file %s not found', irbacsDll) ;
    failurefound = true ;
end
if( failurefound )
    cd(handles.DemoWorkDir);    
    return 
end
if libisloaded ('irbacslib')
    unloadlibrary 'irbacslib';
end

if strfind( version, 'R2015') > 0 
    disp('Attention. If loadlibrary crashes after start of Matlab version 2015 then ') ;
    disp('please #### wait approx. one minute #### and try it again. This is a bug of Matlab 2015.');  
    % it seems, that Matlab ist still not ready with starting and it still loads 
    % some components in the background. 
end
loadlibrary(irbacsDll, irbacsHeader, 'alias' ,'irbacslib' ) ;

if libisloaded ('irbacslib')
    disp('irbacs.dll loaded')
    cd(handles.irbacsDllDir);
    % get handle of calling MS Windows application 
end

% load IRB-file
[filename, pathname] = uigetfile('*.irb','Select the IRB-file');
if length( filename ) > 1
    glbIRBFileHnd = irbacs_LoadIRB([pathname, filename]);
else
    unloadlibrary 'irbacslib';
    cd(handles.DemoWorkDir);    
    return
end
if glbIRBFileHnd == 0
    unloadlibrary 'irbacslib';
    cd(handles.DemoWorkDir);    
    return 
end 
glbIRBLoaded=true ;

% get number of frames in IRB-sequence
frameCount=irbacs_GetFrameCount(glbIRBFileHnd) ;
%{
% only to show, how to work with Irb-indices of frames, 
% but usually it is better to work with array indices, like it done some rows later ...
% prepare NULL-pointer
Buffer=uint32(zeros(1,0 ) );
pBuffer = libpointer('uint32Ptr', Buffer);
% ask for number of IRB-Indexes to prepare a buffer
bufsize = irbacs_GetIRBIndexes(glbIRBFileHnd, pBuffer ) ;
% prepare buffer
Buffer=uint32(zeros(1, bufsize ) );
pBuffer = libpointer('uint32Ptr', Buffer);
% get all IRB-indexes
result = irbacs_GetIRBIndexes(glbIRBFileHnd, pBuffer ) ;
if( result > 0 )
    % transfer the IRB indexes in a matrice
    IRBIndexesMat =uint32( get( pBuffer, 'value'));
    % now the indexes can be used with irbacs_SetFrameNumber, set first for example frame
    irbacs_SetFrameNumber(glbIRBFileHnd, IRBIndexesMat(1)) ;
    % check frame is set correctly
    actualFrameIRBIdx = irbacs_GetFrameNbByArrayIdx(glbIRBFileHnd) ;
end 
%}
disp([int2str(frameCount), ' frame[s] found in IRB-file.'])
timestamp = libstruct( 'TSYSTEMTIME') ;
for index=0:frameCount-1
    % activate frame on position index
    irbacs_SetFrameNbByArrayIdx(glbIRBFileHnd, index) ;
    % check actual frame number
    frameNumber=irbacs_GetFrameNbByArrayIdx(glbIRBFileHnd) ;
    if index ~= frameNumber
        disp(['Error. There is no frame with index ',int2str(index),' in the irb-file. ', int2str(frameNumber), ' is used.']) ;
        irbacs_SetFrameNbByArrayIdx(glbIRBFileHnd, frameNumber) ;
    end
    % get frame width and height for everey frame, usually they are equal,
    % but this must not be, it can differ from frame to frame (for example
    % a line scanner with different count of lines per frame)
    [result, handles.irbframeWidth] = irbacs_GetParam(glbIRBFileHnd,ParamConst.pavWidth);
    if result == 0
        disp('Determine frame width failed.') ;    
        irbacs_UnLoadIRB( glbIRBFileHnd ) ;        
        unloadlibrary 'irbacslib';
        cd(handles.CurrenWorkDir);    
        return
    end
    [result, handles.irbframeHeight] = irbacs_GetParam(glbIRBFileHnd,ParamConst.pavHeight);
    if result == 0
        disp('Determine frame height failed.') ;    
        irbacs_UnLoadIRB( glbIRBFileHnd ) ;        
        unloadlibrary 'irbacslib';
        cd(handles.CurrenWorkDir);    
        return
    end
    % now we have the USABLE frame size, but depending on the used camera some
    % more data (header info) is transfered, so the buffer has to be bigger
    % determine the full size of frame
    [result, handles.irbfullframeHeight] = irbacs_GetParam(glbIRBFileHnd,ParamConst.pavHeightWithHdr);
    if result == 0
        disp('Determine fullframe height failed.') ;    
        irbacs_UnLoadIRB( glbIRBFileHnd ) ;        
        unloadlibrary 'irbacslib';
        cd(handles.CurrenWorkDir);    
        return
    end
    outstr = ['Usable frame dimensions = ', ...
                int2str(handles.irbframeWidth),' x ', ...
                int2str(handles.irbframeHeight), ...
                '   (Full transfered frame dimensions = ', ...
                int2str(handles.irbframeWidth),' x ', ...
                int2str(handles.irbfullframeHeight), ')'] ;
    disp(outstr) ;
    % exact milliseconds relative from start
    milliseconds = irbacs_GetMilliTime(glbIRBFileHnd);
    % exact to seconds time stamp
    bres=irbacs_GetFrameTimeStamp(glbIRBFileHnd, timestamp);
    if ~bres
        disp('Call getFrameTimeStamp failed.') ;
    else
        disp(['FrameTimeStamp : ',int2str(timestamp.wDay),...
              '.',int2str(timestamp.wMonth),'.',...
              int2str(timestamp.wYear),'  ',...
              int2str(timestamp.wHour),':',...
              int2str(timestamp.wMinute),':',...
              int2str(timestamp.wSecond),'.',...
              sprintf('%03d',timestamp.wMilliSeconds),' -> excact rel. timestamp ',...
              sprintf('%d',round(milliseconds) ),'ms']);
    end 
    
    % grab frame
    % prepare a buffer and a pointer to it 
    Buffer=single(zeros(1, handles.irbframeWidth * handles.irbfullframeHeight ));
    pBuffer = libpointer('voidPtr',Buffer);

    result = irbacs_ReadPixelData( glbIRBFileHnd, pBuffer, 3 ) ;
    IR_PixTempMatrice =single(get(pBuffer, 'value'));
    if( result > 0 )
        IR_PixTempMatrice=reshape(IR_PixTempMatrice,handles.irbframeWidth,handles.irbfullframeHeight);
        % cut off header lines (exist depending on camera, some saves the frames with additional header)
        IR_PixTempMatrice=IR_PixTempMatrice(:,1:handles.irbframeHeight); 
        IR_PixTempMatrice=rot90(IR_PixTempMatrice,-1);
        IR_PixTempMatrice=fliplr(IR_PixTempMatrice);
        % Saving the files counts from 1 (not from 0)
        eval(sprintf('IR_PixTempMatrices_%d=IR_PixTempMatrice;',index+1));
    end
end % for all frames of irb-file
%important to free, otherwise irabcs.dll can not unloaded 
clear timestamp ; 

% Get filename and save matrices with black body temperatures to file(s)
% Choose between generate one file per frame and generate one matrice with
% all frames and save it to one file
GenerateOneFilePerFrame = true ;

if ( GenerateOneFilePerFrame )
    ResultPathname = uigetdir( pathname ) ;
    if ( length( ResultPathname ) > 1 )
        filename = strrep( filename, '.irb', '') ;
        for index=1:frameCount
            % generate one file per frame 
            eval( sprintf('fname = [ ResultPathname, [filesep,filename,''_frame_'',int2str(%d),''.mat'']];',index));
            disp( ['Saving frame ',int2str(index),' in ', fname ] ) ;
            eval( sprintf('save( fname,''IR_PixTempMatrices_%d'',''-mat'');',index));
        end
    end
else
    [ResultFilename, ResultPathname] = uiputfile({'*.mat';'*.txt';'*.*'} , 'Save IR-data matrice as', pathname);
    if length( ResultFilename ) > 1        
        All_IR_PixTempMatrices=zeros(handles.irbframeHeight,handles.irbframeWidth, frameCount);
        for index=1:frameCount
            % generate one matrice with all frames and save it to one file 
            eval(sprintf('All_IR_PixTempMatrices(:,:,%d)=IR_PixTempMatrices_%d(:,:);',index,index));
        end
        disp('Please wait for end of save file process...') ;
        % if you get warnings like 
        % Warning: Variable 'All_IR_PixTempMatrices' cannot be saved to a MAT-file 
        % whose version is older than 7.3.
        % the please try to modify version option '-vX.X' to your needs,
        % and check Matlab documention
        % To save this variable, use the -v7.3 switch.please then Matlab 2015 can 
        save( [ ResultPathname,ResultFilename], 'All_IR_PixTempMatrices','-mat', '-v7.3') ;
        disp('File save ready.') ;
    end
end
% save simple tab delimited ascii-file 
%dlmwrite( [ ResultPathname, ResultFilename], IR_PixTempMatrice, 'delimiter', '\t' ) ;

% close IRB file
disp('Unload irbacs.dll.') ;
irbacs_UnLoadIRB( glbIRBFileHnd ) ;
unloadlibrary 'irbacslib';
cd(handles.DemoWorkDir);
disp('Ready.') ;


