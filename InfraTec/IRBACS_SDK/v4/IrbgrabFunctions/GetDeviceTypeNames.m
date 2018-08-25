function Result=GetDeviceTypeNames(hObject,handles)
Result=false;

if ~libisloaded ('irbgrablib')
    return
end
bufsz=10000; % yes, this is absolut to much, but that doen't matter
CharBuffer = blanks(bufsz-1);
CharBuffer(bufsz)=0;
pCharBuffer = libpointer('voidPtr',uint8(CharBuffer));

retval=irbg_dll_devicetypenames(pCharBuffer, bufsz);
if retval ~= IRBG_RET_OK 
    disp(['Get device type names failed (Result=0x',int2str( dec2hex(retval,8)),')']);
    disp(['GetDeviceTypeNames: ', ErrorCodeToString(retval)]);
    return 
end

deviceTypeNames = char(pCharBuffer.value); 
strDevTypes=textscan(deviceTypeNames, '%s','Delimiter',';' );

if numel(strDevTypes)>0
    set(handles.cbxDevices,'String', strDevTypes{1});
end

guidata(hObject, handles);
drawnow

Result=true;

