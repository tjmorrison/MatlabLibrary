
%define constants
define IRBG_RET_TYPE_MASK       hex2dec('F0000000');

%bits to distinguish return values
define IRBG_RET_TYPE_OK         hex2dec('10000000')
define IRBG_RET_TYPE_STATUS     hex2dec('20000000')
define IRBG_RET_TYPE_RESERVED   hex2dec('40000000')
define IRBG_RET_TYPE_ERR        hex2dec('80000000')

%not a valid return value (should never be passed as argument or returned)
define IRBG_RET_UNDEF           uint32(0)

%generic ok
define IRBG_RET_SUCCESS         uint32(bitor(IRBG_RET_TYPE_OK, hex2dec('01')))
define IRBG_RET_OK              IRBG_RET_SUCCESS

%status values
%generic ok status
define IRBG_RET_STATUS_OK		uint32(bitor(IRBG_RET_TYPE_STATUS, hex2dec('01')))

%in the process of establishing a connection
define IRBG_RET_CONNECTING		uint32(bitor(IRBG_RET_TYPE_STATUS, hex2dec('02')))
%connection is established, but no data has been exchanged yet
define IRBG_RET_CONNECTED		uint32(bitor(IRBG_RET_TYPE_STATUS, hex2dec('03')))

%communication is up and running
define IRBG_RET_RUNNING			uint32(bitor(IRBG_RET_TYPE_STATUS, hex2dec('04')))

%device has been connected and communicating (i.e. iosRunning) before,
%but lost its connection (e.g. cable has fallen off, peer is down,...)
define IRBG_RET_COMM_ERROR		uint32(bitor(IRBG_RET_TYPE_STATUS, hex2dec('05')))

%has been connected before and is gracefully disconnected
define IRBG_RET_DISCONNECTED	uint32(bitor(IRBG_RET_TYPE_STATUS, hex2dec('06')))

%generic unspecified error
define IRBG_RET_ERROR			uint32(bitor(IRBG_RET_TYPE_ERR, hex2dec('01')))
%feature is not supported
define IRBG_RET_NOT_SUPPORTED	uint32(bitor(IRBG_RET_TYPE_ERR, hex2dec('02')))
%generic "something" could not be found (maybe add some more specific errors later)
define IRBG_RET_NOT_FOUND		uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('03')))
%argument is out of range
define IRBG_RET_OUT_OF_RANGE	uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('04')))
%timeout elapsed
define IRBG_RET_TIMEOUT			uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('05')))
%failed to enter some critical section
define IRBG_RET_BLOCKED			uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('06')))
%something is unset/nil
define IRBG_RET_UNASSIGNED			uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('07')))
%binary incompatibilities detected (e.g. struct sizes differ')
define IRBG_RET_INCOMPATIBLE		uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('08')))
%buffer is too small bitor(is not neccessarily an error')
define IRBG_RET_BUFSIZE             uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('09')))
define IRBG_RET_CONFIG_ERROR		uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('0A')))
%no connection could be established - device has never been connected
define IRBG_RET_CONNECTION_ERROR	uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('0B')))
%invalid uint64
define IRBG_RET_INVALID_HANDLE		uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('0C')))
%invalid DataSize
define IRBG_RET_INVALID_DATASIZE	uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('0D')))
%invalid DataPointer
define IRBG_RET_INVALID_DATAPOINTER  uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('0E')))
%invalid Parameter
define IRBG_RET_INVALID_PARAMETER   uint32( bitor(IRBG_RET_TYPE_ERR , hex2dec('0F')))
%Object is Terminated
define IRBG_RET_TERMINATED			uint32(bitor(IRBG_RET_TYPE_ERR , hex2dec('10')))

define IRBG_WINDOW_CLOSE            int32(-1)
define IRBG_WINDOW_TOGGLE           int32(0)
define IRBG_WINDOW_SHOW             int32(1)
define IRBG_WINDOW_MINIMIZE         uint32(2)
define IRBG_WINDOW_RESTORE          uint32(3)

define IRBG_MEMOBJ_NONE             uint32(0)
define IRBG_MEMOBJ_BITMAP32         uint32(1) % Bitmap with 32Bit per pixel (A,R,G,B)
define IRBG_MEMOBJ_IR_DIGITFRAME    uint32(2) % IR-image with raw 16Bit (type word) values per pixel
define IRBG_MEMOBJ_TEMPERATURES     uint32(3) % IR-image with temperatures in Kelvin( type Single) per pixel
define IRBG_MEMOBJ_8BITDATA         uint32(4) % 8Bit-Data (from 0 = minTemp to 255 = maxTemp)


define IRBG_TYPE_RAW                uint32( hex2dec('00000000') )
define IRBG_TYPE_POINTER            uint32( hex2dec('10000000') )

define IRBG_TYPE_INT8               uint32( hex2dec('20000000') )
define IRBG_TYPE_INT16              uint32( hex2dec('30000000') )
define IRBG_TYPE_INT32              uint32( hex2dec('40000000') )
define IRBG_TYPE_INT64              uint32( hex2dec('50000000') )

define IRBG_TYPE_UINT8              uint32( hex2dec('60000000') )
define IRBG_TYPE_UINT16             uint32( hex2dec('70000000') )
define IRBG_TYPE_UINT32             uint32( hex2dec('80000000') )
define IRBG_TYPE_UINT64             uint32( hex2dec('90000000') )

define IRBG_TYPE_FLOAT32            uint32( hex2dec('A0000000') )
define IRBG_TYPE_FLOAT64            uint32( hex2dec('B0000000') )

define IRBG_TYPE_RECORD             uint32( hex2dec('E0000000') )
define IRBG_TYPE_STRING             uint32( hex2dec('F0000000') ) % String will be passed as PAnsiChar with Len(integer)

define IRBG_EXTTYP_MASK             uint32( hex2dec('0F000000') )
define IRBG_EXTYPE_NONE             uint32( hex2dec('00000000') )
define IRBG_EXTYPE_INDEX            uint32( hex2dec('01000000') ) % consist of an index (Int32) and a value
define IRBG_EXTYPE_ARRAY            uint32( hex2dec('02000000') ) % Array of DataType
define IRBG_EXTYPE_IDXARRAY         uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_EXTYPE_ARRAY ) ) % Array of (Indices (Int32) + values)
define IRBG_EXTYPE_ARRAY2           uint32( bitor( IRBG_EXTYPE_ARRAY, uint32( hex2dec('00020000') ) ) ) % Array[0..1] of DataType

define IRBG_DATATYPE_POINTER        uint32( bitor( IRBG_TYPE_POINTER, uint32(8) )) % sizeof(void*)
define IRBG_DATATYPE_HANDLE         IRBG_DATATYPE_POINTER
define IRBG_DATATYPE_INT32          uint32( bitor( IRBG_TYPE_INT32,   uint32(4) )) % sizeof(int32)
define IRBG_DATATYPE_INT64          uint32( bitor( IRBG_TYPE_INT64,   uint32(8) )) % sizeof(INT64)
define IRBG_DATATYPE_UINT16         uint32( bitor( IRBG_TYPE_UINT16,  uint32(2) )) % sizeof(WORD)
define IRBG_DATATYPE_SINGLE         uint32( bitor( IRBG_TYPE_FLOAT32, uint32(4) )) % sizeof(float)
define IRBG_DATATYPE_DOUBLE         uint32( bitor( IRBG_TYPE_FLOAT64, uint32(8) )) % sizeof(double)))
define IRBG_DATATYPE_STRING         uint32( bitor( IRBG_TYPE_STRING,  uint32(12) )) % sizeof(struct TIRBG_String)

define IRBG_DATATYPE_IDXPOINTER     uint32( bitor( uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_TYPE_POINTER)),    uint32(12) )) % sizeof(TIRBG_IdxPointer)
define IRBG_DATATYPE_IDXINT32       uint32( bitor( uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_TYPE_INT32)),      uint32(8)  )) % sizeof(TIRBG_IdxInt32)
define IRBG_DATATYPE_IDXINT64       uint32( bitor( uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_TYPE_INT64)),      uint32(12) )) % sizeof(TIRBG_IdxInt64)
define IRBG_DATATYPE_IDXSingle      uint32( bitor( uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_TYPE_FLOAT32)),    uint32(8)  )) % sizeof(TIRBG_IdxSingle)
define IRBG_DATATYPE_IDXDouble      uint32( bitor( uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_TYPE_FLOAT64)),    uint32(12) )) % sizeof(TIRBG_IdxDouble)
define IRBG_DATATYPE_IDXString      uint32( bitor( uint32( bitor( IRBG_EXTYPE_INDEX, IRBG_TYPE_STRING)),     uint32(16) )) % sizeof(TIRBG_IdxString)

define IRBG_DATATYPE_2POINTER       uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_TYPE_POINTER)),    uint32(16)  )) % sizeof(TIRBG_2Pointer)
define IRBG_DATATYPE_2INT32         uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_TYPE_INT32)),      uint32(8)   )) % sizeof(TIRBG_2Int32)
define IRBG_DATATYPE_2INT64         uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_TYPE_INT64)),      uint32(16)  )) % sizeof(TIRBG_2Int64)
define IRBG_DATATYPE_2Single        uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_TYPE_FLOAT32)),    uint32(8)   )) % sizeof(TIRBG_2Single)
define IRBG_DATATYPE_2Double        uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_TYPE_FLOAT64)),    uint32(16)  )) % sizeof(TIRBG_2Double)
define IRBG_DATATYPE_2String        uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_TYPE_STRING)),     uint32(24)  )) % sizeof(TIRBG_2String)

define IRBG_DATATYPE_2IdxString     uint32( bitor( uint32( bitor( IRBG_EXTYPE_ARRAY2, IRBG_DATATYPE_IDXString)), uint32(32)  )) % sizeof(TIRBG_2IdxString)

define IRBG_DATATYPE_CALLBACK       uint32(IRBG_DATATYPE_2POINTER)
define IRBG_DATATYPE_WINDOWMODE     uint32( bitor( IRBG_TYPE_RECORD, uint32(56) )) % sizeof(TIRBG_WindowMode)
define IRBG_DATATYPE_SENDCMD        uint32( bitor( IRBG_TYPE_RECORD, uint32(24) )) % sizeof(TIRBG_SendCommand)


define IRBG_PARAM_OnNewFrame                103 % IRBG_DATATYPE_CALLBACK
define IRBG_PARAM_RemoteWindow              111 % Int32 mit IRBG_WINDOW_xxx
define IRBG_PARAM_LiveWindow                113 % Int32 mit IRBG_WINDOW_xxx

define IRBG_PARAM_CameraDevice_Count        200 % IRBG_DATATYPE_INT32
define IRBG_PARAM_CameraDevice_Info         201 % IRBG_DATATYPE_IDXString --> What[0]|Value[0]...What[n]|Value[n]
define IRBG_PARAM_CameraDevice_ConnectStr   202 % IRBG_DATATYPE_IDXString --> can be passed on connect

define IRBG_PARAM_Camera_Connected          210 % IRBG_DATATYPE_INT32 as Boolean
define IRBG_PARAM_Camera_SerialNum          211 % IRBG_DATATYPE_INT64

define IRBG_PARAM_SendCommand               231 % IRBG_DATATYPE_SENDCMD

define IRBG_PARAM_Framerate_Hz              240 % IRBG_DATATYPE_SINGLE [Hz]
define IRBG_PARAM_Framerate_Max             241 % IRBG_DATATYPE_SINGLE [Hz]

define IRBG_PARAM_Sensor_Width              280 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Sensor_Height             281 % IRBG_DATATYPE_INT32

define IRBG_PARAM_Frame_FlipH               290 % IRBG_DATATYPE_INT32 as Boolean
define IRBG_PARAM_Frame_FlipV               291 % IRBG_DATATYPE_INT32 as Boolean
define IRBG_PARAM_Frame_Offsetx             292 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Frame_Offsety             293 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Frame_Width               294 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Frame_Height              295 % IRBG_DATATYPE_INT32

define IRBG_PARAM_Filter_Count              320 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Filter_Pos                321 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Filter_PosLive            322 % IRBG_DATATYPE_INT32

define IRBG_PARAM_Aperture_Count            330 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Aperture_Pos              331 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Aperture_PosLive          332 % IRBG_DATATYPE_INT32

define IRBG_PARAM_Trigger_GateItemCount     340 % IRBG_DATATYPE_INT32      Count of TriggerGate-Options
define IRBG_PARAM_Trigger_GateItem          341 % IRBG_DATATYPE_IDXString  Index must be set
define IRBG_PARAM_Trigger_GateIdx           342 % IRBG_DATATYPE_INT32      Index
define IRBG_PARAM_Trigger_MarkItemCount     343 % IRBG_DATATYPE_INT32      Count of TriggerMark-Options
define IRBG_PARAM_Trigger_MarkItem          344 % IRBG_DATATYPE_IDXString  Index must be set
define IRBG_PARAM_Trigger_MarkIdx           345 % IRBG_DATATYPE_INT32      Index
define IRBG_PARAM_Trigger_SyncItemCount     346 % IRBG_DATATYPE_INT32      Count of TriggerSync-Options
define IRBG_PARAM_Trigger_SyncItem          347 % IRBG_DATATYPE_IDXString  Index must be set
define IRBG_PARAM_Trigger_SyncIdx           348 % IRBG_DATATYPE_INT32      Index
define IRBG_PARAM_Trigger_Out1ItemCount     349 % IRBG_DATATYPE_INT32      Count of TriggerOut1-Options
define IRBG_PARAM_Trigger_Out1Item          350 % IRBG_DATATYPE_IDXString  Index must be set
define IRBG_PARAM_Trigger_Out1Idx           351 % IRBG_DATATYPE_INT32      Index
define IRBG_PARAM_Trigger_Out2ITemCount     352 % IRBG_DATATYPE_INT32      Count of TriggerOut2-Options
define IRBG_PARAM_Trigger_Out2Item          353 % IRBG_DATATYPE_IDXString  Index must be set
define IRBG_PARAM_Trigger_Out2Idx           354 % IRBG_DATATYPE_INT32      Index

define IRBG_PARAM_Acq_FrameCount            380 % IRBG_DATATYPE_INT32  <0 AcqModulo ausgeschaltet  MaxFrameCount  abs(Value)
define IRBG_PARAM_Acq_Trigger               381 % IRBG_DATATYPE_INT32 as Boolean
define IRBG_PARAM_Acq_LineCount             382 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Acq_LineIndex             383 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Acq_Waterfall             384 % IRBG_DATATYPE_INT32  Waterfall  Value <> 0
define IRBG_PARAM_Acq_useFrameCount         385 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Acq_useLineCount          386 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Acq_useLineIndex          387 % IRBG_DATATYPE_INT32

define IRBG_PARAM_Focus_DeviceCount         460 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Focus_DeviceIndex         461 % IRBG_DATATYPE_INT32
define IRBG_PARAM_Focus_Init                462 % IRBG_DATATYPE_INT32  DeviceIndex
define IRBG_PARAM_Focus_DistRange           463 % IRBG_DATATYPE_SINGLE
define IRBG_PARAM_Focus_PosRel              464 % IRBG_DATATYPE_SINGLE
define IRBG_PARAM_Focus_PosRelSpeed         465 % IRBG_DATATYPE_SINGLE
define IRBG_PARAM_Focus_PosDistWant         466 % IRBG_DATATYPE_SINGLE [m]
define IRBG_PARAM_Focus_PosDistLive         467 % IRBG_DATATYPE_SINGLE [m]
define IRBG_PARAM_Focus_MoveRel             468 % IRBG_DATATYPE_SINGLE





