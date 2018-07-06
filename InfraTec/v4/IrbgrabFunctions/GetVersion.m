function Result=GetVersion(hObject,handles)
Result=false;

if ~libisloaded ('irbgrablib')
    return
end
bufsz=256;
CharBuffer = blanks(bufsz-1);
CharBuffer(bufsz)=0;
pCharBuffer = libpointer('voidPtr',uint8(CharBuffer)); % null terminated string 

retval=irbg_dll_version(pCharBuffer, bufsz);
if retval ~= IRBG_RET_OK 
    disp(['Get version failed (Result=0x',int2str( dec2hex(retval,8)),')']);
    disp(['Get version: ', ErrorCodeToString(retval)]);
    return 
end
DllVersion = char(pCharBuffer.value) ; 
set( handles.lblInfo, 'String', ['Load irbgrab lib ok. (Version: ',DllVersion,')'] ) ;

guidata(hObject, handles);
drawnow

Result=true;
