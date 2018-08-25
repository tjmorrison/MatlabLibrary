
// typedef is not compatible to Matlab - only internal basic types should be used
/* 
typedef DWORD TIRBgrabRet; // Typedefs are not recognized in Matlab, so they are mapped to internal available types
typedef HANDLE TIRBgrabDev;
typedef HANDLE TIRBgrabMem;
*/

// function pointer are not compatible to Matlab
// typedef void (__stdcall *TIRBgrabOnNewFrame)( unsigned long long aHandle, int aStreamIndex);

struct TIRBG_String
{
	void* Text; // char* Text
	int Len;
};

struct TIRBG_IdxPointer
{
	int Index;
	unsigned long long Value;
};

struct TIRBG_IdxHandle
{
	int Index;
	unsigned long long Value;
};

struct TIRBG_IdxInt32
{
	int Index;
	int Value;
};

struct TIRBG_IdxInt64
{
	int Index;
	long long Value;
};

struct TIRBG_IdxSingle
{
	int Index;
	float Value;
};

struct TIRBG_IdxDouble
{
	int Index;
	double Value;
};

struct TIRBG_IdxString
{
	unsigned int Index;
	// struct TIRBG_String Value; // nested struct is not supported in Matlab
	unsigned int ptr2TextLowerPart; // char* Text is a 64 bit pointer. But there is a alignment issue in Matlab;
    unsigned int ptr2TextHigherPart;
	unsigned int Len;    
};

struct TIRBG_CallBack
{
	unsigned long long FuncPtr;
	unsigned long long Context;
};

struct TIRBG_2Pointer
{
	void* ptr1;
	void* ptr2;
};

struct TIRBG_2Int32
{
	int Value1;
	int Value2;
};

struct TIRBG_2Int64
{
	long long Value1;
	long long Value2;
};

struct TIRBG_2Single
{
	float Value1;
	float Value2;
};

struct TIRBG_2Double
{
	double Value1;
	double Value2;
};

struct TIRBG_2String
{
	void* Text1; // char* Text1;
	int Len1;
	void* Text2; // char* Text2;
	int Len2;
};

struct TIRBG_2IDxString
{
	// TIRBG_IdxString Val1; // nested struct is not supported in Matlab
	int Index1;
	void* Text1; // char* Text1; 
	int Len1;        
    // TIRBG_IdxString Val2; // nested struct is not supported in Matlab
	int Index2;
	void* Text2; // char* Text2; 
	int Len2;        
};

struct TIRBG_SendCommand
{
	void* Command; // char* Command;
	void* Answer;  // char* Answer;
	int AnswerSize;
	int TimeoutMS;
};

struct TIRBG_WindowMode
{
	int Index;
	int CamIndex;
	int Offx;
	int Offy;
	int Width;
	int Height;
	char  Name[32];
};

struct TIRBG_MemInfo
{
    int StructSize; 
    int Triggered; // <> 0 --> frame is marked as triggered
    double TimeStamp;  // relative milliseconds
    unsigned long long ImageNum;  
    int MissedPackets; 
};

unsigned int _stdcall  irbgrab_dll_version(void* aDLLversion, unsigned int aMaxLen);
unsigned int _stdcall  irbgrab_dll_init();
unsigned int _stdcall  irbgrab_dll_uninit();
unsigned int _stdcall  irbgrab_dll_isinit(unsigned int* aInitCount);
unsigned int _stdcall  irbgrab_dll_devicetypenames(void* aDeviceTypeNames, unsigned int aParamSize);

unsigned int _stdcall  irbgrab_dll_pollframefuncptr(void* funcptr);
unsigned int _stdcall  irbgrab_dll_pollframegrab(unsigned long long* aHandle, int* streamidx );
unsigned int _stdcall  irbgrab_dll_pollframefinish(void);

unsigned int _stdcall  irbgrab_dev_create(unsigned long long* aHandle, unsigned int aDeviceIndex, const void* aIniFile);
unsigned int _stdcall  irbgrab_dev_free(unsigned long long aHandle);
unsigned int _stdcall  irbgrab_dev_search(unsigned long long aHandle, unsigned int* aDeviceCount);
unsigned int _stdcall  irbgrab_dev_connect(unsigned long long aHandle, const char *aConnectString);
unsigned int _stdcall  irbgrab_dev_disconnect(unsigned long long aHandle);
unsigned int _stdcall  irbgrab_dev_startgrab(unsigned long long aHandle, int aStreamIndex);
unsigned int _stdcall  irbgrab_dev_stopgrab(unsigned long long aHandle, int aStreamIndex);
unsigned int _stdcall  irbgrab_dev_setparam(unsigned long long aHandle, unsigned int aWhat, void* aDataPtr, unsigned int aDataType);
unsigned int _stdcall  irbgrab_dev_getparam(unsigned long long aHandle, unsigned int aWhat, void* aDataPtr, unsigned int aDataType);
unsigned int _stdcall  irbgrab_dev_getdata(unsigned long long aHandle, unsigned int aWhat, unsigned long long* aMemHandle);
unsigned int _stdcall  irbgrab_mem_getdimension(unsigned long long aMemHandle, unsigned int* aWidth, unsigned int* aHeight, unsigned int* aPixelDataType);
unsigned int _stdcall  irbgrab_mem_getdataptr(unsigned long long aMemHandle, unsigned long long* aDataPtr, unsigned int* aDataByteSize);
unsigned int _stdcall  irbgrab_mem_getheaderptr(unsigned long long aMemHandle, void** aHeaderPtr, unsigned int* aHeaderByteSize);
unsigned int _stdcall  irbgrab_mem_getirvalues(unsigned long long aMemHandle, float* aTempMin, float* aTempMax, float* aTempAvg, float* aStdDev);
unsigned int _stdcall  irbgrab_mem_getdigitalvalues(unsigned long long aMemHandle, unsigned short* aDigValMin, unsigned short* aDigValMax);
unsigned int _stdcall  irbgrab_mem_getinfo(unsigned long long aMemHandle, void* aMemInfo);
unsigned int _stdcall  irbgrab_mem_gettimestamp(unsigned long long aMemHandle, double* aTimeStamp);
unsigned int _stdcall  irbgrab_mem_free(unsigned long long* aMemHandle);
void         _stdcall  misc_movmem(unsigned long long aSrcPtr, void* aDstPtr, unsigned int aByteSize);
unsigned long long _stdcall  misc_pointertoint(void* ptr);


