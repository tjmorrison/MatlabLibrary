function varargout = DemoApp(varargin)
% DEMOAPP MATLAB code for DemoApp.fig
%      DEMOAPP, by itself, creates a new DEMOAPP or raises the existing
%      singleton*.
%
%      H = DEMOAPP returns the handle to a new DEMOAPP or the handle to
%      the existing singleton*.
%
%      DEMOAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMOAPP.M with the given input arguments.
%
%      DEMOAPP('Property','Value',...) creates a new DEMOAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DemoApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DemoApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DemoApp

% Last Modified by GUIDE v2.5 07-Aug-2017 14:10:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DemoApp_OpeningFcn, ...
                   'gui_OutputFcn',  @DemoApp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before DemoApp is made visible.
function DemoApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DemoApp (see VARARGIN)

% Choose default command line output for DemoApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DemoApp wait for user response (see UIRESUME)
% uiwait(handles.dlgDemo);


% --- Outputs from this function are returned to the command line.
function varargout = DemoApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnLoad, 'Enable','off');
if LoadIrbgrabDll
    % state info (handles.lblInfo) will be filled in getIrbgrabDllVersion
    GetVersion(hObject,handles); 
    GetDeviceTypeNames(hObject,handles); 
    set(handles.cbxDevices, 'Enable','on'); 
    set(handles.btnUnload, 'Enable','on');    
    set(handles.btnCreateDevice, 'Enable','on');
else
    set(handles.btnLoad, 'Enable','on');    
    set(handles.lblInfo, 'String', 'Load irbgrab lib failed');
    set(handles.cbxDevices, 'String', 'Sources' ) ;
    set(handles.cbxDevices, 'Enable','off');
end


% --- Executes on button press in btnUnload.
function btnUnload_Callback(hObject, eventdata, handles)
% hObject    handle to btnUnload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnUnload, 'Enable','off');
global glbData;
glbData.stopPollingReq=true;
guidata(hObject, handles) ;  
if UnloadIrbgrabDll
    set( handles.cbxDevices, 'Value', 1 );
    set( handles.cbxDevices, 'String', 'Sources' ) ;
    set( handles.cbxDevices, 'Enable','off');
    set( handles.lblInfo, 'String', 'Unload irbgrab lib ok.' ) ;
    set(handles.btnLoad, 'Enable','on');
    set(handles.btnCreateDevice, 'Enable','off');
    set(handles.btnFreeDevice, 'Enable','off');
    set(handles.btnSearch, 'Enable','off');
    set(handles.btnConnect, 'Enable','off');
    set(handles.btnDisconnect, 'Enable','off');
    set(handles.cbxGrabType, 'Enable','off');
    set(handles.btnStartGrab, 'Enable','off');
    set(handles.btnStopGrab, 'Enable','off');    
    set(handles.btnSetParam, 'Enable','off');
    set(handles.btnGetParam, 'Enable','off');
    set(handles.btnRemote, 'Enable','off');
    set(handles.cbxRemote, 'Enable','off');    
    set(handles.btnLiveWindow, 'Enable','off');
    set(handles.cbxLiveWindow, 'Enable','off');    
    set(handles.edtWhat, 'Enable','off');
    set(handles.edtValue, 'Enable','off');
    set(handles.cbxParamType, 'Enable','off');
    set(handles.btnSetParam, 'Enable','off');
    set(handles.btnGetParam, 'Enable','off');    
end;


% --- Executes on selection change in cbxDevices.
function cbxDevices_Callback(hObject, eventdata, handles)
% hObject    handle to cbxDevices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cbxDevices contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cbxDevices
set(handles.cbxDevices, 'Enable','off');
set(handles.cbxDevices, 'Enable','on');


% --- Executes on button press in btnCreateDevice.
function btnCreateDevice_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreateDevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnCreateDevice, 'Enable','off');
global glbData;
glbData.deviceId = get( handles.cbxDevices, 'Value' ) -1 ;
if CreateDevice
    set( handles.lblInfo, 'String', ['CreateDevice ok. Handle:',int2str(glbData.devHandle)] );
    set(handles.btnFreeDevice, 'Enable','on');
    set(handles.btnSearch, 'Enable','on');
    set(handles.btnConnect, 'Enable','on');
    set(handles.btnSetParam, 'Enable','on');
    set(handles.btnGetParam, 'Enable','on');
    set(handles.btnRemote, 'Enable','on');
    set(handles.cbxRemote, 'Enable','on');    
    set(handles.btnLiveWindow, 'Enable','on');
    set(handles.cbxLiveWindow, 'Enable','on');  
    set(handles.edtWhat, 'Enable','on');
    set(handles.edtValue, 'Enable','on');
    set(handles.cbxParamType, 'Enable','on');
    set(handles.btnSetParam, 'Enable','on');
    set(handles.btnGetParam, 'Enable','on');
else
    set( handles.lblInfo, 'String', 'Error in CreateDevice.' );
end


% --- Executes on button press in btnFreeDevice.
function btnFreeDevice_Callback(hObject, eventdata, handles)
% hObject    handle to btnFreeDevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glbData;
set(handles.btnFreeDevice, 'Enable','off');
if FreeDevice
    set( handles.lblInfo, 'String', ['FreeDevice ok. Handle:',int2str(glbData.devHandle)] );
    set(handles.btnConnect, 'Enable','off');
    set(handles.btnDisconnect, 'Enable','off');
    set(handles.btnCreateDevice, 'Enable','on');   
    set(handles.btnSearch, 'Enable','off');
    set(handles.cbxGrabType, 'Enable','off');
    set(handles.btnStartGrab, 'Enable','off');
    set(handles.btnStopGrab, 'Enable','off');    
    set(handles.btnRemote, 'Enable','off');
    set(handles.cbxRemote, 'Enable','off');    
    set(handles.btnLiveWindow, 'Enable','off');
    set(handles.cbxLiveWindow, 'Enable','off');
    set(handles.edtWhat, 'Enable','off');
    set(handles.edtValue, 'Enable','off');
    set(handles.cbxParamType, 'Enable','off');
    set(handles.btnSetParam, 'Enable','off');
    set(handles.btnGetParam, 'Enable','off');
else
    set( handles.lblInfo, 'String', 'Error in FreeDevice.' ) ;
end


% --- Executes on button press in btnSearch.
function btnSearch_Callback(hObject, eventdata, handles)
% hObject    handle to btnSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnSearch, 'Enable','off');
if SearchDevice
    set( handles.lblInfo, 'String', 'SearchDevice ok.' ) ;
else
    set( handles.lblInfo, 'String', 'Error in SearchDevice.' ) ;
end
set(handles.btnSearch, 'Enable','on');


% --- Executes on button press in btnConnect.
function btnConnect_Callback(hObject, eventdata, handles)
% hObject    handle to btnConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnConnect, 'Enable','off');
if ConnectDevice
    set(handles.cbxGrabType, 'Enable','on');
    set(handles.btnStartGrab, 'Enable','on');
    set(handles.btnDisconnect, 'Enable','on');
    set(handles.btnConnect, 'Enable','off');
    set( handles.lblInfo, 'String', 'ConnectDevice ok.' ) ;
else
    set( handles.lblInfo, 'String', 'Error in ConnectDevice.' ) ;
end    


% --- Executes on button press in btnDisconnect.
function btnDisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btnDisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnDisconnect, 'Enable','off');
if DisconnectDevice
    set(handles.cbxGrabType, 'Enable','off');
    set(handles.btnStartGrab, 'Enable','off');
    set(handles.btnStopGrab, 'Enable','off');
    set(handles.btnDisconnect, 'Enable','off');
    set(handles.btnConnect, 'Enable','on');    
    set( handles.lblInfo, 'String', 'DisconnectDevice ok.' ) ;
else
    set( handles.lblInfo, 'String', 'Error in ConnectDevice.' ) ;
end


% --- Executes on button press in btnStartGrab.
function btnStartGrab_Callback(hObject, eventdata, handles)
% hObject    handle to btnStartGrab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glbData;
% First determine datatype to grab
index=get( handles.cbxGrabType, 'Value' );
switch index
    case 1
        glbData.grabtype = uint32(IRBG_MEMOBJ_TEMPERATURES);
    case 2
        glbData.grabtype = uint32(IRBG_MEMOBJ_IR_DIGITFRAME);
    case 3
        glbData.grabtype = uint32(IRBG_MEMOBJ_BITMAP32); 
    otherwise
        glbData.grabtype = uint32(bitor( uint32(IRBG_MEMOBJ_BITMAP32), uint32(IRBG_MEMOBJ_FLIPV)));        
end;
% Now start grab and polling of frames
set(handles.btnStartGrab, 'Enable','off');
if StartGrab(hObject, handles)
    set( handles.lblInfo, 'String', 'StartGrab ok.' ) ;
    set(handles.btnStopGrab, 'Enable','on');
    PollForNewFrames(hObject, handles);
    if StopGrab;
        set(handles.btnStartGrab, 'Enable','on'); 
    else
        set( handles.lblInfo, 'String', 'Error in StopGrab.' ) ;            
    end
else
    set( handles.lblInfo, 'String', 'Error in StartGrab.' ) ;    
end


% --- Executes on selection change in cbxGrabType.
function cbxGrabType_Callback(hObject, eventdata, handles)
% hObject    handle to cbxGrabType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cbxGrabType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cbxGrabType
set(handles.cbxGrabType, 'Enable','off');
global glbData;
index=get( handles.cbxGrabType, 'Value' );
switch index
    case 1
        glbData.grabtype = uint32(IRBG_MEMOBJ_TEMPERATURES);
    case 2
        glbData.grabtype = uint32(IRBG_MEMOBJ_IR_DIGITFRAME);
    % grab directly bitmap RGB values  is not implemented in Matlab-DemoApp
    % in conjunction with IRBG_PARAM_SDK_NeedBitmap32 = 181; IRBG_DATATYPE_INT32 as Boolean  
    % case 3
    %    glbData.grabtype = uint32(IRBG_MEMOBJ_BITMAP32); 
    % case 3
    %    glbData.grabtype = uint32(bitor( uint32(IRBG_MEMOBJ_BITMAP32), uint32(IRBG_MEMOBJ_FLIPV)));         
end
set(handles.cbxGrabType, 'Enable','on');


% --- Executes on button press in btnStopGrab.
function btnStopGrab_Callback(hObject, eventdata, handles)
% hObject    handle to btnStopGrab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnStopGrab, 'Enable','off');
%since polling loop for new frames is running, first interrupt this loop
global glbData;
if glbData.pollingActive 
    glbData.stopPollingReq=true;
end    

% --- Executes on button press in btnLiveWindow.
function btnLiveWindow_Callback(hObject, eventdata, handles)
% hObject    handle to btnLiveWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnLiveWindow, 'Enable','off');
if SwitchLiveWnd(hObject, handles);
    set( handles.lblInfo, 'String', 'Set LiveWindow ok.' ) ;    
else
    set( handles.lblInfo, 'String', 'Error in set LiveWindow.' ) ;    
end
set(handles.btnLiveWindow, 'Enable','on');

% --- Executes on button press in btnRemote.
function btnRemote_Callback(hObject, eventdata, handles)
% hObject    handle to btnRemote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnRemote, 'Enable','off');
if SwitchRemoteWnd(hObject, handles);
    set( handles.lblInfo, 'String', 'Set RemoteWindow ok.' ) ;    
else
    set( handles.lblInfo, 'String', 'Error in set RemoteWindow.' ) ;    
end
set(handles.btnRemote, 'Enable','on');

% --- Executes on button press in btnGetParam.
function btnGetParam_Callback(hObject, eventdata, handles)
% hObject    handle to btnGetParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnGetParam, 'Enable','off');
if btnGetParam(hObject, handles);
    set( handles.lblInfo, 'String', 'GetParam ok.' ) ;    
else
    set( handles.lblInfo, 'String', 'Error in GetParam.' ) ;    
end
set(handles.btnGetParam, 'Enable','on');

% --- Executes on button press in btnSetParam.
function btnSetParam_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnSetParam, 'Enable','off');
if btnSetParam(hObject, handles);
    set( handles.lblInfo, 'String', 'SetParam ok.' ) ;    
else
    set( handles.lblInfo, 'String', 'Error in SetParam.' ) ;    
end
set(handles.btnSetParam, 'Enable','on');

% --- Executes during object creation, after setting all properties.
function dlgDemo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dlgDemo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
InitEnvironment;


% --- Executes during object deletion, before destroying properties.
function dlgDemo_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to dlgDemo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CleanUpEnvironment;
