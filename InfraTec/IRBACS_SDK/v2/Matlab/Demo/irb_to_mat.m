function [IRmatrix] = irb_to_mat(data_path,data_file,save_dir,downsample,spatial_interval,temporal_interval)

%Edit of SimpleMatlabScript by Infratec to convert *.irb files to *.mat
%files. The script will also downsample data to make it easier to work with
%Edited by Travis Morrison 
%August 23 2018

%data_path = file directory to *.irb files 

%data_file = name of *.irb file to be converted

%save_dir = directory which you wish to save to the *.mat files too
%Note- the file will be saved as a struct with information concerning the
%image properties. It will be titled with the timestamp of the start of DAQ

%downsample = booleen, true~ if you want to downsample, false~ if you do
%not want to downsample

%spatial_interval= only used if downsample = true, factor by which you wish
%to downsample in x and y. For instance, if spatial_interval = 2, then the
%code will only save everyother pixel in space

%temporal_interval = only used if downsample = true, factor by which you wish
%to downsample in time. For instance, if temporal_interval = 2, then the
%code will only save everyother frame



%clear all; 
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
if length( data_file ) > 1
    glbIRBFileHnd = irbacs_LoadIRB([data_path, data_file]);
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

% --------------------------------------------------------------------------
%Load the *.irb files into matlab
% get number of frames in IRB-sequence
frameCount=irbacs_GetFrameCount(glbIRBFileHnd) ;

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
    [~, handles.irbfullframeHeight] = irbacs_GetParam(glbIRBFileHnd,ParamConst.pavHeightWithHdr);
    [~, properties.epsilon] = irbacs_GetParam(glbIRBFileHnd,ParamConst.pavEpsilon);
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
        time = ['FrameTimeStamp : ',int2str(timestamp.wDay),...
              '.',int2str(timestamp.wMonth),'.',...
              int2str(timestamp.wYear),'  ',...
              int2str(timestamp.wHour),':',...
              int2str(timestamp.wMinute),':',...
              int2str(timestamp.wSecond),'.',...
              sprintf('%03d',timestamp.wMilliSeconds),' -> excact rel. timestamp ',...
              sprintf('%d',round(milliseconds) ),'ms'];
        disp(time);
        if frameCount == 0
            start_time = time;
        end
          
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

% --------------------------------------------------------------------------
%adding interpolation to reduce file size
cnt = 1;
if(desample)
    matrix_str = 'IR_PixTempMatrices_';
    IRmatrix.data = zeros(768/spatial_interval,1024/spatial_interval);
   for index =1:temporal_interval:frameCount
        if index ==1
            IRmatrix.data(:,:,cnt) = IR_PixTempMatrice(1:spatial_interval:end,1:spatial_interval:end);
           cnt = cnt+1;
            clear IR_PixTempMatrice;
        else
            IRmatrix.data(:,:,cnt) = eval(strcat(matrix_str,num2str(index),'(1:spatial_interval:end,1:spatial_interval:end)'));
            cnt = cnt+1;
            eval( sprintf('clear IR_PixTempMatrices_%d;',index));
        end
   end
   clear IR_Pix*;
else%do nothing
end
% --------------------------------------------------------------------------
% Save the *.mat file

%[ResultFilename, ResultPathname] = uiputfile({'*.mat';'*.txt';'*.*'} , 'Save IR-data matrice as', pathname);
if length( save_dir ) > 1
    % if you get warnings like
    % Warning: Variable 'All_IR_PixTempMatrices' cannot be saved to a MAT-file
    % whose version is older than 7.3.
    % the please try to modify version option '-vX.X' to your needs,
    % and check Matlab documention
    % To save this variable, use the -v7.3 switch.please then Matlab 2015 can
    cd(handles.DemoWorkDir);
    disp('Please wait for end of save file process...') ;
    save([save_dir,filesep,''], 'IRmatrix', '-v7.3') ;
    disp('File save ready.') ;
end


% close IRB file
disp('Unload irbacs.dll.') ;
irbacs_UnLoadIRB( glbIRBFileHnd ) ;
unloadlibrary 'irbacslib';
cd(handles.DemoWorkDir);
disp('Ready.') ;



end

