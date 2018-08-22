function varargout = demo(varargin)
%DEMO M-file for demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('Property','Value',...) creates a new DEMO using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to demo_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      DEMO('CALLBACK') and DEMO('CALLBACK',hObject,...) call the
%      local function named CALLBACK in DEMO.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo

% Last Modified by GUIDE v2.5 21-Aug-2012 11:39:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;
global  glbDemoWorkDir ;

% demo directory
glbDemoWorkDir=pwd;
addpath(glbDemoWorkDir) ;
% directory with irbacsfunctions
cd(['..',filesep,'Irbacsfunctions']) ;
handles.IrbacsfunctionsDir=pwd ;
addpath(handles.IrbacsfunctionsDir) ;
%  directory with irbacs.dll
cd(['..',filesep,'..',filesep]) ;
switch upper( computer )
    case 'PCWIN' 
        handles.irbacsDllDir = [pwd, filesep, 'Win32'];
        handles.irbacsDll = [handles.irbacsDllDir, filesep, 'irbacs_w32.dll'];
    case 'PCWIN64'
        handles.irbacsDllDir = [pwd, filesep, 'Win64'];
        handles.irbacsDll = [handles.irbacsDllDir, filesep, 'irbacs_w64.dll'];
    case 'GLNX86' 
        % still not supported
        handles.irbacsDllDir = [ handles.irbacsDllDir,filesep,'Linux32' ] ; 
        handles.irbacsDll = [handles.irbacsDllDir, filesep, 'libirbacs_l32.so'];
    case 'GLNXA64'
        % still not supported
        handles.irbacsDllDir = [ handles.irbacsDllDir,filesep,'Linux64' ] ;
        handles.irbacsDll = [handles.irbacsDllDir, filesep, 'libirbacs_l64.so'];
    otherwise
        disp('Error: Unsupported platform.');
        return
end
addpath(handles.irbacsDllDir) ;
cd(glbDemoWorkDir);

handles.Connected=LoadIrbacsDll(hObject, handles);
if ~handles.Connected
    return 
end 

% Update handles structure
guidata(hObject, handles);

% move and resize figure object
set(hObject,'Position',[7 35 357 496]);


% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in ButtonLoad.
function ButtonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  glbIrbAcsDllLoaded;
global  glbIRBFileHnd;
global glbIRBFrameCount;

if glbIrbAcsDllLoaded  
    OnButtonLoadFile(hObject,handles) ;
end


% --- Executes on button press in ButtonClose.
function ButtonClose_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UnloadIrbacsDll(hObject,handles) ;


function FigureClose_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UnloadIrbacsDll(hObject,handles) ;


% --- Executes on button press in ButtonPrevious.
function ButtonPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  glbFrameNumber ;
global  glbIRBFileHnd ;

bDown = get(handles.ButtonLoad,'Value');
if bDown
    glbFrameNumber = int32( irbacs_GetFrameNbByArrayIdx(glbIRBFileHnd) ); 
    glbFrameNumber = glbFrameNumber - 1 ;
    irbacs_SetFrameNbByArrayIdx(glbIRBFileHnd, glbFrameNumber) ;    
    ReadAndShowFrame( handles, 0 ) ;
    drawnow;
    guidata(hObject, handles);    
else
    return
end



% --- Executes on button press in ButtonNext.
function ButtonNext_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  glbFrameNumber ;
global  glbIRBFileHnd ;

bDown = get(handles.ButtonLoad,'Value');
if bDown
    glbFrameNumber = int32( irbacs_GetFrameNbByArrayIdx(glbIRBFileHnd) ); 
    glbFrameNumber = glbFrameNumber + 1 ;
    irbacs_SetFrameNbByArrayIdx(glbIRBFileHnd, glbFrameNumber) ;
    ReadAndShowFrame( handles, 0 ) ;
    drawnow;
    guidata(hObject, handles);    
else
    return
end



